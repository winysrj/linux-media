Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6053Jn021573
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 19:05:03 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB604ol4023050
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 19:04:50 -0500
Received: by ey-out-2122.google.com with SMTP id 4so104512eyf.39
	for <video4linux-list@redhat.com>; Fri, 05 Dec 2008 16:04:49 -0800 (PST)
Message-ID: <208cbae30812051604t6d74a0cbr4177262324563688@mail.gmail.com>
Date: Sat, 6 Dec 2008 03:04:49 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "David Ellingsworth" <david@identd.dyndns.org>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>
In-Reply-To: <30353c3d0811292119y226c5af3tb63dbf130da59c69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
	<1227410369.16932.31.camel@tux.localhost>
	<30353c3d0811240635t3649fa2bk5f5982c4d3d6e87c@mail.gmail.com>
	<1227787210.11477.7.camel@tux.localhost>
	<30353c3d0811292119y226c5af3tb63dbf130da59c69@mail.gmail.com>
Cc: video4linux-list@redhat.com
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

Hello, all

On Sun, Nov 30, 2008 at 8:19 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
>> Do this patch looks correct ? (it is fix for current hg-tree)
>> I'm still confused about part of probe-function where
>> video_register_device failed and we should free memory. Will disconnect
>> function be called if probe-function failed ?
>
> The disconnect function will not be called if the probe method fails.
> The usb subsystem only calls the disconnect function for successfully
> probed devices.
>> diff -r 602d3ac1f476 linux/drivers/media/radio/radio-mr800.c
>> --- a/linux/drivers/media/radio/radio-mr800.c   Thu Nov 20 19:47:37 2008 -0200
>> +++ b/linux/drivers/media/radio/radio-mr800.c   Wed Nov 26 17:29:54 2008 +0300
>> @@ -142,7 +142,6 @@
>>
>>        unsigned char *buffer;
>>        struct mutex lock;      /* buffer locking */
>> -       struct mutex disconnect_lock;
>>        int curfreq;
>>        int stereo;
>>        int users;
>> @@ -305,16 +304,12 @@
>>  {
>>        struct amradio_device *radio = usb_get_intfdata(intf);
>>
>> -       mutex_lock(&radio->disconnect_lock);
>> +       mutex_lock(&radio->lock);
>>        radio->removed = 1;
>> +       mutex_unlock(&radio->lock);
>> +
>>        usb_set_intfdata(intf, NULL);
>> -
>> -       if (radio->users == 0) {
>> -               video_unregister_device(radio->videodev);
>> -               kfree(radio->buffer);
>> -               kfree(radio);
>> -       }
>> -       mutex_unlock(&radio->disconnect_lock);
>> +       video_unregister_device(radio->videodev);
>>  }
>>
>>  /* vidioc_querycap - query device capabilities */
>> @@ -532,7 +527,7 @@
>>        return 0;
>>  }
>>
>> -/*close device - free driver structures */
>> +/*close device */
>>  static int usb_amradio_close(struct inode *inode, struct file *file)
>>  {
>>        struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>> @@ -541,21 +536,15 @@
>>        if (!radio)
>>                return -ENODEV;
>>
>> -       mutex_lock(&radio->disconnect_lock);
>>        radio->users = 0;
>> -       if (radio->removed) {
>> -               video_unregister_device(radio->videodev);
>> -               kfree(radio->buffer);
>> -               kfree(radio);
>>
>> -       } else {
>> +       if (!radio->removed) {
>>                retval = amradio_stop(radio);
>>                if (retval < 0)
>>                        amradio_dev_warn(&radio->videodev->dev,
>>                                "amradio_stop failed\n");
>>        }
>>
>> -       mutex_unlock(&radio->disconnect_lock);
>>        return 0;
>>  }
>>
>> @@ -612,12 +601,30 @@
>>        .vidioc_s_input     = vidioc_s_input,
>>  };
>>
>> +static void usb_amradio_device_release(struct video_device *videodev)
>> +{
>> +       struct amradio_device *radio = video_get_drvdata(videodev);
>> +
>> +       mutex_lock(&radio->lock);
>
> The lock here is completely unnecessary for you are guaranteed the
> structure is not in use due to the reference counting done by the v4l2
> core.
>
>> +
>> +       /* we call v4l to free radio->videodev */
>> +       video_device_release(videodev);
>> +
>> +       /* free rest memory */
>> +       kfree(radio->buffer);
>> +       kfree(radio);
>> +
>> +       mutex_unlock(&radio->lock);

> Again, wrong for the above reason but worse cause you are referencing
> freed memory.

Yes, you are right!
I removed them.

>> +}
>> +
>> +
>> +
>>  /* V4L2 interface */
>>  static struct video_device amradio_videodev_template = {
>>        .name           = "AverMedia MR 800 USB FM Radio",
>>        .fops           = &usb_amradio_fops,
>>        .ioctl_ops      = &usb_amradio_ioctl_ops,
>> -       .release        = video_device_release,
>> +       .release        = usb_amradio_device_release,
>>  };
>>
>>  /* check if the device is present and register with v4l and
>> @@ -655,15 +662,12 @@
>>        radio->usbdev = interface_to_usbdev(intf);
>>        radio->curfreq = 95.16 * FREQ_MUL;
>>
>> -       mutex_init(&radio->disconnect_lock);
>>        mutex_init(&radio->lock);
>>
>>        video_set_drvdata(radio->videodev, radio);
>>        if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
>>                dev_warn(&intf->dev, "could not register video device\n");
>> -               video_device_release(radio->videodev);
>> -               kfree(radio->buffer);
>> -               kfree(radio);
>> +               video_unregister_device(radio->videodev);
>
> This is wrong. When video_register_device fails, you should not call
> video_unregister_device. You should free any allocated memory and
> return an error code. The prior code here was correct.

Okay, i didn't know about when disconnect-function called, so i asked.
I return former code.

Thanks for reviewing again. It's really help me.

If there is no more mistakes..

Mauro, should i make patch for current hg-tree ? Or you want revert
previous patch ?
What is the options here?
Probably this thing should go to current upstream, because it will fix an oops.
I start working to fix the same oops in dsbr100 module.

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
