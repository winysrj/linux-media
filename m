Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:15805 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbaCDUTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 15:19:00 -0500
Received: from localhost.localdomain ([2a02:8109:9f40:8e4:beae:c5ff:fe2c:b8a3])
	by smtp.strato.de (RZmta 32.27 AUTH)
	with ESMTPSA id K04bcbq24KCiQhU
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-media@vger.kernel.org>;
	Tue, 4 Mar 2014 21:12:44 +0100 (CET)
Message-ID: <531633BB.7050908@stefanringel.de>
Date: Tue, 04 Mar 2014 21:12:43 +0100
From: Stefan Ringel <mail@stefanringel.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed;
 boundary="------------000506020809020507050703"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000506020809020507050703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------000506020809020507050703
Content-Type: text/x-patch;
 name="0001-v4l-utils-bugfix-memory-chunk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-v4l-utils-bugfix-memory-chunk.patch"

>From a5cfa1881de152a887d195e8c880dcca3e6b766e Mon Sep 17 00:00:00 2001
From: Stefan Ringel <linuxtv@stefanringel.de>
Date: Tue, 4 Mar 2014 20:50:32 +0100
Subject: [PATCH] v4l-utils: bugfix memory chunk

Bug 1070855 - [abrt] v4l-utils: parse_string(): dvbv5-scan killed by SIGABRT
https://bugzilla.redhat.com/show_bug.cgi?id=1070855

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 lib/libdvbv5/descriptors/desc_frequency_list.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/descriptors/desc_frequency_list.c b/lib/libdvbv5/descriptors/desc_frequency_list.c
index de6f9fd..0a06a4a 100644
--- a/lib/libdvbv5/descriptors/desc_frequency_list.c
+++ b/lib/libdvbv5/descriptors/desc_frequency_list.c
@@ -36,10 +36,10 @@ void dvb_desc_frequency_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *
 
 	d->frequencies = (d->length - len) / sizeof(d->frequency[0]);
 
-	d->frequency = calloc(1, sizeof(d->frequency));
+	d->frequency = calloc(d->frequencies, sizeof(d->frequency));
 
 	for (i = 0; i < d->frequencies; i++) {
-		d->frequency[i] = ((uint32_t *) buf)[i];
+		d->frequency[i] = ((uint32_t *) p)[i];
 		bswap32(d->frequency[i]);
 		switch (d->freq_type) {
 			case 1: /* satellite - to get kHz */
-- 
1.9.0


--------------000506020809020507050703--
