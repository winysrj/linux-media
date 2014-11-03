Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53026 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbaKCJUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 04:20:35 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 793062A0376
	for <linux-media@vger.kernel.org>; Mon,  3 Nov 2014 10:20:30 +0100 (CET)
Message-ID: <545748DE.90608@xs4all.nl>
Date: Mon, 03 Nov 2014 10:20:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx23885: fix uninitialized variable warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx23885-dvb.c: In function 'cx23885_sp2_ci_ctrl':
cx23885-dvb.c:675:13: warning: 'tmp' may be used uninitialized in this function [-Wmaybe-uninitialized]
  *mem = tmp & 0xff;
             ^

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 7578549..577d2e9 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -635,7 +635,7 @@ static int cx23885_sp2_ci_ctrl(void *priv, u8 read, int addr,
 	struct cx23885_tsport *port = priv;
 	struct cx23885_dev *dev = port->dev;
 	int ret;
-	int tmp;
+	int tmp = 0;
 	unsigned long timeout;
 
 	mutex_lock(&dev->gpio_lock);
