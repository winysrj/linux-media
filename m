Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35491 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbcF0OaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 10:30:14 -0400
Date: Mon, 27 Jun 2016 17:29:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dvb-usb: silence an uninitialized variable warning
Message-ID: <20160627142946.GA19889@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My static checker complains that if adap->props.num_frontends is 0 then
"ret" is uninitialized.  I don't think that can happen.  But "ret" is
always zero here so we can just remove the condition.

This extra check was added in commit 0d3ab8410dcb ('[media] dvb core:
must check dvb_create_media_graph()').

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 6477b04..a04c0a2 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -320,8 +320,6 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 
 		adap->num_frontends_initialized++;
 	}
-	if (ret)
-		return ret;
 
 	ret = dvb_create_media_graph(&adap->dvb_adap, true);
 	if (ret)
