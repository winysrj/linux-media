Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69LWxvt018610
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 17:33:04 -0400
Received: from mailrelay006.isp.belgacom.be (mailrelay006.isp.belgacom.be
	[195.238.6.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69LRxgK013019
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 17:28:00 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "David Ellingsworth" <david@identd.dyndns.org>
Date: Wed, 9 Jul 2008 23:27:58 +0200
References: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
	<200807092135.38250.laurent.pinchart@skynet.be>
	<30353c3d0807091315j2bcfe355hfc2c4a6445f9be9a@mail.gmail.com>
In-Reply-To: <30353c3d0807091315j2bcfe355hfc2c4a6445f9be9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092327.59152.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix sysfs kobj ref count
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

Hi David,

On Wednesday 09 July 2008, David Ellingsworth wrote:
> On Wed, Jul 9, 2008 at 3:35 PM, Laurent Pinchart
>
> <laurent.pinchart@skynet.be> wrote:
> > On Wednesday 02 July 2008, David Ellingsworth wrote:
> >> On Tue, Jul 1, 2008 at 7:49 PM, David Ellingsworth
> >>
> >> I think I found a solution to the above issue. I removed the lock from
> >> video_release and the main portion of video_close and wrapped the two
> >> calls to kobject_put by the videodev_lock. Since video_close is called
> >> when the BKL is held the lock is not required around the main portion
> >> of video_close. Acquiring the lock around the calls to kobject_put
> >> insures video_release is always called while the lock is being held.
> >> This should fix the above race condition between device_unregister and
> >> video_open as well. Here is the corrected patch.
> >
> > The kernel is moving away from the BKL. We might not want to rely on it
> > in new code. Any opinion on this ?
>
> To address this issue I think we should seriously consider converting
> videodev to use char_dev. Char_dev already exhibits the behavior
> provided by this patch and has already been rewritten with the
> elimination of the BKL in mind.

That seems a good idea to me. I'll have to check the char_dev API in details.

> In the mean time, this patch should 
> allow developers to reap the benefits of kobject release callback
> ocuring at the proper time and prepare their drivers for the
> conversion of videodev. Once converted, we should be able to remove
> video_open and video_close entirely. However, unless we can remove
> video_ioctl2's use of the internal video_device array, we must
> continue to intercept the kobject release callback in order to update
> the video_device array appropriately.

Do you mean video_devdata() ? As long as we provide a way to map from a struct 
file * to a struct video_dev * we shouldn't have any issue. This doesn't 
necessarily require a global video_device array.

If I'm not mistaken, converting to char_dev means we can use inode->i_cdev to 
store a pointer to a struct video_dev *, provided struct video_dev contains a 
struct cdev instance.

For the open(), release() and ioctl() handler we could then map from struct 
inode * to struct video_dev * instead. For other operations we might need to 
use file->private_data, but that field is currently used by driver to store 
per-instance file information.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
