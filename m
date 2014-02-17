Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:2658 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaBQJwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:52:42 -0500
Received: from [10.61.171.94] ([10.61.171.94])
	(authenticated bits=0)
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id s1H9qeKX017115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 09:52:40 GMT
Message-ID: <5301DBC6.9000609@cisco.com>
Date: Mon, 17 Feb 2014 10:52:06 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] saa6752hs depends on CRC32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 4aa9c53..8a357ea 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -659,6 +659,7 @@ comment "Audio/Video compression chips"
 config VIDEO_SAA6752HS
 	tristate "Philips SAA6752HS MPEG-2 Audio/Video Encoder"
 	depends on VIDEO_V4L2 && I2C
+	select CRC32
 	---help---
 	  Support for the Philips SAA6752HS MPEG-2 video and MPEG-audio/AC-3
 	  audio encoder with multiplexer.
