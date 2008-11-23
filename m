Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAN3Jchr027522
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 22:19:38 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAN3JC8Q014977
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 22:19:12 -0500
Received: by ug-out-1314.google.com with SMTP id j30so491952ugc.13
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 19:19:11 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 06:19:29 +0300
Message-Id: <1227410369.16932.31.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Hello, David

On Thu, 2008-11-20 at 10:53 -0500, David Ellingsworth wrote:
> NACK

> video_unregister_device should _always_ be called once the device is
> disconnect, no matter how many handles are still open.
> 
> > -               radio->videodev = NULL;
> > -               if (radio->users) {
> > -                       kfree(radio->buffer);
> > -                       kfree(radio);
> > -               } else {
> > -                       radio->removed = 1;
> > -               }
> > +               kfree(radio->buffer);
> > +               kfree(radio);
> 
> You should not be freeing memory here. The video_device release
> callback should be used for this purpose. It is called once all open
> file handles are closed and after video_unregister_device has been
> called.

Well, things what you said make me feel ill at ease (feel
uncomfortable). Looks like 3 usb radio drivers don't implement right
disconnect and video release functions ?
Generaly, i took order of release/kfree-functions from dsbr100 and
si470x.

> Again, video_unregister_device should always be called from the usb
> disconnect callback.
> 
> >                kfree(radio->buffer);
> >                kfree(radio);
> 
> Again, memory should not be freed here. It should be freed by the
> video_device release callback for reasons stated above.

Ok. I were in deep quest of finding video_device release callback. I had
release function only in file_operations, but it wasn't right function.
Then i found video_device_release in video_device
amradio_videodev_template. 
Looks like disconnect function called before video_device_release in all
cases. And i need to call kfree(radio) after disconnect but before probe
function(if device pluged in again).

Do this general examples below look right ?

static struct video_device amradio_videodev_template = {
        .name           = "AverMedia MR 800 USB FM Radio",
        .fops           = &usb_amradio_fops,
        .ioctl_ops      = &usb_amradio_ioctl_ops,
        .release        = video_device_release_am,
};

I need my own release function, right ? To free radio structure.

void video_device_release_am(struct video_device *videodev)
{
        struct amradio_device *radio = video_get_drvdata(videodev);
        printk("we are in video_device_release\n");
        video_device_release(videodev);
        kfree(radio->buffer);
        kfree(radio);
}
May be something like "container_of" to get *radio from *videodev ? Or it's okay ?

static void usb_amradio_disconnect(struct usb_interface *intf)
{
        struct amradio_device *radio = usb_get_intfdata(intf);

        printk("disconnect called\n");
//      mutex_lock(&radio->disconnect_lock);
        radio->removed = 1;

        usb_set_intfdata(intf, NULL);
        video_unregister_device(radio->videodev);

//      mutex_unlock(&radio->disconnect_lock);
}

> I suspect you'll find little need for this mutex once you have
> properly implemented the video_device release callback. You may
> however still need the removed flag as some usb calls obviously can't
> be made once the device has been removed. For reference, please review
> the stk-webcam driver as it implements this properly

Thanks for pointing this out. I think that disconnect lock is not
necessarily.


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
