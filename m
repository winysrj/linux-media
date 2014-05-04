Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:63351 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaEDCJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:51 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 1/6] [dvb-apps] dvb-apps: fix typos throughout the dvb-apps tree
Date: Sun,  4 May 2014 02:51:16 +0100
Message-Id: <1399168281-20626-2-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As found by Debian's Lintian tool.

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 lib/libdvben50221/en50221_transport.c | 4 ++--
 lib/libdvbsec/dvbsec_cfg.h            | 2 +-
 util/alevt/exp-gfx.c                  | 2 +-
 util/dib3000-watch/dib3000-watch.c    | 2 +-
 util/dvbscan/dvbscan.c                | 2 +-
 util/scan/scan.c                      | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/libdvben50221/en50221_transport.c b/lib/libdvben50221/en50221_transport.c
index f6f46db..e5babeb 100644
--- a/lib/libdvben50221/en50221_transport.c
+++ b/lib/libdvben50221/en50221_transport.c
@@ -929,7 +929,7 @@ static int en50221_tl_process_data(struct en50221_transport_layer *tl,
 			break;
 		default:
 			print(LOG_LEVEL, ERROR, 1,
-			      "Recieved unexpected TPDU tag %02x from module on slot %02x\n",
+			      "Received unexpected TPDU tag %02x from module on slot %02x\n",
 			      tpdu_tag, slot_id);
 			tl->error_slot = slot_id;
 			tl->error = EN50221ERR_BADCAMDATA;
@@ -1226,7 +1226,7 @@ static int en50221_tl_handle_sb(struct en50221_transport_layer *tl,
 	// did we get enough data in the T_SB?
 	if (data_length != 1) {
 		print(LOG_LEVEL, ERROR, 1,
-		      "Recieved T_SB with invalid length from module on slot %02x\n",
+		      "Received T_SB with invalid length from module on slot %02x\n",
 		      slot_id);
 		tl->error_slot = slot_id;
 		tl->error = EN50221ERR_BADCAMDATA;
diff --git a/lib/libdvbsec/dvbsec_cfg.h b/lib/libdvbsec/dvbsec_cfg.h
index d4546de..81439bb 100644
--- a/lib/libdvbsec/dvbsec_cfg.h
+++ b/lib/libdvbsec/dvbsec_cfg.h
@@ -81,7 +81,7 @@
  *
  * The cmd-<lo|hi>-<v|h|l|r> describes the SEC cmd string to use in advanced mode for each of the possible combinations of
  * frequency band and polarisation. If a certain combination is not required, it may be omitted. It consists of a
- * space seperated combination of commands - those available are as follows:
+ * space separated combination of commands - those available are as follows:
  *
  *	tone(<0|1>)  - control the 22kHz tone 0:off, 1:on
  *	voltage(<0|13|18>) - control the LNB voltage 0v, 13v, or 18v
diff --git a/util/alevt/exp-gfx.c b/util/alevt/exp-gfx.c
index 82ab218..e68167b 100644
--- a/util/alevt/exp-gfx.c
+++ b/util/alevt/exp-gfx.c
@@ -123,7 +123,7 @@ static int ppm_output(struct export *e, char *name, struct fmt_page *pg)
     {
       if (!fwrite(rgb1[(int) *(colour_matrix+n)], 3, 1, fp))
 	{
-	  export_error("error while writting to file");
+	  export_error("error while writing to file");
 	  free(colour_matrix);
 	  fclose(fp);
 	  return -1;
diff --git a/util/dib3000-watch/dib3000-watch.c b/util/dib3000-watch/dib3000-watch.c
index 16bccb7..300e000 100644
--- a/util/dib3000-watch/dib3000-watch.c
+++ b/util/dib3000-watch/dib3000-watch.c
@@ -285,7 +285,7 @@ int main (int argc, char * const argv[])
 				break;
 			default:
 				interrupted=1;
-				err("no monitoring writting for this demod, yet.\n");
+				err("no monitoring writing for this demod, yet.\n");
 		}
 		usleep((int) (intervall * 1000000));
 	}
diff --git a/util/dvbscan/dvbscan.c b/util/dvbscan/dvbscan.c
index 87751c4..f23411f 100644
--- a/util/dvbscan/dvbscan.c
+++ b/util/dvbscan/dvbscan.c
@@ -77,7 +77,7 @@ static void usage(void)
 		" -inversion <on|off|auto> Specify inversion (default: auto) (note: this option is ignored).\n"
 		" -uk-ordering 		Use UK DVB-T channel ordering if present (note: this option is ignored).\n"
 		" -timeout <secs>	Specify filter timeout to use (standard specced values will be used by default)\n"
-		" -filter <filter>	Specify service filter, a comma seperated list of the following tokens:\n"
+		" -filter <filter>	Specify service filter, a comma separated list of the following tokens:\n"
 		" 			 (If no filter is supplied, all services will be output)\n"
 		"			 * tv - Output TV channels\n"
 		"			 * radio - Output radio channels\n"
diff --git a/util/scan/scan.c b/util/scan/scan.c
index 71a20db..803efdf 100644
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -1560,7 +1560,7 @@ static int parse_section (struct section_buf *s)
 	buf += 8;			/* past generic table header */
 	section_length -= 5 + 4;	/* header + crc */
 	if (section_length < 0) {
-		warning("truncated section (PID 0x%04x, lenght %d)",
+		warning("truncated section (PID 0x%04x, length %d)",
 			s->pid, section_length + 9);
 		return 0;
 	}
-- 
1.9.2

