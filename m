Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59442 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2D0HHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 03:07:44 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so210985pbb.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 00:07:44 -0700 (PDT)
Date: Fri, 27 Apr 2012 15:07:48 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>,
 <201204152353103757288@gmail.com>,
 <201204201601166255937@gmail.com>,
 <4F9130BB.8060107@iki.fi>,
 <201204211045557968605@gmail.com>,
 <4F958640.9010404@iki.fi>,
 <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>,
 <201204262103053283195@gmail.com>,
 <4F994CA8.8060200@redhat.com>
Subject: [PATCH 6/6 v2] dvbsky, remote control include header file
Message-ID: <201204271507464063941@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

