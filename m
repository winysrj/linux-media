Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da02.mx.aol.com ([205.188.105.144]:41962 "EHLO
	imr-da02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2ICUN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 16:13:26 -0400
Received: from mtaout-ma01.r1000.mx.aol.com (mtaout-ma01.r1000.mx.aol.com [172.29.41.1])
	by imr-da02.mx.aol.com (8.14.1/8.14.1) with ESMTP id q83KDMsC002540
	for <linux-media@vger.kernel.org>; Mon, 3 Sep 2012 16:13:22 -0400
Received: from [192.168.1.35] (unknown [190.50.52.121])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-ma01.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id CE06DE0000C3
	for <linux-media@vger.kernel.org>; Mon,  3 Sep 2012 16:13:20 -0400 (EDT)
Message-ID: <50450FB5.3090503@netscape.net>
Date: Mon, 03 Sep 2012 17:14:45 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Mygica X8507 audio for YPbPr, AV and S-Video
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

This patch add audio support for input YPbPr, AV and S-Video for Mygica 
X8507 card.
I tried it with the 3.4 and 3.5 kernel

Remains to be done: IR, FM and ISDBT

Sorry if I sent the patch improperly.

Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>



diff --git a/media/video/cx23885/cx23885-cards.c b/media/video/cx23885/cx23885-cards.c
index 080e111..17e2576 100644
--- a/media/video/cx23885/cx23885-cards.c
+++ b/media/video/cx23885/cx23885-cards.c
@@ -541,11 +541,13 @@ struct cx23885_board cx23885_boards[] = {
                         {
                                 .type   = CX23885_VMUX_COMPOSITE1,
                                 .vmux   = CX25840_COMPOSITE8,
+                               .amux   = CX25840_AUDIO7,
                         },
                         {
                                 .type   = CX23885_VMUX_SVIDEO,
                                 .vmux   = CX25840_SVIDEO_LUMA3 |
                                                 CX25840_SVIDEO_CHROMA4,
+                               .amux   = CX25840_AUDIO7,
                         },
                         {
                                 .type   = CX23885_VMUX_COMPONENT,
@@ -553,6 +555,7 @@ struct cx23885_board cx23885_boards[] = {
                                         CX25840_VIN1_CH1 |
                                         CX25840_VIN6_CH2 |
                                         CX25840_VIN7_CH3,
+                               .amux   = CX25840_AUDIO7,
                         },
                 },
         },
diff --git a/media/video/cx23885/cx23885-video.c b/media/video/cx23885/cx23885-video.c
index 22f8e7f..fcb3f22 100644
--- a/media/video/cx23885/cx23885-video.c
+++ b/media/video/cx23885/cx23885-video.c
@@ -508,7 +508,8 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
                 (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
-               (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850)) {
+               (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
+               (dev->board == CX23885_BOARD_MYGICA_X8507)) {
                 /* Configure audio routing */
                 v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
                         INPUT(input)->amux, 0, 0);



-- 
Dona tu voz
http://www.voxforge.org/es

