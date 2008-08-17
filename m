Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HLJRC8025690
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:19:27 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HLIlBk010791
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:18:47 -0400
Message-ID: <48A8981E.3060808@hhs.nl>
Date: Sun, 17 Aug 2008 23:29:02 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200808171709.51258.hverkuil@xs4all.nl> <48A86E3B.4060105@hhs.nl>
	<200808172146.45683.hverkuil@xs4all.nl>
In-Reply-To: <200808172146.45683.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mike Isely <isely@isely.net>, v4l <video4linux-list@redhat.com>,
	david@identd.dyndns.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L2: switch to register_chrdev_region: needs testing/review
 of release() handling
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

Hans Verkuil wrote:
>> Anyways I've reviewed your patch and in general I like it, I only see
>> one problem:
>>
>> @@ -99,7 +130,8 @@ static void video_release(struct device
>> {
>> struct video_device *vfd = container_of(cd, struct video_device,
>> dev); -#if 1 /* keep */
>> + return;
>> +#if 1 /* keep */
>> /* needed until all drivers are fixed */
>> if (!vfd->release)
>> return;
>> @@ -107,6 +139,7 @@ static void video_release(struct device
>> vfd->release(vfd);
>> }
>> +
>> static struct class video_class = {
>> .name = VIDEO_NAME,
>> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
>>
>>
>> Here you basicly make the release callback of the video class device
>> a no-op. First of all I think it would be better to just delete it
>> then to add a return, which sort of hides its an empty function now.
> 
> I thought so as well, but without a release function the low-level class 
> code in the kernel starts complaining about the missing release.
> 

I wasn't clear with delete I only meant the body.

>> More importantly, its wrong to make this a no-op. When a driver
>> unregisters a v4l device, and all cdev usage has stopped there can
>> still be open references to sysfs files of the video class device,
>> but in this case currently the video_unregister_device call will lead
>> to the vfd->release callback getting called freeing the vfd struct,
>> which contains the class device.
> 
> You might have gotten confused here: video_release() didn't call the 
> main release callback: there was a return in front. I'd forgotten to 
> remove that test code.
> 

I'm not talking about video_release, I'm talking about the following call chain:
video_device_unregister
cdev_del
kobj_put
v4l2_chardev_release
vfd->release

Which could happen in your old version (before the cdev_del was moved) even 
when a class device sysfs file was still open, and thus sysfs read / write 
callbacks which may use the (now released) vfd could still be made after the 
release.

> I've also tested what happens when you keep a sysfs file open: it seems 
> to work OK in that video_release is called even though the sysfs file 
> is still open.

That should not happen, if a process holds a sysfs file open the release 
callback for the device which owns the sysfs file should not get called, are 
you sure this is happening, if the device then does a read / write on this file 
mayhem could happen, or does the kernel catch this now a days and just returns 
-ENODEV?

> That said, I've moved the cdev_del call from 
> video_unregister_device() to the video_release() function. It makes 
> sense not to delete the char device until that callback is called.
>

Yes, that will fix the problem I was trying to describe too.

> This patch is here: 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/rev/575997018499
> 
>> I believe the way to fix this is todo a get on the kobj contained in
>> the cdev in video_register_device before registering the class
>> device, and then in the class device release callback do a put on
>> this kobj.
> 
> There is no need to do an additional get: cdev_init does that already, 
> so the char dev stays alive at least until the cdev_del (longer if apps 
> still keep it open).
> 

Well since the code was registering a class device which shared the same in 
memory struct, we needed an additional put on the cdev kobj, as once the 
refcount for that got to 0 the entire vfd struct including the class device 
would get released.

But now that you've moved the cdev_del this is moot, as now the ref_count won't 
reach zero until all users of the class device are done with it.

> I would be very curious to hear how well it works with the gspca driver. 
> In particular if you can indeed reconnect while an application still 
> has a char device open from before the disconnect. Currently the gspca 
> own locking seems to disallow that (the new device doesn't appear until 
> all applications stopped using the old one).
> 

This is on my todo, but not very high atm.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
