Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51373 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KCAgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:36:22 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclVL-0001qk-TK
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:25:24 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 6FC4E140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:25:23 +0100 (CET)
Date: Sun, 3 Nov 2013 01:25:23 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/12] tda18271c2dd: Fix description of NXP TDA18271C2
 silicon tuner
Message-ID: <20131103002523.GF7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added (DD) to NXP TDA18271C2 silicon tuner as this tuner was
specifically added for Digital Devices ddbridge driver.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/dvb-frontends/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index bddbab4..6f99eb8 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -48,11 +48,11 @@ config DVB_DRXK
 	  Say Y when you want to support this frontend.
 
 config DVB_TDA18271C2DD
-	tristate "NXP TDA18271C2 silicon tuner"
+	tristate "NXP TDA18271C2 silicon tuner (DD)"
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
-	  NXP TDA18271 silicon tuner.
+	  NXP TDA18271 silicon tuner (Digital Devices driver).
 
 	  Say Y when you want to support this tuner.
 
-- 
1.8.4.2
