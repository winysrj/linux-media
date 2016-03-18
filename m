Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35911 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcCRM6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 08:58:54 -0400
Received: by mail-wm0-f42.google.com with SMTP id l124so30174295wmf.1
        for <linux-media@vger.kernel.org>; Fri, 18 Mar 2016 05:58:53 -0700 (PDT)
Received: from fractal.localdomain (255.163.90.146.dyn.plus.net. [146.90.163.255])
        by smtp.gmail.com with ESMTPSA id ys9sm12130079wjc.35.2016.03.18.05.58.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Mar 2016 05:58:52 -0700 (PDT)
Date: Fri, 18 Mar 2016 12:58:36 +0000 (GMT)
From: Edward Sheldrake <ejsheldrake@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] libdvbv5: Fix dvb-format-convert segfault
Message-ID: <alpine.LFD.2.20.1603181255120.22757@fractal.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes dvb-format-convert crashing when encountering an
unrecognised polarization value.

Signed-off-by: Edward Sheldrake <ejsheldrake@gmail.com>
---
 lib/libdvbv5/dvb-file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 3fda65f..fc2bebc 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -648,8 +648,8 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 	else if (!strcasecmp(key, "AUDIO_PID"))
 		is_audio = 1;
 	else if (!strcasecmp(key, "POLARIZATION")) {
-		for (j = 0; ARRAY_SIZE(dvb_sat_pol_name); j++)
-			if (!strcasecmp(value, dvb_sat_pol_name[j]))
+		for (j = 0; j < ARRAY_SIZE(dvb_sat_pol_name); j++)
+			if (dvb_sat_pol_name[j] && !strcasecmp(value, dvb_sat_pol_name[j]))
 				break;
 		if (j == ARRAY_SIZE(dvb_sat_pol_name))
 			return -2;
-- 
2.5.0

