Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2689 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaHUUT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/12] cx23885: fix sparse warning
Date: Thu, 21 Aug 2014 22:19:31 +0200
Message-Id: <1408652376-39525-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cx23885/cx23885-dvb.c:1494:72: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 968fecc..da07144 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1491,7 +1491,7 @@ static int dvb_register(struct cx23885_tsport *port)
 					&hauppauge_hvr4400_si2165_config,
 					&i2c_bus->i2c_adap);
 			if (fe0->dvb.frontend != NULL) {
-				fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
+				fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
 				if (!dvb_attach(tda18271_attach,
 						fe0->dvb.frontend,
 						0x60, &i2c_bus2->i2c_adap,
-- 
2.1.0.rc1

