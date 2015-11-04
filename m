Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34295 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbKDBwy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 20:52:54 -0500
Received: by ykdr3 with SMTP id r3so48536661ykd.1
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2015 17:52:53 -0800 (PST)
MIME-Version: 1.0
From: Felipe Eduardo Concha Avello <felipec84@gmail.com>
Date: Tue, 3 Nov 2015 22:52:24 -0300
Message-ID: <CADR3MB+gkJcqLUWfi775pW+7d+0d3XtFN4CJmJ=7y2gR1czv2A@mail.gmail.com>
Subject: [PATCH] libdvbv5: fix the count of partial receptions
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the number of elements are counted wrong, its divided by the size
of a pointer and not the size of the struct
isdb_desc_partial_reception (uint16_t).

I noticed this when using "dvbv5-scan -v" in order to debug an ISDB-T table.

Signed-off-by: Felipe Concha Avello <felipec84@gmail.com>
---
diff --git a/lib/libdvbv5/descriptors/desc_partial_reception.c
b/lib/libdvbv5/descriptors/desc_partial_reception.c
index ce40882..63b8a07 100644
--- a/lib/libdvbv5/descriptors/desc_partial_reception.c
+++ b/lib/libdvbv5/descriptors/desc_partial_reception.c
@@ -38,7 +38,7 @@ int isdb_desc_partial_reception_init(struct
dvb_v5_fe_parms *parms,

        memcpy(d->partial_reception, p, d->length);

-       len = d->length / sizeof(d->partial_reception);
+       len = d->length / sizeof(*d->partial_reception);

        for (i = 0; i < len; i++)
                bswap16(d->partial_reception[i].service_id);
@@ -58,7 +58,7 @@ void isdb_desc_partial_reception_print(struct
dvb_v5_fe_parms *parms, const stru
        int i;
        size_t len;

-       len = d->length / sizeof(d->partial_reception);
+       len = d->length / sizeof(*d->partial_reception);

        for (i = 0; i < len; i++) {
                dvb_loginfo("|           service ID[%d]     %d", i,
d->partial_reception[i].service_id);
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 1ffb98a..38f558b 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -905,7 +905,7 @@ static void add_update_nit_1seg(struct dvb_table_nit *nit,
        if (!tr->update)
                return;

-       len = d->length / sizeof(d->partial_reception);
+       len = d->length / sizeof(*d->partial_reception);

        for (i = 0; i < len; i++) {
                if (tr->entry->service_id ==
d->partial_reception[i].service_id) {
