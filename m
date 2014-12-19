Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57258 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaLSI5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 03:57:43 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] cx23885: correct some I2C client indentations
Date: Fri, 19 Dec 2014 10:56:41 +0200
Message-Id: <1418979403-28225-2-git-send-email-crope@iki.fi>
In-Reply-To: <1418979403-28225-1-git-send-email-crope@iki.fi>
References: <1418979403-28225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These comparisons fit single line.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 6bb7935..0f60bc4 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1823,8 +1823,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2168_config;
 		request_module(info.type);
 		client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
-		if (client_demod == NULL ||
-				client_demod->dev.driver == NULL)
+		if (client_demod == NULL || client_demod->dev.driver == NULL)
 			goto frontend_detach;
 		if (!try_module_get(client_demod->dev.driver->owner)) {
 			i2c_unregister_device(client_demod);
@@ -1841,8 +1840,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2157_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL ||
-				client_tuner->dev.driver == NULL) {
+		if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
 			module_put(client_demod->dev.driver->owner);
 			i2c_unregister_device(client_demod);
 			port->i2c_client_demod = NULL;
@@ -1878,8 +1876,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &m88ts2022_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL ||
-				client_tuner->dev.driver == NULL)
+		if (client_tuner == NULL || client_tuner->dev.driver == NULL)
 			goto frontend_detach;
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
 			i2c_unregister_device(client_tuner);
@@ -1925,8 +1922,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &m88ts2022_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL ||
-				client_tuner->dev.driver == NULL)
+		if (client_tuner == NULL || client_tuner->dev.driver == NULL)
 			goto frontend_detach;
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
 			i2c_unregister_device(client_tuner);
@@ -1971,8 +1967,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2168_config;
 		request_module(info.type);
 		client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
-		if (client_demod == NULL ||
-				client_demod->dev.driver == NULL)
+		if (client_demod == NULL || client_demod->dev.driver == NULL)
 			goto frontend_detach;
 		if (!try_module_get(client_demod->dev.driver->owner)) {
 			i2c_unregister_device(client_demod);
@@ -1989,8 +1984,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2157_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL ||
-				client_tuner->dev.driver == NULL) {
+		if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
 			module_put(client_demod->dev.driver->owner);
 			i2c_unregister_device(client_demod);
 			port->i2c_client_demod = NULL;
@@ -2115,8 +2109,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &sp2_config;
 		request_module(info.type);
 		client_ci = i2c_new_device(&i2c_bus2->i2c_adap, &info);
-		if (client_ci == NULL ||
-				client_ci->dev.driver == NULL) {
+		if (client_ci == NULL || client_ci->dev.driver == NULL) {
 			if (client_tuner) {
 				module_put(client_tuner->dev.driver->owner);
 				i2c_unregister_device(client_tuner);
-- 
http://palosaari.fi/

