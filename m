Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:47163 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758148AbZJILKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 07:10:23 -0400
Date: Fri, 09 Oct 2009 20:09:42 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] soc-camera: tw9910: Revision 0 and 1 are able to use
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <u4oq8q0w9.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/video/tw9910.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 269ab04..7bf90a2 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -883,11 +883,12 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
 
 	/*
 	 * check and show Product ID
+	 * So far only revisions 0 and 1 have been seen
 	 */
 	val = i2c_smbus_read_byte_data(client, ID);
 
 	if (0x0B != GET_ID(val) ||
-	    0x00 != GET_ReV(val)) {
+	    0x01 < GET_ReV(val)) {
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n", GET_ID(val), GET_ReV(val));
 		return -ENODEV;
-- 
1.6.0.4

