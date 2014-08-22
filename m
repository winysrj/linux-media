Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3610 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaHVRWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 13:22:42 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7MHMcol004856
	for <linux-media@vger.kernel.org>; Fri, 22 Aug 2014 19:22:40 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [172.20.26.89] (unknown [208.59.64.2])
	by tschai.lan (Postfix) with ESMTPSA id 042252A2E57
	for <linux-media@vger.kernel.org>; Fri, 22 Aug 2014 19:22:29 +0200 (CEST)
Message-ID: <53F77C5B.5090608@xs4all.nl>
Date: Fri, 22 Aug 2014 17:22:35 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.18] Various fixes
References: <53EC92EE.5050607@xs4all.nl>
In-Reply-To: <53EC92EE.5050607@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2014 10:43 AM, Hans Verkuil wrote:
> Hi Mauro,
> 
> Various fixes for v3.18.
> 
> Please take a good look at the 'videobuf2: fix lockdep warning'. Locking issues
> are always complex and an extra pair of eyeballs doesn't hurt. I also have been
> in two minds whether it should go into 3.17 or 3.18, but I think it is better to
> have it go through a longer test period. But I can be convinced to go for 3.17
> as well :-)
> 
> Regards,
> 
>     Hans
> 
> The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:
> 
>   [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.18a
> 
> for you to fetch changes up to 481a56ce8ef5dc6670ffcd87e58903323d23d0f3:
> 
>   usbtv: add audio support (2014-08-14 12:29:39 +0200)
> 
> ----------------------------------------------------------------
> Andreas Ruprecht (1):
>       drivers: media: pci: Makefile: Remove duplicate subdirectory from obj-y
> 
> Axel Lin (1):
>       saa6752hs: Convert to devm_kzalloc()
> 
> Dan Carpenter (1):
>       vmalloc_sg: off by one in error handling
> 
> Federico Simoncelli (1):
>       usbtv: add audio support
> 
> Geert Uytterhoeven (2):
>       cx25840: Spelling s/compuations/computations/
>       cx23885: Spelling s/compuations/computations/
> 
> Hans Verkuil (3):
>       videobuf2: fix lockdep warning

This one is wrong, I'll post a v5 for it today.

Regards,

	Hans

>       DocBook media: fix order of v4l2_edid fields
>       vb2: use pr_info instead of pr_debug
> 
>  Documentation/DocBook/media/v4l/vidioc-g-edid.xml |  12 +--
>  drivers/media/i2c/cx25840/cx25840-ir.c            |   2 +-
>  drivers/media/i2c/saa6752hs.c                     |   6 +-
>  drivers/media/pci/Makefile                        |   1 -
>  drivers/media/pci/cx23885/cx23888-ir.c            |   2 +-
>  drivers/media/usb/usbtv/Makefile                  |   3 +-
>  drivers/media/usb/usbtv/usbtv-audio.c             | 384 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/usb/usbtv/usbtv-core.c              |  16 +++-
>  drivers/media/usb/usbtv/usbtv-video.c             |   9 +-
>  drivers/media/usb/usbtv/usbtv.h                   |  21 ++++-
>  drivers/media/v4l2-core/videobuf-dma-sg.c         |   6 +-
>  drivers/media/v4l2-core/videobuf2-core.c          |  58 ++++--------
>  include/media/videobuf2-core.h                    |   2 +
>  13 files changed, 460 insertions(+), 62 deletions(-)
>  create mode 100644 drivers/media/usb/usbtv/usbtv-audio.c
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

