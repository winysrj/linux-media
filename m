Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40213 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbeGGLVJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 07:21:09 -0400
Received: by mail-ed1-f67.google.com with SMTP id e19-v6so10443191edq.7
        for <linux-media@vger.kernel.org>; Sat, 07 Jul 2018 04:21:09 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/4] libdvbv5: fix double free in dvb_fe_open_fname
Date: Sat,  7 Jul 2018 13:20:55 +0200
Message-Id: <20180707112057.7235-2-neolynx@gmail.com>
In-Reply-To: <20180707112057.7235-1-neolynx@gmail.com>
References: <20180707112057.7235-1-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since parms and fname is allocated outside of the function, do not free it.
Use dvb_v5_free for freeing parms, it will free fname if required.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-fe.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 7dcfa53e..5dcf492e 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -185,7 +185,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 
 	ret = dvb_fe_open_fname(parms, fname, flags);
 	if (ret < 0) {
-		free(parms);
+		dvb_v5_free(parms);
 		return NULL;
 	}
 
@@ -209,9 +209,7 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 
 	if (xioctl(fd, FE_GET_INFO, &parms->p.info) == -1) {
 		dvb_perror("FE_GET_INFO");
-		dvb_v5_free(parms);
 		close(fd);
-		free(fname);
 		return -errno;
 	}
 
@@ -293,7 +291,6 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 		}
 		if (!parms->p.num_systems) {
 			dvb_logerr(_("delivery system not detected"));
-			dvb_v5_free(parms);
 			close(fd);
 			return -EINVAL;
 		}
@@ -304,7 +301,6 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 		dtv_prop.props = parms->dvb_prop;
 		if (xioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
 			dvb_perror("FE_GET_PROPERTY");
-			dvb_v5_free(parms);
 			close(fd);
 			return -errno;
 		}
@@ -314,7 +310,6 @@ int dvb_fe_open_fname(struct dvb_v5_fe_parms_priv *parms, char *fname,
 
 		if (parms->p.num_systems == 0) {
 			dvb_logerr(_("driver returned 0 supported delivery systems!"));
-			dvb_v5_free(parms);
 			close(fd);
 			return -EINVAL;
 		}
-- 
2.14.1
