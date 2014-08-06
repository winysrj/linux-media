Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55940 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaHFEkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 00:40:07 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so2582849pdj.15
        for <linux-media@vger.kernel.org>; Tue, 05 Aug 2014 21:40:06 -0700 (PDT)
Date: Wed, 6 Aug 2014 12:40:01 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] support for DVBSky dvb-s2 usb: add dvbsky rc keymaps include file
Message-ID: <201408061239584840620@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add dvbsky rc keymaps include file.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 include/media/rc-map.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 80f9518..e7a1514 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -135,6 +135,7 @@ void rc_map_init(void);
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
+#define RC_MAP_DVBSKY                    "rc-dvbsky"
 #define RC_MAP_EMPTY                     "rc-empty"
 #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
 #define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
  

