Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34569 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdHCKAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 06:00:44 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media]: dw2102: make dvb_usb_device_description structures const
Date: Thu,  3 Aug 2017 15:30:32 +0530
Message-Id: <1501754432-7605-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_usb_device_description structures are only used during a copy
operation. Therefore, declare them as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 57b1872..c5e3597 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -2103,46 +2103,46 @@ static int dw2102_load_firmware(struct usb_device *dev,
 };
 
 static struct dvb_usb_device_properties *p1100;
-static struct dvb_usb_device_description d1100 = {
+static const struct dvb_usb_device_description d1100 = {
 	"Prof 1100 USB ",
 	{&dw2102_table[PROF_1100], NULL},
 	{NULL},
 };
 
 static struct dvb_usb_device_properties *s660;
-static struct dvb_usb_device_description d660 = {
+static const struct dvb_usb_device_description d660 = {
 	"TeVii S660 USB",
 	{&dw2102_table[TEVII_S660], NULL},
 	{NULL},
 };
 
-static struct dvb_usb_device_description d480_1 = {
+static const struct dvb_usb_device_description d480_1 = {
 	"TeVii S480.1 USB",
 	{&dw2102_table[TEVII_S480_1], NULL},
 	{NULL},
 };
 
-static struct dvb_usb_device_description d480_2 = {
+static const struct dvb_usb_device_description d480_2 = {
 	"TeVii S480.2 USB",
 	{&dw2102_table[TEVII_S480_2], NULL},
 	{NULL},
 };
 
 static struct dvb_usb_device_properties *p7500;
-static struct dvb_usb_device_description d7500 = {
+static const struct dvb_usb_device_description d7500 = {
 	"Prof 7500 USB DVB-S2",
 	{&dw2102_table[PROF_7500], NULL},
 	{NULL},
 };
 
 static struct dvb_usb_device_properties *s421;
-static struct dvb_usb_device_description d421 = {
+static const struct dvb_usb_device_description d421 = {
 	"TeVii S421 PCI",
 	{&dw2102_table[TEVII_S421], NULL},
 	{NULL},
 };
 
-static struct dvb_usb_device_description d632 = {
+static const struct dvb_usb_device_description d632 = {
 	"TeVii S632 USB",
 	{&dw2102_table[TEVII_S632], NULL},
 	{NULL},
-- 
1.9.1
