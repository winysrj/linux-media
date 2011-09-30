Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1I3U6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 16:58:12 -0400
Received: by fxe4 with SMTP id 4so3354208fxe.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 13:58:10 -0700 (PDT)
Subject: [PATCH] pctv452e: hm.. tidy bogus code up
To: Mauro Chehab <mchehab@infradead.org>
From: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	Hans Petter Selasky <hselasky@c2i.net>,
	Doychin Dokov <root@net1.cc>,
	Steffen Barszus <steffenbpunkt@googlemail.com>,
	Dominik Kuhlen <dkuhlen@gmx.net>
Date: Fri, 30 Sep 2011 23:58:11 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109302358.11233.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, usb_register calls two times with cloned structures, but for 
different driver names. Let's remove it.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/dvb-usb/pctv452e.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-
usb/pctv452e.c
index 9a5c811..f9aec5c 100644
--- a/drivers/media/dvb/dvb-usb/pctv452e.c
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -1012,7 +1012,7 @@ static struct dvb_usb_device_properties 
tt_connect_s2_3600_properties = {
 
 	.i2c_algo = &pctv452e_i2c_algo,
 
-	.generic_bulk_ctrl_endpoint = 1, /* allow generice rw function*/
+	.generic_bulk_ctrl_endpoint = 1, /* allow generic rw function*/
 
 	.num_device_descs = 2,
 	.devices = {
@@ -1055,22 +1055,9 @@ static struct usb_driver pctv452e_usb_driver = {
 	.id_table   = pctv452e_usb_table,
 };
 
-static struct usb_driver tt_connects2_3600_usb_driver = {
-	.name       = "dvb-usb-tt-connect-s2-3600-01.fw",
-	.probe      = pctv452e_usb_probe,
-	.disconnect = pctv452e_usb_disconnect,
-	.id_table   = pctv452e_usb_table,
-};
-
 static int __init pctv452e_usb_init(void)
 {
 	int ret = usb_register(&pctv452e_usb_driver);
-
-	if (ret) {
-		err("%s: usb_register failed! Error %d", __FILE__, ret);
-		return ret;
-	}
-	ret = usb_register(&tt_connects2_3600_usb_driver);
 	if (ret)
 		err("%s: usb_register failed! Error %d", __FILE__, ret);
 
@@ -1080,7 +1067,6 @@ static int __init pctv452e_usb_init(void)
 static void __exit pctv452e_usb_exit(void)
 {
 	usb_deregister(&pctv452e_usb_driver);
-	usb_deregister(&tt_connects2_3600_usb_driver);
 }
 
 module_init(pctv452e_usb_init);
-- 
1.7.5.1

