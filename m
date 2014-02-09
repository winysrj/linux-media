Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57914 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaBIGGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 01:06:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/5] libdvbv5: better handle ATSC/Annex B
Date: Sun,  9 Feb 2014 08:05:50 +0200
Message-Id: <1391925954-25975-2-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-1-git-send-email-crope@iki.fi>
References: <1391925954-25975-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

As DVBv3 is confusing with regards to ATSC and ClearQAM (DVB-C
annex B), userpace apps also only differenciate between ATSC and
ClearQAM via modulation.

However, when using DVBv5, may be using the delivery system
in order to enforce one or the other.

In any case, the DVB API should clearly identify between ATSC
and ClearQAM.

So, make the API to better handle it, fixing the delivery
system if needed, when reading or write a file.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 lib/libdvbv5/dvb-file.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 1c33a90..e0cef34 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -88,6 +88,32 @@ int retrieve_entry_prop(struct dvb_entry *entry,
 	return -1;
 }
 
+static void adjust_delsys(struct dvb_entry *entry)
+{
+	uint32_t delsys = SYS_UNDEFINED;
+
+	retrieve_entry_prop(entry, DTV_DELIVERY_SYSTEM, &delsys);
+	switch (delsys) {
+	case SYS_ATSC:
+	case SYS_DVBC_ANNEX_B: {
+		uint32_t modulation = VSB_8;
+
+		retrieve_entry_prop(entry, DTV_MODULATION, &modulation);
+		switch (modulation) {
+		case VSB_8:
+		case VSB_16:
+			delsys = SYS_ATSC;
+			break;
+		default:
+			delsys = SYS_DVBC_ANNEX_B;
+			break;
+		}
+		store_entry_prop(entry, DTV_DELIVERY_SYSTEM, delsys);
+		break;
+	}
+	} /* switch */
+}
+
 /*
  * Generic parse function for all formats each channel is contained into
  * just one line.
@@ -242,7 +268,7 @@ struct dvb_file *parse_format_oneline(const char *fname,
 			entry->props[entry->n_props].cmd = DTV_INVERSION;
 			entry->props[entry->n_props++].u.data = INVERSION_AUTO;
 		}
-
+		adjust_delsys(entry);
 	} while (1);
 	fclose(fd);
 	free(buf);
@@ -330,6 +356,7 @@ int write_format_oneline(const char *fname,
 				 delsys);
 			goto error;
 		}
+		adjust_delsys(entry);
 		if (parse_file->has_delsys_id) {
 			fprintf(fp, "%s", formats[i].id);
 			first = 0;
@@ -596,6 +623,7 @@ struct dvb_file *read_dvb_file(const char *fname)
 				dvb_file->first_entry = calloc(sizeof(*entry), 1);
 				entry = dvb_file->first_entry;
 			} else {
+				adjust_delsys(entry);
 				entry->next = calloc(sizeof(*entry), 1);
 				entry = entry->next;
 			}
@@ -644,6 +672,8 @@ struct dvb_file *read_dvb_file(const char *fname)
 			}
 		}
 	} while (1);
+	if (entry)
+		adjust_delsys(entry);
 	fclose(fd);
 	return dvb_file;
 
@@ -668,6 +698,7 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 	}
 
 	for (entry = dvb_file->first_entry; entry != NULL; entry = entry->next) {
+		adjust_delsys(entry);
 		if (entry->channel) {
 			fprintf(fp, "[%s]\n", entry->channel);
 			if (entry->vchannel)
-- 
1.8.5.3

