Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35394 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752618AbdGITmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so20514859wrb.2
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:52 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 3/4] [media] ddbridge: fix buffer overflow in max_set_input_unlocked()
Date: Sun,  9 Jul 2017 21:42:45 +0200
Message-Id: <20170709194246.10334-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194246.10334-1-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Picked up code parts introduced one smatch error:

  drivers/media/pci/ddbridge/ddbridge-maxs8.c:163 max_set_input_unlocked() error: buffer overflow 'dev->link[port->lnr].lnb.voltage' 4 <= 255

Fix this by clamping the .lnb.voltage array access to 0-3 by "& 3"'ing
dvb->input.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-maxs8.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
index a9dc5f9754da..10716ee8cf59 100644
--- a/drivers/media/pci/ddbridge/ddbridge-maxs8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
@@ -187,11 +187,12 @@ static int max_set_input_unlocked(struct dvb_frontend *fe, int in)
 		return -EINVAL;
 	if (dvb->input != in) {
 		u32 bit = (1ULL << input->nr);
-		u32 obit = dev->link[port->lnr].lnb.voltage[dvb->input] & bit;
+		u32 obit =
+			dev->link[port->lnr].lnb.voltage[dvb->input & 3] & bit;
 
-		dev->link[port->lnr].lnb.voltage[dvb->input] &= ~bit;
+		dev->link[port->lnr].lnb.voltage[dvb->input & 3] &= ~bit;
 		dvb->input = in;
-		dev->link[port->lnr].lnb.voltage[dvb->input] |= obit;
+		dev->link[port->lnr].lnb.voltage[dvb->input & 3] |= obit;
 	}
 	res = dvb->set_input(fe, in);
 	return res;
-- 
2.13.0
