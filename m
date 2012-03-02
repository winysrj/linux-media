Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2CBKIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 05:08:43 -0500
Date: Fri, 2 Mar 2012 11:08:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] mx2-camera patches for 3.4
Message-ID: <Pine.LNX.4.64.1203021103310.913@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

This time so it happened, that soc-camera for the next kernel version 
consists of only one driver updates: mx2-camera.

The following changes since commit e8ca6d20a65d9d94693a0ed99b12d95b882dc859:

  [media] tveeprom: update hauppauge tuner list thru 181 (2012-02-28 18:46:53 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.4

Fabio Estevam (2):
      media: video: mx2_camera.c: Provide error message if clk_get fails
      media: video: mx2_camera.c: Remove unneeded dev_dbg

Javier Martin (10):
      media i.MX27 camera: migrate driver to videobuf2
      media i.MX27 camera: add start_stream and stop_stream callbacks.
      media i.MX27 camera: improve discard buffer handling.
      media i.MX27 camera: handle overflows properly.
      media: i.MX27 camera: Use list_first_entry() whenever possible.
      media: i.MX27 camera: Use spin_lock() inside the IRQ handler.
      media: i.MX27 camera: return IRQ_NONE if no IRQ status bit is set.
      media: i.MX27 camera: fix compilation warning.
      media: i.MX27 camera: more efficient discard buffer handling.
      media: i.MX27 camera: Add resizing support.

Sascha Hauer (1):
      V4L: mx2_camera: remove unsupported i.MX27 DMA mode, make EMMA mandatory

 drivers/media/video/mx2_camera.c | 1214 +++++++++++++++++++++-----------------
 1 files changed, 668 insertions(+), 546 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
