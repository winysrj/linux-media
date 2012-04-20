Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58669 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab2DTAHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 20:07:33 -0400
Subject: Re: [GIT PULL FOR v3.5] Various fixes
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Date: Thu, 19 Apr 2012 20:07:01 -0400
In-Reply-To: <201204191748.51323.hverkuil@xs4all.nl>
References: <201204191748.51323.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1334880428.23364.0.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-04-19 at 17:48 +0200, Hans Verkuil wrote:
> While I was cleaning up some older drivers I came across a few bugs that are
> fixed here. The fixes are all trivial one-liners.
> 
> Regards,
> 
> 	Hans

The fixes for ivtv and cx18 look good to me.  Thanks Hans.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> The following changes since commit f4d4e7656b26a6013bc5072c946920d2e2c44e8e:
> 
>   [media] em28xx: Make em28xx-input.c a separate module (2012-04-10 20:45:41 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git fixes
> 
> for you to fetch changes up to f85e735051e71410bfd695536a25c1013bceeabc:
> 
>   vivi: fix duplicate line. (2012-04-19 17:38:52 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (4):
>       V4L: fix incorrect refcounting.
>       V4L2: drivers implementing vidioc_default should also return -ENOTTY
>       v4l2-ctrls.c: zero min/max/step/def values for 64 bit integers.
>       vivi: fix duplicate line.
> 
>  Documentation/video4linux/v4l2-framework.txt |   14 +++++++++-----
>  drivers/media/radio/dsbr100.c                |    1 -
>  drivers/media/radio/radio-keene.c            |    1 -
>  drivers/media/video/cx18/cx18-ioctl.c        |    2 +-
>  drivers/media/video/davinci/vpfe_capture.c   |    2 +-
>  drivers/media/video/ivtv/ivtv-ioctl.c        |    2 +-
>  drivers/media/video/meye.c                   |    2 +-
>  drivers/media/video/mxb.c                    |    2 +-
>  drivers/media/video/v4l2-ctrls.c             |    1 +
>  drivers/media/video/vivi.c                   |    2 +-
>  10 files changed, 16 insertions(+), 13 deletions(-)



