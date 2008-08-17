Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HJmCYs010711
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:48:12 -0400
Received: from smtp-vbr10.xs4all.nl (smtp-vbr10.xs4all.nl [194.109.24.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HJm1lr000568
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 15:48:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Sun, 17 Aug 2008 21:46:45 +0200
References: <200808171709.51258.hverkuil@xs4all.nl> <48A86E3B.4060105@hhs.nl>
In-Reply-To: <48A86E3B.4060105@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808172146.45683.hverkuil@xs4all.nl>
Cc: Mike Isely <isely@isely.net>, v4l <video4linux-list@redhat.com>,
	david@identd.dyndns.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L2: switch to register_chrdev_region: needs testing/review of
	release() handling
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

Hi Hans,

On Sunday 17 August 2008 20:30:19 Hans de Goede wrote:
> Hans Verkuil wrote:
> > Hi all,
> >
> > As part of my ongoing cleanup of the v4l subsystem I've been
> > looking into converting v4l from register_chrdev to
> > register_chrdev_region. The latter is more flexible and allows for
> > a larger range of minor numbers. In addition it allows us to
> > intercept the release callback when the char device's refcount
> > reaches 0.
>
> Hans,
>
> Thanks for doing this! You rock! 

Thanks! :-)

> I've been planning on cleaning up 
> gspca's somewhat archaic disconnect handling for a while now and I
> was sorta waiting for something like this :) But I guess that that
> cleanup might be 2.6.28 material.
>
> Anyways I've reviewed your patch and in general I like it, I only see
> one problem:
>
> @@ -99,7 +130,8 @@ static void video_release(struct device
> {
> struct video_device *vfd = container_of(cd, struct video_device,
> dev); -#if 1 /* keep */
> + return;
> +#if 1 /* keep */
> /* needed until all drivers are fixed */
> if (!vfd->release)
> return;
> @@ -107,6 +139,7 @@ static void video_release(struct device
> vfd->release(vfd);
> }
> +
> static struct class video_class = {
> .name = VIDEO_NAME,
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
>
>
> Here you basicly make the release callback of the video class device
> a no-op. First of all I think it would be better to just delete it
> then to add a return, which sort of hides its an empty function now.

I thought so as well, but without a release function the low-level class 
code in the kernel starts complaining about the missing release.

> More importantly, its wrong to make this a no-op. When a driver
> unregisters a v4l device, and all cdev usage has stopped there can
> still be open references to sysfs files of the video class device,
> but in this case currently the video_unregister_device call will lead
> to the vfd->release callback getting called freeing the vfd struct,
> which contains the class device.

You might have gotten confused here: video_release() didn't call the 
main release callback: there was a return in front. I'd forgotten to 
remove that test code.

I've also tested what happens when you keep a sysfs file open: it seems 
to work OK in that video_release is called even though the sysfs file 
is still open. That said, I've moved the cdev_del call from 
video_unregister_device() to the video_release() function. It makes 
sense not to delete the char device until that callback is called.

This patch is here: 
http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/rev/575997018499

> I believe the way to fix this is todo a get on the kobj contained in
> the cdev in video_register_device before registering the class
> device, and then in the class device release callback do a put on
> this kobj.

There is no need to do an additional get: cdev_init does that already, 
so the char dev stays alive at least until the cdev_del (longer if apps 
still keep it open).

> Other then that it looks good!

Thanks, I've been wanting to do this for some time now and I finally had 
the time today to go in and dig through all the refcounting and how 
chardev handles things so that I could come up with a proper solution. 
What's nice is that this approach works also fine in older kernels 
(well, it compiles, I guess I need to do a real test on an older kernel 
before I can commit it in v4l-dvb). And that is very nice since the 
v4l-dvb repository is supposed to support any kernel >= 2.6.16.

I would be very curious to hear how well it works with the gspca driver. 
In particular if you can indeed reconnect while an application still 
has a char device open from before the disconnect. Currently the gspca 
own locking seems to disallow that (the new device doesn't appear until 
all applications stopped using the old one).

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
