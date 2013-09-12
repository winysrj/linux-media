Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:36573 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3ILM0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 08:26:47 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	ismael.luceno@corp.bluecherry.net
Date: Thu, 12 Sep 2013 14:26:46 +0200
MIME-Version: 1.0
Message-ID: <m361u6b4zd.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] SOLO6x10: Remove unused #define SOLO_DEFAULT_GOP
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 6f91d2e..f1bbb8c 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -94,7 +94,6 @@
 #define SOLO_ENC_MODE_HD1		1
 #define SOLO_ENC_MODE_D1		9
 
-#define SOLO_DEFAULT_GOP		30
 #define SOLO_DEFAULT_QP			3
 
 #ifndef V4L2_BUF_FLAG_MOTION_ON
