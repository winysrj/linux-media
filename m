Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58856 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbaDIW1X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:27:23 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so2375150eek.31
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 15:27:22 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/7] libdvbv5: make dvb_table_filter_free public
Date: Thu, 10 Apr 2014 00:26:57 +0200
Message-Id: <1397082420-31198-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
References: <1397082420-31198-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make dvb_table_filter_free public so it can be used by
applications.
fix potential double free.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h |    2 ++
 lib/libdvbv5/dvb-scan.c         |   10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index 206d409..f0af9d7 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -74,6 +74,8 @@ struct dvb_table_filter {
 	void *priv;
 };
 
+void dvb_table_filter_free(struct dvb_table_filter *sect);
+
 int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, void **table,
 		unsigned timeout);
 
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index e522225..d8b3953 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -158,10 +158,12 @@ static int dvb_parse_section_alloc(struct dvb_v5_fe_parms *parms,
 	return 0;
 }
 
-static void dvb_parse_section_free(struct dvb_table_filter *sect)
+void dvb_table_filter_free(struct dvb_table_filter *sect)
 {
-	if (sect->priv)
+	if (sect->priv) {
 		free(sect->priv);
+		sect->priv = NULL;
+	}
 }
 
 static int dvb_parse_section(struct dvb_v5_fe_parms *parms,
@@ -280,7 +282,7 @@ int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	if (!buf) {
 		dvb_perror("Out of memory");
 		dvb_dmx_stop(dmx_fd);
-		dvb_parse_section_free(sect);
+		dvb_table_filter_free(sect);
 		return -1;
 	}
 
@@ -327,7 +329,7 @@ int dvb_read_sections(struct dvb_v5_fe_parms *parms, int dmx_fd,
 	} while (!ret);
 	free(buf);
 	dvb_dmx_stop(dmx_fd);
-	dvb_parse_section_free(sect);
+	dvb_table_filter_free(sect);
 
 	if (ret > 0)
 		ret = 0;
-- 
1.7.10.4

