Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOEaOx6017393
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 09:36:24 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOEZtos019730
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 09:35:56 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1057667nfc.21
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 06:35:55 -0800 (PST)
Message-ID: <30353c3d0811240635t3649fa2bk5f5982c4d3d6e87c@mail.gmail.com>
Date: Mon, 24 Nov 2008 09:35:55 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <1227410369.16932.31.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
	<1227410369.16932.31.camel@tux.localhost>
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

On Sat, Nov 22, 2008 at 10:19 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello, David
>
> On Thu, 2008-11-20 at 10:53 -0500, David Ellingsworth wrote:
>> NACK
>
>> video_unregister_device should _always_ be called once the device is
>> disconnect, no matter how many handles are still open.
>>
>> > -               radio->videodev = NULL;
>> > -               if (radio->users) {
>> > -                       kfree(radio->buffer);
>> > -                       kfree(radio);
>> > -               } else {
>> > -                       radio->removed = 1;
>> > -               }
>> > +               kfree(radio->buffer);
>> > +               kfree(radio);
>>
>> You should not be freeing memory here. The video_device release
>> callback should be used for this purpose. It is called once all open
>> file handles are closed and after video_unregister_device has been
>> called.
>
> Well, things what you said make me feel ill at ease (feel
> uncomfortable). Looks like 3 usb radio drivers don't implement right
> disconnect and video release functions ?
> Generaly, i took order of release/kfree-functions from dsbr100 and
> si470x.

Yes, this is probably true. Not many drivers handled this properly
since the video_device release callback used to occur immediately
after calling video_unregister_device while the structure was
potentially still being used. Some drivers implemented a kref object
to work around this deficiency, others used a user count. Now that the
v4l2-core correctly calls this release after video_unregister_device
has been called and all open handles have been close, no work-arounds
are needed by v4l2 sub-drivers.

The suggested method to simply set the video_device release callback
to video_device_release was from the beginning flawed. The only
instance where it was actually safe to do so was in the vivi driver
since there was no way to abruptly remove the device while it was
still being used. All usb and pci devices can be removed at will and
have to properly handle that case. Sadly most do not. In my opinion,
the video_device_alloc and video_device_release functions should be
removed entirely, they only add unnecessary complexity to a v4l2
sub-driver.

Before the v4l2-core was fixed, if a driver set the release callback
to video_device_release and _always_ called video_unregister_device in
it's disconnect callback then the video_device struct used by the
driver would be immediately freed. Once the video_device struct had
been freed, any call to video_get_drvdata would fail and crash the
driver. Sub-drivers could then do one of two things to avoid this
crash, 1. not call video_unregister_device upon disconnect, or 2. set
the release callback to a null function. The problem with the first
method is that by not calling video_unregister_device the driver had
to ensure the device was present during the fops open callback, aka
handling a call to open after disconnect. The problem with the second
method is that the sub-driver had to implement it's own reference
count to determine when it was safe to free it's structure. Both
methods had their own challenges and neither was something that most
drivers got right.

>
>> Again, video_unregister_device should always be called from the usb
>> disconnect callback.
>>
>> >                kfree(radio->buffer);
>> >                kfree(radio);
>>
>> Again, memory should not be freed here. It should be freed by the
>> video_device release callback for reasons stated above.
>
> Ok. I were in deep quest of finding video_device release callback. I had
> release function only in file_operations, but it wasn't right function.
> Then i found video_device_release in video_device
> amradio_videodev_template.
> Looks like disconnect function called before video_device_release in all
> cases. And i need to call kfree(radio) after disconnect but before probe
> function(if device pluged in again).
>
> Do this general examples below look right ?

Yes, this looks correct.

>
> static struct video_device amradio_videodev_template = {
>        .name           = "AverMedia MR 800 USB FM Radio",
>        .fops           = &usb_amradio_fops,
>        .ioctl_ops      = &usb_amradio_ioctl_ops,
>        .release        = video_device_release_am,
> };
>
> I need my own release function, right ? To free radio structure.

Correct. You'll need your own function.

>
> void video_device_release_am(struct video_device *videodev)
> {
>        struct amradio_device *radio = video_get_drvdata(videodev);
>        printk("we are in video_device_release\n");
>        video_device_release(videodev);
>        kfree(radio->buffer);
>        kfree(radio);
> }
> May be something like "container_of" to get *radio from *videodev ? Or it's okay ?

Since the video_device struct is not embedded within the
amradio_device structure you can't use container_of to get a pointer
to the amradio_device structure. What you have here is correct. If you
choose to do so, I advocate embedding the video_device struct into the
amradio struct since it simplifies memory allocation. You would then
be able to use container_of in many places to go from the video_device
struct to the amradio_device struct.

>
> static void usb_amradio_disconnect(struct usb_interface *intf)
> {
>        struct amradio_device *radio = usb_get_intfdata(intf);
>
>        printk("disconnect called\n");
> //      mutex_lock(&radio->disconnect_lock);
>        radio->removed = 1;
>
>        usb_set_intfdata(intf, NULL);
>        video_unregister_device(radio->videodev);
>
> //      mutex_unlock(&radio->disconnect_lock);
> }
>
>> I suspect you'll find little need for this mutex once you have
>> properly implemented the video_device release callback. You may
>> however still need the removed flag as some usb calls obviously can't
>> be made once the device has been removed. For reference, please review
>> the stk-webcam driver as it implements this properly

If you have a general mutex, which you should, for locking access to
the amradio_device struct it should probably be used here while
setting the removed member to 1. Admittedly, stk-webcam currently
lacks the required mutex. The state change in it's disconnect callback
is not safe and should be protected by a general mutex, as should
operations in it's open, release, and read functions. I merely haven't
had the time to submit a patch to correct it.

>
> Thanks for pointing this out. I think that disconnect lock is not
> necessarily.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
