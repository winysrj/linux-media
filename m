Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKFs451009770
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 10:54:04 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAKFrr8I019500
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 10:53:53 -0500
Received: by nf-out-0910.google.com with SMTP id d3so256315nfc.21
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 07:53:53 -0800 (PST)
Message-ID: <30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
Date: Thu, 20 Nov 2008 10:53:52 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <1227054989.2389.33.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227054989.2389.33.camel@tux.localhost>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] radio-mr800: fix unplug
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

NACK

On Tue, Nov 18, 2008 at 7:36 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
>
> This patch fixes problems(kernel oopses) with unplug of device while
> it's working.
> Patch adds disconnect_lock mutex, changes usb_amradio_close and
> usb_amradio_disconnect functions and adds a lot of safety checks.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
>
> ---
>
> diff -r 1536e16ffdf1 linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c   Tue Nov 18 15:51:08 2008 -0200
> +++ b/linux/drivers/media/radio/radio-mr800.c   Wed Nov 19 03:27:59 2008 +0300
> @@ -142,6 +142,7 @@
>
>        unsigned char *buffer;
>        struct mutex lock;      /* buffer locking */
> +       struct mutex disconnect_lock;
>        int curfreq;
>        int stereo;
>        int users;
> @@ -210,6 +211,10 @@
>        int retval;
>        int size;
>
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
> +
>        mutex_lock(&radio->lock);
>
>        radio->buffer[0] = 0x00;
> @@ -242,6 +247,10 @@
>        int retval;
>        int size;
>        unsigned short freq_send = 0x13 + (freq >> 3) / 25;
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
>
>        mutex_lock(&radio->lock);
>
> @@ -296,18 +305,16 @@
>  {
>        struct amradio_device *radio = usb_get_intfdata(intf);
>
> +       mutex_lock(&radio->disconnect_lock);
> +       radio->removed = 1;
>        usb_set_intfdata(intf, NULL);
>
> -       if (radio) {
> +       if (radio->users == 0) {
>                video_unregister_device(radio->videodev);

video_unregister_device should _always_ be called once the device is
disconnect, no matter how many handles are still open.

> -               radio->videodev = NULL;
> -               if (radio->users) {
> -                       kfree(radio->buffer);
> -                       kfree(radio);
> -               } else {
> -                       radio->removed = 1;
> -               }
> +               kfree(radio->buffer);
> +               kfree(radio);

You should not be freeing memory here. The video_device release
callback should be used for this purpose. It is called once all open
file handles are closed and after video_unregister_device has been
called.

>        }
> +       mutex_unlock(&radio->disconnect_lock);
>  }
>
>  /* vidioc_querycap - query device capabilities */
> @@ -327,6 +334,10 @@
>                                struct v4l2_tuner *v)
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
>
>        if (v->index > 0)
>                return -EINVAL;
> @@ -354,6 +365,12 @@
>  static int vidioc_s_tuner(struct file *file, void *priv,
>                                struct v4l2_tuner *v)
>  {
> +       struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
> +
>        if (v->index > 0)
>                return -EINVAL;
>        return 0;
> @@ -364,6 +381,10 @@
>                                struct v4l2_frequency *f)
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
>
>        radio->curfreq = f->frequency;
>        if (amradio_setfreq(radio, radio->curfreq) < 0)
> @@ -377,6 +398,10 @@
>                                struct v4l2_frequency *f)
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
>
>        f->type = V4L2_TUNER_RADIO;
>        f->frequency = radio->curfreq;
> @@ -404,6 +429,10 @@
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
> +
>        switch (ctrl->id) {
>        case V4L2_CID_AUDIO_MUTE:
>                ctrl->value = radio->muted;
> @@ -417,6 +446,10 @@
>                                struct v4l2_control *ctrl)
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +
> +       /* safety check */
> +       if (radio->removed)
> +               return -EIO;
>
>        switch (ctrl->id) {
>        case V4L2_CID_AUDIO_MUTE:
> @@ -503,14 +536,26 @@
>  static int usb_amradio_close(struct inode *inode, struct file *file)
>  {
>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
> +       int retval;
>
>        if (!radio)
>                return -ENODEV;
> +
> +       mutex_lock(&radio->disconnect_lock);
>        radio->users = 0;
>        if (radio->removed) {
> +               video_unregister_device(radio->videodev);

Again, video_unregister_device should always be called from the usb
disconnect callback.

>                kfree(radio->buffer);
>                kfree(radio);

Again, memory should not be freed here. It should be freed by the
video_device release callback for reasons stated above.

> +
> +       } else {
> +               retval = amradio_stop(radio);
> +               if (retval < 0)
> +                       amradio_dev_warn(&radio->videodev->dev,
> +                               "amradio_stop failed\n");
>        }
> +
> +       mutex_unlock(&radio->disconnect_lock);
>        return 0;
>  }
>
> @@ -610,6 +655,7 @@
>        radio->usbdev = interface_to_usbdev(intf);
>        radio->curfreq = 95.16 * FREQ_MUL;
>
> +       mutex_init(&radio->disconnect_lock);

I suspect you'll find little need for this mutex once you have
properly implemented the video_device release callback. You may
however still need the removed flag as some usb calls obviously can't
be made once the device has been removed. For reference, please review
the stk-webcam driver as it implements this properly

>        mutex_init(&radio->lock);
>
>        video_set_drvdata(radio->videodev, radio);
>
>
>
> --
> Best regards, Klimov Alexey
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
