Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35080 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaDGJcX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Apr 2014 05:32:23 -0400
Message-ID: <53427071.7080509@ti.com>
Date: Mon, 7 Apr 2014 15:01:29 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL for 3.15 fixes] VPE fixes
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Since the VPE m2m patch set couldn't make it on time, I've separated out 
the fixes from the series so that they can be taken in one of the 
3.15-rc series.

Thanks,
Archit

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

   [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 
08:02:16 -0300)

are available in the git repository at:

   git://github.com/boddob/linux.git vpe-fixes-315-rc

for you to fetch changes up to 3c7d629f0aa98ed587306913831e5a8968504f7a:

   v4l: ti-vpe: retain v4l2_buffer flags for captured buffers 
(2014-04-07 12:56:47 +0530)

----------------------------------------------------------------
Archit Taneja (9):
       v4l: ti-vpe: Make sure in job_ready that we have the needed 
number of dst_bufs
       v4l: ti-vpe: Use video_device_release_empty
       v4l: ti-vpe: Allow usage of smaller images
       v4l: ti-vpe: report correct capabilities in querycap
       v4l: ti-vpe: Use correct bus_info name for the device in querycap
       v4l: ti-vpe: Fix initial configuration queue data
       v4l: ti-vpe: zero out reserved fields in try_fmt
       v4l: ti-vpe: Set correct field parameter for output and capture 
buffers
       v4l: ti-vpe: retain v4l2_buffer flags for captured buffers

  drivers/media/platform/ti-vpe/vpe.c | 45 
++++++++++++++++++++++++++-----------
  1 file changed, 32 insertions(+), 13 deletions(-)
