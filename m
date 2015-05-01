Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34206 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbbEALpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 07:45:34 -0400
Message-ID: <55436758.70208@xs4all.nl>
Date: Fri, 01 May 2015 13:45:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] saa7164: fix compiler warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/saa7164/saa7164-dvb.c: In function ‘saa7164_dvb_register’:
drivers/media/pci/saa7164/saa7164-dvb.c:701:7: warning: ‘client_tuner’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    if (!client_tuner || !client_tuner->dev.driver)
       ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index c68ce26..9969800 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -698,7 +698,7 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			request_module(info.type);
 			client_demod = i2c_new_device(&dev->i2c_bus[2].i2c_adap,
 						      &info);
-			if (!client_tuner || !client_tuner->dev.driver)
+			if (!client_demod || !client_demod->dev.driver)
 				goto frontend_detach;
 
 			if (!try_module_get(client_demod->dev.driver->owner)) {
