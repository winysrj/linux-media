Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47190 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732806AbeKWHDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 02:03:01 -0500
Date: Thu, 22 Nov 2018 18:21:57 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.21] Various fixes
Message-ID: <20181122182157.3e2c8c97@coco.lan>
In-Reply-To: <7b793343-2450-f706-ae54-d11bf3c89b13@xs4all.nl>
References: <7b793343-2450-f706-ae54-d11bf3c89b13@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Wed, 7 Nov 2018 11:31:14 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Just one note: the "cec: keep track of outstanding transmits" is CC-ed to stable
> for v4.18 and up, but I prefer to wait until v4.21 before merging it to give it
> more test time. It is not something that happens in normal usage, so delaying
> this isn't a problem.

Could you please check your trees? 

Checkpatch is complaining with:

	WARNING: Missing Signed-off-by: line by nominal patch author 'Hans Verkuil <hverkuil@xs4all.nl>'

This particular tree has two of your emails as signatures, but it misses
the one you're actually using for the Author: tag:

	Signed-off-by:	Hans Verkuil <hans.verkuil@cisco.com>
	Signed-off-by:	Hans Verkuil <hansverk@cisco.com>

I ended by merging another of your trees that had the same issue.
We should receive some e-mails when this hits linux-next, due to that :-)

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:
> 
>   media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21a
> 
> for you to fetch changes up to b6f3defe272a97ea65f4352cdc9c0b943164a75e:
> 
>   vivid: fill in media_device bus_info (2018-11-07 11:15:12 +0100)
> 
> ----------------------------------------------------------------
> Tag branch
> 
> ----------------------------------------------------------------
> Hans Verkuil (7):
>       adv7604: add CEC support for adv7611/adv7612
>       cec: report Vendor ID after initialization
>       cec: add debug_phys_addr module option
>       cec: keep track of outstanding transmits
>       vivid: fix error handling of kthread_run
>       vivid: set min width/height to a value > 0
>       vivid: fill in media_device bus_info
> 
> Julia Lawall (4):
>       media: vicodec: constify v4l2_ctrl_ops structure
>       media: rockchip/rga: constify v4l2_m2m_ops structure
>       media: vimc: constify structures stored in fields of v4l2_subdev_ops structure
>       media: rockchip/rga: constify video_device structure
> 
> Sean Young (1):
>       media: v4l uapi docs: few minor corrections and typos
> 
>  Documentation/media/uapi/v4l/app-pri.rst         |  2 +-
>  Documentation/media/uapi/v4l/audio.rst           |  2 +-
>  Documentation/media/uapi/v4l/dev-capture.rst     |  2 +-
>  Documentation/media/uapi/v4l/dev-teletext.rst    |  2 +-
>  Documentation/media/uapi/v4l/format.rst          |  2 +-
>  Documentation/media/uapi/v4l/mmap.rst            | 22 ++++++++++-----------
>  Documentation/media/uapi/v4l/open.rst            |  2 +-
>  Documentation/media/uapi/v4l/tuner.rst           |  4 ++--
>  Documentation/media/uapi/v4l/userp.rst           |  8 ++++----
>  Documentation/media/uapi/v4l/video.rst           |  4 ++--
>  drivers/media/cec/cec-adap.c                     | 34 +++++++++++++++++++++++---------
>  drivers/media/cec/cec-core.c                     |  6 ++++++
>  drivers/media/i2c/adv7604.c                      | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  drivers/media/platform/rockchip/rga/rga.c        |  4 ++--
>  drivers/media/platform/vicodec/vicodec-core.c    |  2 +-
>  drivers/media/platform/vimc/vimc-sensor.c        |  2 +-
>  drivers/media/platform/vivid/vivid-core.c        |  2 ++
>  drivers/media/platform/vivid/vivid-kthread-cap.c |  5 ++++-
>  drivers/media/platform/vivid/vivid-kthread-out.c |  5 ++++-
>  drivers/media/platform/vivid/vivid-vid-common.c  |  2 +-
>  include/media/cec.h                              |  1 +
>  21 files changed, 125 insertions(+), 51 deletions(-



Thanks,
Mauro
