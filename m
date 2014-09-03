Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:46604 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaICLjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 07:39:12 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBB003ZIPPBRK20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 07:39:11 -0400 (EDT)
Date: Wed, 03 Sep 2014 08:39:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.18] cx23885: convert to the latest frameworks,
 including vb2.
Message-id: <20140903083907.54fd63ae.m.chehab@samsung.com>
In-reply-to: <53EC8A32.8020104@xs4all.nl>
References: <53EC8A32.8020104@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Aug 2014 12:06:42 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This pull request converts the cx23885 driver to the latest V4L2 core
> frameworks, removing about 1000 lines in the process.
> 
> It now passes the v4l2-compliance tests and, frankly, feels much more
> robust.
> 
> I have tested this with my HVR-1800 board with video (compressed and
> uncompressed), vbi, dvb and alsa.
> 
> As usual, the vb2 conversion is a beast of a patch. But the vb2 conversion
> affected video, vbi, dvb and alsa, so it's all over the place. And it is
> all or nothing. See the commit log of that patch for some more information.
> 
> It also changed the risc code to simplify the code and to get rid of all
> the timeouts that were copied-and-pasted from cx88. If anyone knows of a
> reason for these timeouts, please let me know. I have tried to separate the
> risc code changes from the vb2 changes, but that was impossible to get to
> work with vb1.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:
> 
>    [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/hverkuil/media_tree.git cx23b
> 
> for you to fetch changes up to 295df1a7021a09ccaa3a478acbb4ed1e9fb4a023:
> 
>    cx23885: Add busy checks before changing formats (2014-08-14 11:43:36 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (21):
>        vb2: fix wrong gfp flags
>        cx23885: fix querycap
>        cx23885: fix audio input handling
>        cx23885: support v4l2_fh and g/s_priority
>        cx23885: use core locking, switch to unlocked_ioctl.
>        cx23885: convert to the control framework
>        cx23885: convert 417 to the control framework
>        cx23885: fix format colorspace compliance error
>        cx23885: map invalid fields to a valid field.
>        cx23885: drop radio-related dead code
>        cx23885: drop type field from struct cx23885_fh
>        cx23885: drop unused clip fields from struct cx23885_fh
>        cx23885: fmt, width and height are global, not per-fh.
>        cx23885: drop videobuf abuse in cx23885-alsa
>        cx23885: use video_drvdata to get cx23885_dev pointer
>        cx23885: convert to vb2

This one I didn't apply. See the comments on a separate email.

>        cx23885: fix field handling
>        cx23885: fix weird sizes.

Didn't apply the two above, as they likely depend on vb2 conversion.

>        cx23885: remove FSF address as per checkpatch

This one is so trivial that I applied it too.

>        cx23885: remove btcx-risc dependency
>        cx23885: Add busy checks before changing formats

Also depends on vb2 changes.

Regards,
Mauro
