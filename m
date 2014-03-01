Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaCAN4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 08:56:10 -0500
Date: Sat, 1 Mar 2014 16:55:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] ddbridge: remove unneeded an NULL check
Message-ID: <20140301135529.GC23929@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Static checkers complain about the inconsistent NULL check here.

There is an unchecked dereference of "intput->fe" in the call to
tuner_attach_tda18271() and there is a second unchecked dereference a
couple lines later when we do:
	input->fe2->tuner_priv = input->fe->tuner_priv;

But actually "intput->fe" can't be NULL because if demod_attach_drxk()
fails to allocate it, then we would have return an error code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9375f30d9a81..fb52bda8d45f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -876,10 +876,8 @@ static int dvb_input_attach(struct ddb_input *input)
 			return -ENODEV;
 		if (tuner_attach_tda18271(input) < 0)
 			return -ENODEV;
-		if (input->fe) {
-			if (dvb_register_frontend(adap, input->fe) < 0)
-				return -ENODEV;
-		}
+		if (dvb_register_frontend(adap, input->fe) < 0)
+			return -ENODEV;
 		if (input->fe2) {
 			if (dvb_register_frontend(adap, input->fe2) < 0)
 				return -ENODEV;
