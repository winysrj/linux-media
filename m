Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53973 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/14] af9033: update IT9135 tuner inittabs
Date: Sat,  9 Aug 2014 23:27:00 +0300
Message-Id: <1407616032-2722-3-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bimow Chen <Bimow.Chen@ite.com.tw>

Update IT9135 BX tuner config 60 and 61 inittabs.

[crope@iki.fi: removed two reg writes from driver init itself]
Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033_priv.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index fc2ad58..ded7b67 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -1418,7 +1418,7 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800068, 0x0a },
 	{ 0x80006a, 0x03 },
 	{ 0x800070, 0x0a },
-	{ 0x800071, 0x05 },
+	{ 0x800071, 0x0a },
 	{ 0x800072, 0x02 },
 	{ 0x800075, 0x8c },
 	{ 0x800076, 0x8c },
@@ -1484,7 +1484,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xbe },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xbe },
@@ -1510,7 +1509,6 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xac },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x1e },
 	{ 0x800153, 0xbc },
 	{ 0x800178, 0x09 },
@@ -1522,9 +1520,10 @@ static const struct reg_val tuner_init_it9135_60[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xa0 },
 	{ 0x800190, 0x5a },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
@@ -1699,7 +1698,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x800104, 0x02 },
 	{ 0x800105, 0xc8 },
 	{ 0x800106, 0x00 },
-	{ 0x800109, 0x02 },
 	{ 0x800115, 0x0a },
 	{ 0x800116, 0x03 },
 	{ 0x80011a, 0xc6 },
@@ -1725,7 +1723,6 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80014b, 0x8c },
 	{ 0x80014d, 0xa8 },
 	{ 0x80014e, 0xc6 },
-	{ 0x80014f, 0x03 },
 	{ 0x800151, 0x28 },
 	{ 0x800153, 0xcc },
 	{ 0x800178, 0x09 },
@@ -1737,9 +1734,10 @@ static const struct reg_val tuner_init_it9135_61[] = {
 	{ 0x80018d, 0x5f },
 	{ 0x80018f, 0xfb },
 	{ 0x800190, 0x5c },
-	{ 0x80ed02, 0xff },
-	{ 0x80ee42, 0xff },
-	{ 0x80ee82, 0xff },
+	{ 0x800191, 0x00 },
+	{ 0x80ed02, 0x40 },
+	{ 0x80ee42, 0x40 },
+	{ 0x80ee82, 0x40 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f01f, 0x8c },
 	{ 0x80f020, 0x00 },
-- 
http://palosaari.fi/

