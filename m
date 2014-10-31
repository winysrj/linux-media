Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53717 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbaJaNOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:21 -0400
Received: by mail-pd0-f174.google.com with SMTP id p10so7219123pdj.19
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:21 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 3/7] v4l-utils/libdvbv5: wrong frequency in the output of satellite delsys scans
Date: Fri, 31 Oct 2014 22:13:40 +0900
Message-Id: <1414761224-32761-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

In the output of satellite delsys's scanning,
channel frequencies were offset by the LNB's LO frequency,
which should be not.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-fe.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index f535311..01b2848 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -604,8 +604,12 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
 		}
 
 		/* copy back params from temporary fe_prop */
-		for (i = 0; i < n; i++)
+		for (i = 0; i < n; i++) {
+			if (dvb_fe_is_satellite(p->current_sys)
+			    && fe_prop[i].cmd == DTV_FREQUENCY)
+				fe_prop[i].u.data += parms->freq_offset;
 			dvb_fe_store_parm(&parms->p, fe_prop[i].cmd, fe_prop[i].u.data);
+		}
 
 		if (parms->p.verbose) {
 			dvb_log("Got parameters for %s:",
@@ -683,8 +687,19 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
 			dvb_logdbg("LNA is %s", parms->p.lna ? "ON" : "OFF");
 	}
 
-	if (dvb_fe_is_satellite(tmp_parms.p.current_sys))
+	if (dvb_fe_is_satellite(tmp_parms.p.current_sys)) {
 		dvb_sat_set_parms(&tmp_parms.p);
+		/*
+		 * even though the frequncy prop is kept un-modified here,
+		 * a later call to dvb_fe_get_parms() issues FE_GET_PROPERTY
+		 * ioctl and overwrites it with the offset-ed value from
+		 * the FE. So we need to save the offset here and
+		 * re-add it in dvb_fe_get_parms().
+		 * note that dvbv5-{scan,zap} utilities call dvb_fe_get_parms()
+		 * indirectly from check_frontend() via dvb_fe_get_stats().
+		 */
+		parms->freq_offset = tmp_parms.freq_offset;
+	}
 
 	/* Filter out any user DTV_foo property such as DTV_POLARIZATION */
 	tmp_parms.n_props = dvb_copy_fe_props(tmp_parms.dvb_prop,
-- 
2.1.3

