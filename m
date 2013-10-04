Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4183 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3JDOCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/14] cx231xx: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:49 +0200
Message-Id: <1380895312-30863-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c:31:19: warning: symbol 'cx231xx_Scenario' was not declared. Should it be static?
drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c:675:23: warning: cast to restricted __le32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
index d7308ab..2a34cee 100644
--- a/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
+++ b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
@@ -28,7 +28,7 @@ MODULE_PARM_DESC(pcb_debug, "enable pcb config debug messages [video]");
 
 /******************************************************************************/
 
-struct pcb_config cx231xx_Scenario[] = {
+static struct pcb_config cx231xx_Scenario[] = {
 	{
 	 INDEX_SELFPOWER_DIGITAL_ONLY,	/* index */
 	 USB_SELF_POWER,	/* power_type */
@@ -672,7 +672,7 @@ u32 initialize_cx231xx(struct cx231xx *dev)
 	pcb config it is related to */
 	cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, BOARD_CFG_STAT, data, 4);
 
-	config_info = le32_to_cpu(*((u32 *) data));
+	config_info = le32_to_cpu(*((__le32 *)data));
 	usb_speed = (u8) (config_info & 0x1);
 
 	/* Verify this device belongs to Bus power or Self power device */
-- 
1.8.3.2

