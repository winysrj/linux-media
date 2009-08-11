Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:29096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZHKAr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 20:47:28 -0400
Received: by fg-out-1718.google.com with SMTP id e12so533752fga.17
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 17:47:27 -0700 (PDT)
Date: Tue, 11 Aug 2009 10:47:29 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATH] Add RDS config for BeholdTV cards
Message-ID: <20090811104729.4fe66a71@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/RNyOv2V0YQRN+P_QY8XA7DU"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/RNyOv2V0YQRN+P_QY8XA7DU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

Add config of RDS part for the BeholdTV tuners.

diff -r e72c463783ab linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 08 03:28:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Aug 11 05:37:18 2009 +1000
@@ -4120,6 +4120,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4184,6 +4185,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4214,6 +4216,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4389,6 +4392,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4417,6 +4421,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4445,6 +4450,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4473,6 +4479,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4579,6 +4586,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/RNyOv2V0YQRN+P_QY8XA7DU
Content-Type: text/x-patch; name=beholdtv_rds.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholdtv_rds.patch

diff -r e72c463783ab linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 08 03:28:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Aug 11 05:37:18 2009 +1000
@@ -4120,6 +4120,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4184,6 +4185,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4214,6 +4216,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x00008000,
 		.inputs         = {{
@@ -4389,6 +4392,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4417,6 +4421,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4445,6 +4450,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4473,6 +4479,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
@@ -4579,6 +4586,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.empress_addr 	= 0x20,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = { {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/RNyOv2V0YQRN+P_QY8XA7DU--
