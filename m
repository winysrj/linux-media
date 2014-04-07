Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52326 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaDGOl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 10:41:27 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3O00BQB0T0O580@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 15:41:24 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>
Cc: linux-media@vger.kernel.org
References: <53427071.7080509@ti.com>
In-reply-to: <53427071.7080509@ti.com>
Subject: RE: [GIT PULL for 3.15 fixes] VPE fixes
Date: Mon, 07 Apr 2014 16:41:24 +0200
Message-id: <06c701cf526f$73e37e10$5baa7a30$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

Thank you for separating the fix patches. I am waiting for 3.15-rc1 to be
released.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Monday, April 07, 2014 11:31 AM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org
> Subject: [GIT PULL for 3.15 fixes] VPE fixes
> 
> Hi Kamil,
> 
> Since the VPE m2m patch set couldn't make it on time, I've separated
> out the fixes from the series so that they can be taken in one of the
> 3.15-rc series.
> 
> Thanks,
> Archit
> 
> The following changes since commit
> a83b93a7480441a47856dc9104bea970e84cda87:
> 
>    [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31
> 08:02:16 -0300)
> 
> are available in the git repository at:
> 
>    git://github.com/boddob/linux.git vpe-fixes-315-rc
> 
> for you to fetch changes up to
> 3c7d629f0aa98ed587306913831e5a8968504f7a:
> 
>    v4l: ti-vpe: retain v4l2_buffer flags for captured buffers
> (2014-04-07 12:56:47 +0530)
> 
> ----------------------------------------------------------------
> Archit Taneja (9):
>        v4l: ti-vpe: Make sure in job_ready that we have the needed
> number of dst_bufs
>        v4l: ti-vpe: Use video_device_release_empty
>        v4l: ti-vpe: Allow usage of smaller images
>        v4l: ti-vpe: report correct capabilities in querycap
>        v4l: ti-vpe: Use correct bus_info name for the device in
> querycap
>        v4l: ti-vpe: Fix initial configuration queue data
>        v4l: ti-vpe: zero out reserved fields in try_fmt
>        v4l: ti-vpe: Set correct field parameter for output and capture
> buffers
>        v4l: ti-vpe: retain v4l2_buffer flags for captured buffers
> 
>   drivers/media/platform/ti-vpe/vpe.c | 45
> ++++++++++++++++++++++++++-----------
>   1 file changed, 32 insertions(+), 13 deletions(-)

