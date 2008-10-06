Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m968gCWm021833
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 04:42:12 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m968g0kd027925
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 04:42:01 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KmlfD-0004RR-G7
	for video4linux-list@redhat.com; Mon, 06 Oct 2008 08:41:59 +0000
Received: from thrashbarg.mansr.com ([78.86.181.100])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 06 Oct 2008 08:41:59 +0000
Received: from mans by thrashbarg.mansr.com with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Mon, 06 Oct 2008 08:41:59 +0000
To: video4linux-list@redhat.com
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Mon, 06 Oct 2008 09:41:48 +0100
Message-ID: <yw1x63o6cdyr.fsf@thrashbarg.mansr.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D610739F@dbde02.ent.ti.com>
	<200810060829.25055.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
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

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On Monday 06 October 2008 08:06:30 Shah, Hardik wrote:
>> 4.  VIDIOC_S/G_OMAP2_COLORKEY:  Color keying allows the pixels with
>> the defined color on the video pipelines to be replaced with the
>> pixels on the graphics pipelines.  I believe similar feature must be
>> available on almost all next generation of video hardware. We can add
>> new ioctl for this feature in V4L2 framework. I think VIDIOC_S_FBUF
>> ioctl is used for setting up the buffer parameters on per buffer
>> basis.  So IMHO this ioctl is not a natural fit for the above
>> functionality. Please provide your comments on same.
>
> Do I understand correctly that if the color in the *video* streams 
> matches the colorkey, then it is replaced by the color in the 
> *framebuffer* (aka menu/overlay)? Usually it is the other way around: 
> if the framebuffer (menu) has chromakey pixels, then those pixels are 
> replaced by pixels from the video stream. That's what the current API 
> does.

The OMAP3 hardware supports both type of keying, but not
simultaneously.

-- 
Måns Rullgård
mans@mansr.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
