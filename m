Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57747
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932520AbbKMPG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 10:06:59 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ttusb-dec: constify ttusbdecfe_config structure
Date: Fri, 13 Nov 2015 15:55:18 +0100
Message-Id: <1447426518-27151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ttusbdecfe_config structure is never modified, so declare it
as const.

Other references to this structure type were already declared as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/ttusb-dec/ttusb_dec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index a5de46f..4e36e24 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1606,7 +1606,7 @@ static int fe_send_command(struct dvb_frontend* fe, const u8 command,
 	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
 }
 
-static struct ttusbdecfe_config fe_config = {
+static const struct ttusbdecfe_config fe_config = {
 	.send_command = fe_send_command
 };
 

