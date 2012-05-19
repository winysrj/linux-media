Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48536 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2ESKTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 06:19:50 -0400
Received: by wibhn6 with SMTP id hn6so899661wib.1
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 03:19:49 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/5] libscan renamings
Date: Sat, 19 May 2012 12:18:50 +0200
Message-Id: <1337422732-2001-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
References: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/libscan.h  |   12 ++++++++++--
 lib/libdvbv5/libscan.c |    6 +++---
 utils/dvb/dvbv5-scan.c |    4 ++--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/lib/include/libscan.h b/lib/include/libscan.h
index bc11ce1..a2b061c 100644
--- a/lib/include/libscan.h
+++ b/lib/include/libscan.h
@@ -136,11 +136,19 @@ struct dvb_descriptors {
 	unsigned cur_ts;
 };
 
-struct dvb_descriptors *get_dvb_ts_tables(int dmx_fd,
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
 					  uint32_t delivery_system,
 					  unsigned other_nit,
 					  unsigned timeout_multiply,
 					  int verbose);
-void free_dvb_ts_tables(struct dvb_descriptors *dvb_desc);
+void dvb_free_ts_tables(struct dvb_descriptors *dvb_desc);
+
+#ifdef __cplusplus
+}
+#endif
 
 #endif
diff --git a/lib/libdvbv5/libscan.c b/lib/libdvbv5/libscan.c
index dd010e1..7916d36 100644
--- a/lib/libdvbv5/libscan.c
+++ b/lib/libdvbv5/libscan.c
@@ -400,7 +400,7 @@ static int read_section(int dmx_fd, struct dvb_descriptors *dvb_desc,
 	return 0;
 }
 
-struct dvb_descriptors *get_dvb_ts_tables(int dmx_fd,
+struct dvb_descriptors *dvb_get_ts_tables(int dmx_fd,
 					  uint32_t delivery_system,
 					  unsigned other_nit,
 					  unsigned timeout_multiply,
@@ -460,7 +460,7 @@ struct dvb_descriptors *get_dvb_ts_tables(int dmx_fd,
 			  pat_pmt_time * timeout_multiply);
 	if (rc < 0) {
 		fprintf(stderr, "error while waiting for PAT table\n");
-		free_dvb_ts_tables(dvb_desc);
+		dvb_free_ts_tables(dvb_desc);
 		return NULL;
 	}
 
@@ -504,7 +504,7 @@ struct dvb_descriptors *get_dvb_ts_tables(int dmx_fd,
 }
 
 
-void free_dvb_ts_tables(struct dvb_descriptors *dvb_desc)
+void dvb_free_ts_tables(struct dvb_descriptors *dvb_desc)
 {
 	struct pat_table *pat_table = &dvb_desc->pat_table;
 	struct pid_table *pid_table = dvb_desc->pat_table.pid_table;
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index c7b18eb..64945cc 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -406,7 +406,7 @@ static int run_scan(struct arguments *args,
 		if (rc < 0)
 			continue;
 
-		dvb_desc = get_dvb_ts_tables(dmx_fd,
+		dvb_desc = dvb_get_ts_tables(dmx_fd,
 					     parms->current_sys,
 					     args->other_nit,
 					     args->timeout_multiply,
@@ -433,7 +433,7 @@ static int run_scan(struct arguments *args,
 		if (!args->dont_add_new_freqs)
 			add_other_freq_entries(dvb_file, parms, dvb_desc);
 
-		free_dvb_ts_tables(dvb_desc);
+		dvb_free_ts_tables(dvb_desc);
 	}
 
 	if (dvb_file_new)
-- 
1.7.2.5

