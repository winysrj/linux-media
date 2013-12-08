Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52649 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035Ab3LHWb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 15/18] m88ds3103: add default value for reg 56
Date: Mon,  9 Dec 2013 00:31:32 +0200
Message-Id: <1386541895-8634-16-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reg 0x56 should be programmed to 0x01. Add default to inittab.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103_priv.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index 80c5a25..9cc29b4 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -71,6 +71,7 @@ static const struct m88ds3103_reg_val m88ds3103_dvbs_init_reg_vals[] = {
 	{0x51, 0x36},
 	{0x52, 0x36},
 	{0x53, 0x36},
+	{0x56, 0x01},
 	{0x63, 0x0f},
 	{0x64, 0x30},
 	{0x65, 0x40},
@@ -152,6 +153,7 @@ static const struct m88ds3103_reg_val m88ds3103_dvbs2_init_reg_vals[] = {
 	{0x51, 0x36},
 	{0x52, 0x36},
 	{0x53, 0x36},
+	{0x56, 0x01},
 	{0x63, 0x0f},
 	{0x64, 0x10},
 	{0x65, 0x20},
-- 
1.8.4.2

