Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56191 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaDOSl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 14:41:28 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so8012476eek.16
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 11:41:27 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/4] libdvbv5: short API description
Date: Tue, 15 Apr 2014 20:39:32 +0200
Message-Id: <1397587173-1120-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
References: <1397587173-1120-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index f0af9d7..8f0e553 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -76,6 +76,32 @@ struct dvb_table_filter {
 
 void dvb_table_filter_free(struct dvb_table_filter *sect);
 
+/* Read DVB table sections
+ *
+ * The following functions can be used to read DVB table sections by
+ * specifying a table ID and a program ID. Optionally a transport
+ * stream ID can be specified as well. The function will read on the
+ * specified demux and return when reading is done or an error has
+ * occurred. If table is not NULL after the call, it has to be freed
+ * with the apropriate free table function (even if an error has
+ * occurred).
+ *
+ * Returns 0 on success or a negative error code.
+ *
+ * Example usage:
+ *
+ * struct dvb_table_pat *pat;
+ * int r = dvb_read_section( parms, dmx_fd, DVB_TABLE_PAT, DVB_TABLE_PAT_PID, (void **) &pat, 5 );
+ * if (r < 0)
+ *	dvb_logerr("error reading PAT table");
+ * else {
+ *	// do something with pat
+ * }
+ * if (pat)
+ *	dvb_table_pat_free( pat );
+ *
+ */
+
 int dvb_read_section(struct dvb_v5_fe_parms *parms, int dmx_fd, unsigned char tid, uint16_t pid, void **table,
 		unsigned timeout);
 
-- 
1.9.1

