Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53543 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2DOPxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Apr 2012 11:53:52 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so5866938dak.11
        for <linux-media@vger.kernel.org>; Sun, 15 Apr 2012 08:53:52 -0700 (PDT)
Date: Sun, 15 Apr 2012 23:53:56 +0800
From: "=?utf-8?B?bmliYmxlLm1heA==?=" <nibble.max@gmail.com>
To: "=?utf-8?B?TWF1cm8gQ2FydmFsaG8gQ2hlaGFi?=" <mchehab@redhat.com>
Cc: "=?utf-8?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>
Subject: =?utf-8?B?W1BBVENIIDYvNl0gbTg4ZHMzMTAzLCBkdmJza3kgcmVtb3RlIGNvbnRyb2wgaW5jbHVkZSBoZWFkZXIgZmlsZS4=?=
Message-ID: <201204152353536717686@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbsky remote control include header file for pci/pcie card.

Signed-off-by: Max nibble <nibble.max@gmail.com>
---
 include/media/rc-map.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 8db6741..7176dac 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -85,6 +85,7 @@ void rc_map_init(void);
 #define RC_MAP_DM1105_NEC                "rc-dm1105-nec"
 #define RC_MAP_DNTV_LIVE_DVBT_PRO        "rc-dntv-live-dvbt-pro"
 #define RC_MAP_DNTV_LIVE_DVB_T           "rc-dntv-live-dvb-t"
+#define RC_MAP_DVBSKY                    "rc-dvbsky"
 #define RC_MAP_EMPTY                     "rc-empty"
 #define RC_MAP_EM_TERRATEC               "rc-em-terratec"
 #define RC_MAP_ENCORE_ENLTV2             "rc-encore-enltv2"
-- 
1.7.9.5

