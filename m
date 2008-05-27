Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RNUWJ6021895
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 19:30:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RNU18w010761
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 19:30:08 -0400
Date: Tue, 27 May 2008 20:29:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080527202941.3315c762@gaivota>
In-Reply-To: <200805272357.48974.hverkuil@xs4all.nl>
References: <200805272313.18651.hverkuil@xs4all.nl>
	<20080527184104.07e242a0@gaivota>
	<200805272357.48974.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Handling of VIDIOC_G_STD and ENUMSTD in __video_do_ioctl
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


> > IMO, the proper solution would be to enumerate the grouped bitmasks,
> > as the code already does, plus all individual standards.
> >
> > So, it would return STD_SECAM and also STD_SECAM_L, STD_SECAM_Lc,
> > etc.
> 
> I'll take a closer look at this.

Ok.
> 
> One thing I'm unhappy about is the naming for some of the FMT callbacks: 
> it's rather confusing that V4L2_BUF_TYPE_VBI_CAPTURE maps to 
> vidioc_g_fmt_vbi and V4L2_BUF_TYPE_SLICED_VBI_CAPTURE maps to 
> vidioc_g_fmt_vbi_capture.

agreed.

> If you don't mind I'm going to change that.
> 
> I propose the following mapping:
> 
> V4L2_BUF_TYPE_VIDEO_CAPTURE -> vidioc_g_fmt_video_cap
> V4L2_BUF_TYPE_VIDEO_OVERLAY -> vidioc_g_fmt_video_overlay
> V4L2_BUF_TYPE_VBI_CAPTURE -> vidioc_g_fmt_vbi_cap
> V4L2_BUF_TYPE_SLICED_VBI_OUTPUT -> vidioc_g_fmt_sliced_vbi_output
> V4L2_BUF_TYPE_SLICED_VBI_CAPTURE -> vidioc_g_fmt_sliced_vbi_cap
> V4L2_BUF_TYPE_VIDEO_OUTPUT -> vidioc_g_fmt_video_output
> V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY -> vidioc_g_fmt_video_output_overlay
> V4L2_BUF_TYPE_VBI_OUTPUT -> vidioc_g_fmt_vbi_output
> V4L2_BUF_TYPE_PRIVATE -> vidioc_g_fmt_type_private
> 
> If you prefer something a bit shorter, then we can replace 'video' 
> by 'vid' and 'output' by 'out'.

A bit shorter seems better. What about this:

s/_video_/_vid_/
s/_overlay_/_ovr_/
s/_private_/_priv_/
s/_output_/_out_/


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
