Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HIKEp1005315
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 14:20:14 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HIK2Xu027175
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 14:20:02 -0400
Message-ID: <48A86E3B.4060105@hhs.nl>
Date: Sun, 17 Aug 2008 20:30:19 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <200808171709.51258.hverkuil@xs4all.nl>
In-Reply-To: <200808171709.51258.hverkuil@xs4all.nl>
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
> Hi all,
> 
> As part of my ongoing cleanup of the v4l subsystem I've been looking 
> into converting v4l from register_chrdev to register_chrdev_region. The 
> latter is more flexible and allows for a larger range of minor numbers. 
> In addition it allows us to intercept the release callback when the 
> char device's refcount reaches 0.
> 

Hans,

Thanks for doing this! You rock! I've been planning on cleaning up gspca's 
somewhat archaic disconnect handling for a while now and I was sorta waiting 
for something like this :) But I guess that that cleanup might be 2.6.28 material.

Anyways I've reviewed your patch and in general I like it, I only see one problem:

@@ -99,7 +130,8 @@ static void video_release(struct device
{
struct video_device *vfd = container_of(cd, struct video_device, dev);
-#if 1 /* keep */
+ return;
+#if 1 /* keep */
/* needed until all drivers are fixed */
if (!vfd->release)
return;
@@ -107,6 +139,7 @@ static void video_release(struct device
vfd->release(vfd);
}
+
static struct class video_class = {
.name = VIDEO_NAME,
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)


Here you basicly make the release callback of the video class device a no-op. 
First of all I think it would be better to just delete it then to add a return, 
which sort of hides its an empty function now.

More importantly, its wrong to make this a no-op. When a driver unregisters a 
v4l device, and all cdev usage has stopped there can still be open references 
to sysfs files of the video class device, but in this case currently the 
video_unregister_device call will lead to the vfd->release callback getting 
called freeing the vfd struct, which contains the class device.

I believe the way to fix this is todo a get on the kobj contained in the cdev 
in video_register_device before registering the class device, and then in the 
class device release callback do a put on this kobj.

Other then that it looks good!

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
