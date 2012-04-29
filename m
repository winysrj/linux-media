Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54676 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab2D2Wrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 18:47:36 -0400
Subject: Re: [RFC PATCH 5/8] v4l: fix compiler warnings.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>
Date: Sun, 29 Apr 2012 18:46:45 -0400
In-Reply-To: <c21418a68a0851986513afbb4dc5fa92c004b1ba.1335180844.git.hans.verkuil@cisco.com>
References: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
	 <c21418a68a0851986513afbb4dc5fa92c004b1ba.1335180844.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335739606.25802.2.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-04-23 at 13:38 +0200, Hans Verkuil wrote:
> media_build/v4l/au0828-video.c: In function 'au0828_irq_callback':
> media_build/v4l/au0828-video.c:123:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> media_build/v4l/cx23888-ir.c: In function 'pulse_clocks_to_clock_divider':
> media_build/v4l/cx23888-ir.c:334:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
> media_build/v4l/cx25840-ir.c: In function 'pulse_clocks_to_clock_divider':
> media_build/v4l/cx25840-ir.c:319:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
> media_build/v4l/cx25840-ir.c: In function 'cx25840_ir_tx_write':
> media_build/v4l/cx25840-ir.c:863:21: warning: variable 'c' set but not used [-Wunused-but-set-variable]
> media_build/v4l/em28xx-audio.c: In function 'snd_em28xx_hw_capture_params':
> media_build/v4l/em28xx-audio.c:346:31: warning: variable 'format' set but not used [-Wunused-but-set-variable]
> media_build/v4l/em28xx-audio.c:346:25: warning: variable 'rate' set but not used [-Wunused-but-set-variable]
> media_build/v4l/em28xx-audio.c:346:15: warning: variable 'channels' set but not used [-Wunused-but-set-variable]
> media_build/v4l/et61x251_core.c: In function 'et61x251_urb_complete':
> media_build/v4l/et61x251_core.c:370:16: warning: variable 'len' set but not used [-Wunused-but-set-variable]
> media_build/v4l/et61x251_core.c: In function 'et61x251_stream_interrupt':
> media_build/v4l/et61x251_core.c:581:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> media_build/v4l/hdpvr-control.c: In function 'get_input_lines_info':
> media_build/v4l/hdpvr-control.c:98:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> media_build/v4l/hdpvr-video.c: In function 'hdpvr_try_ctrl':
> media_build/v4l/hdpvr-video.c:955:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> media_build/v4l/saa7134-video.c: In function 'saa7134_s_tuner':
> media_build/v4l/saa7134-video.c:2030:6: warning: variable 'rx' set but not used [-Wunused-but-set-variable]
> media_build/v4l/sn9c102_core.c: In function 'sn9c102_stream_interrupt':
> media_build/v4l/sn9c102_core.c:998:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

cx23888-ir.c and cx25840-ir.c changes look good to me.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

-Andy

> ---
>  drivers/media/video/au0828/au0828-video.c    |    4 ++--
>  drivers/media/video/cx23885/cx23888-ir.c     |    4 +---
>  drivers/media/video/cx25840/cx25840-ir.c     |    6 +-----
>  drivers/media/video/em28xx/em28xx-audio.c    |    9 +++++----
>  drivers/media/video/et61x251/et61x251_core.c |   11 ++++-------
>  drivers/media/video/hdpvr/hdpvr-control.c    |    2 ++
>  drivers/media/video/hdpvr/hdpvr-video.c      |    2 +-
>  drivers/media/video/saa7134/saa7134-video.c  |    2 +-
>  drivers/media/video/sn9c102/sn9c102_core.c   |    4 +---
>  9 files changed, 18 insertions(+), 26 deletions(-)


