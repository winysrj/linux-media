Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:45019 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaEXTcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 15:32:21 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6300LDTFLV4590@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 24 May 2014 15:32:19 -0400 (EDT)
Date: Sat, 24 May 2014 16:32:14 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.16] davinci updates
Message-id: <20140524163214.6796f264.m.chehab@samsung.com>
In-reply-to: <53805338.50301@xs4all.nl>
References: <537F0FCD.207@xs4all.nl>
 <20140523194545.4793e1a0.m.chehab@samsung.com> <53805338.50301@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 24 May 2014 10:07:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/24/2014 12:45 AM, Mauro Carvalho Chehab wrote:
> > Em Fri, 23 May 2014 11:07:25 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> Hi Mauro,
> >>
> >> These are cleanup patches for the davinci drivers. A total of about 1200 lines
> >> of code are removed. Not bad!
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>
> >> The following changes since commit e899966f626f1f657a4a7bac736c0b9ae5a243ea:
> >>
> >>   Merge tag 'v3.15-rc6' into patchwork (2014-05-21 23:03:15 -0300)
> >>
> >> are available in the git repository at:
> >>
> >>
> >>   git://linuxtv.org/hverkuil/media_tree.git davinci
> >>
> >> for you to fetch changes up to c1022cd59bb34dbb435cda9a2fc98bb6fb931f61:
> >>
> >>   media: davinci: vpif: add Copyright message (2014-05-23 10:12:34 +0200)
> >>
> >> ----------------------------------------------------------------
> >> Lad, Prabhakar (49):
> >>       media: davinci: vpif_display: initialize vb2 queue and DMA context during probe
> >>       media: davinci: vpif_display: drop buf_init() callback
> >>       media: davinci: vpif_display: use vb2_ops_wait_prepare/finish helper functions
> >>       media: davinci: vpif_display: release buffers in case start_streaming() call back fails
> >>       media: davinci: vpif_display: drop buf_cleanup() callback
> >>       media: davinci: vpif_display: improve vpif_buffer_prepare() callback
> >>       media: davinci: vpif_display: improve vpif_buffer_queue_setup() function
> >>       media: davinci: vpif_display: improve start/stop_streaming callbacks
> >>       media: davinci: vpif_display: use vb2_fop_mmap/poll
> >>       media: davinci: vpif_display: use v4l2_fh_open and vb2_fop_release
> >>       media: davinci: vpif_display: use vb2_ioctl_* helpers
> >>       media: davinci: vpif_display: drop unused member fbuffers
> >>       media: davinci: vpif_display: drop reserving memory for device
> >>       media: davinci: vpif_display: drop unnecessary field memory
> >>       media: davinci: vpif_display: drop numbuffers field from common_obj
> >>       media: davinic: vpif_display: drop started member from struct common_obj
> >>       media: davinci: vpif_display: initialize the video device in single place
> >>       media: davinci: vpif_display: drop unneeded module params
> >>       media: davinci: vpif_display: drop cropcap
> >>       media: davinci: vpif_display: group v4l2_ioctl_ops
> >>       media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
> >>       media: davinci: vpif_display: return -ENODATA for *dv_timings calls
> >>       media: davinci: vpif_display: return -ENODATA for *std calls
> >>       media: davinci; vpif_display: fix checkpatch error
> >>       media: davinci: vpif_display: fix v4l-complinace issues
> >>       media: davinci: vpif_capture: initalize vb2 queue and DMA context during probe
> >>       media: davinci: vpif_capture: drop buf_init() callback
> >>       media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper functions
> >>       media: davinci: vpif_capture: release buffers in case start_streaming() call back fails
> >>       media: davinci: vpif_capture: drop buf_cleanup() callback
> >>       media: davinci: vpif_capture: improve vpif_buffer_prepare() callback
> >>       media: davinci: vpif_capture: improve vpif_buffer_queue_setup() function
> >>       media: davinci: vpif_capture: improve start/stop_streaming callbacks
> >>       media: davinci: vpif_capture: use vb2_fop_mmap/poll
> >>       media: davinci: vpif_capture: use v4l2_fh_open and vb2_fop_release
> >>       media: davinci: vpif_capture: use vb2_ioctl_* helpers
> >>       media: davinci: vpif_capture: drop reserving memory for device
> >>       media: davinci: vpif_capture: drop unnecessary field memory
> >>       media: davinic: vpif_capture: drop started member from struct common_obj
> >>       media: davinci: vpif_capture: initialize the video device in single place
> > 
> >>       media: davinci: vpif_capture: drop unneeded module params
> > 
> > Enough!
> > 
> > I'm tired of guessing why those bad commented are needed and what them are
> > actually doing.
> > 
> > In this particular case:
> > 
> > Why those module parameters were needed before, but aren't needed anymore?
> > What changed? The removal of module parameters is a sort of API change.
> > 
> > So, I _DO_ expect them to be very well justified.
> > 
> > Please, properly describe _ALL_ patches, or I'll NACK the pull requests.
> > 
> > This time, I applied everything up to the patch before this one. On a next
> > pull request without proper descriptions, I'll likely just stop on the first
> > patch missing description (or with a crappy one).
> 
> Next time you see patches with insufficient commit log text just send them back
> with 'Changes Requested'. I don't mind since I have a bit of a blind spot for
> that myself. It's good training for me.
> 
> But in this case you accepted the patch ("drop unneeded module params") which
> really needed a better description (again, blind spot on my side, I should
> have caught that), 

Sorry, my fault. I was supposed to have reverted the merge of this one
before pushing at mainstream.

> and then stopped merging the remaining patches. But those
> remaining patches all have proper commit logs (at least in my view), so I am
> requesting that you pull in the remaining patches. 

Fair enough. I'll revert changeset b952662f272ae43c1583fac4dcda71ef36c33528,
and apply the remaining ones, if they're ok and don't depend on it.

> 
> If you think that the commit logs for the remaining patches isn't good enough,
> just let me know and I will improve them.

Ok.

> 
> Regards,
> 
> 	Hans
