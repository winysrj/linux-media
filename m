Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60405 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0IXOOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 03/16] go7007: Add MODULE_DEVICE_TABLE to the go7007 I2C modules
Date: Fri, 24 Sep 2010 16:14:01 +0200
Message-Id: <1285337654-5044-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The device table is required to load modules based on modaliases.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/go7007/wis-ov7640.c     |    1 +
 drivers/staging/go7007/wis-saa7113.c    |    1 +
 drivers/staging/go7007/wis-saa7115.c    |    1 +
 drivers/staging/go7007/wis-sony-tuner.c |    1 +
 drivers/staging/go7007/wis-tw2804.c     |    1 +
 drivers/staging/go7007/wis-tw9903.c     |    1 +
 drivers/staging/go7007/wis-uda1342.c    |    1 +
 7 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/go7007/wis-ov7640.c b/drivers/staging/go7007/wis-ov7640.c
index 4f0cbdd..6bc9470 100644
--- a/drivers/staging/go7007/wis-ov7640.c
+++ b/drivers/staging/go7007/wis-ov7640.c
@@ -81,6 +81,7 @@ static const struct i2c_device_id wis_ov7640_id[] = {
 	{ "wis_ov7640", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_ov7640_id);
 
 static struct i2c_driver wis_ov7640_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-saa7113.c b/drivers/staging/go7007/wis-saa7113.c
index 72f5c1f..05e0e10 100644
--- a/drivers/staging/go7007/wis-saa7113.c
+++ b/drivers/staging/go7007/wis-saa7113.c
@@ -308,6 +308,7 @@ static const struct i2c_device_id wis_saa7113_id[] = {
 	{ "wis_saa7113", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_saa7113_id);
 
 static struct i2c_driver wis_saa7113_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-saa7115.c b/drivers/staging/go7007/wis-saa7115.c
index cd950b6..46cff59 100644
--- a/drivers/staging/go7007/wis-saa7115.c
+++ b/drivers/staging/go7007/wis-saa7115.c
@@ -441,6 +441,7 @@ static const struct i2c_device_id wis_saa7115_id[] = {
 	{ "wis_saa7115", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_saa7115_id);
 
 static struct i2c_driver wis_saa7115_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-sony-tuner.c b/drivers/staging/go7007/wis-sony-tuner.c
index 981c9b3..8f1b7d4 100644
--- a/drivers/staging/go7007/wis-sony-tuner.c
+++ b/drivers/staging/go7007/wis-sony-tuner.c
@@ -692,6 +692,7 @@ static const struct i2c_device_id wis_sony_tuner_id[] = {
 	{ "wis_sony_tuner", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_sony_tuner_id);
 
 static struct i2c_driver wis_sony_tuner_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-tw2804.c b/drivers/staging/go7007/wis-tw2804.c
index ee28a99..5b218c5 100644
--- a/drivers/staging/go7007/wis-tw2804.c
+++ b/drivers/staging/go7007/wis-tw2804.c
@@ -331,6 +331,7 @@ static const struct i2c_device_id wis_tw2804_id[] = {
 	{ "wis_tw2804", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_tw2804_id);
 
 static struct i2c_driver wis_tw2804_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-tw9903.c b/drivers/staging/go7007/wis-tw9903.c
index 80d4726..9230f4a 100644
--- a/drivers/staging/go7007/wis-tw9903.c
+++ b/drivers/staging/go7007/wis-tw9903.c
@@ -313,6 +313,7 @@ static const struct i2c_device_id wis_tw9903_id[] = {
 	{ "wis_tw9903", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_tw9903_id);
 
 static struct i2c_driver wis_tw9903_driver = {
 	.driver = {
diff --git a/drivers/staging/go7007/wis-uda1342.c b/drivers/staging/go7007/wis-uda1342.c
index 5c4eb49..0127be2 100644
--- a/drivers/staging/go7007/wis-uda1342.c
+++ b/drivers/staging/go7007/wis-uda1342.c
@@ -86,6 +86,7 @@ static const struct i2c_device_id wis_uda1342_id[] = {
 	{ "wis_uda1342", 0 },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, wis_uda1342_id);
 
 static struct i2c_driver wis_uda1342_driver = {
 	.driver = {
-- 
1.7.2.2

