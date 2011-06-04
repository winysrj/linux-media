Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:55200 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab1FDOwi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 10:52:38 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsDL-0002Cv-Af
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 16:52:37 +0200
Message-ID: <4DEA46B2.7090409@mailbox.hu>
Date: Sat, 04 Jun 2011 16:52:34 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: simplified seek_firmware()
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000107010204010907090603"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------000107010204010907090603
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

This patch simplifies the code in seek_firmware().

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------000107010204010907090603
Content-Type: text/x-patch;
 name="xc4000_fwseek.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_fwseek.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 12:50:41.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 13:10:00.000000000 +0200
@@ -606,8 +606,8 @@
 			 v4l2_std_id *id)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	int                 i, best_i = -1, best_nr_matches = 0;
-	unsigned int        type_mask = 0;
+	int		i, best_i = -1;
+	unsigned int	best_nr_diffs = 255U;
 
 	if (!priv->firm) {
 		printk("Error! firmware not loaded\n");
@@ -617,63 +617,42 @@
 	if (((type & ~SCODE) == 0) && (*id == 0))
 		*id = V4L2_STD_PAL;
 
-	if (type & BASE)
-		type_mask = BASE_TYPES;
-	else if (type & SCODE) {
-		type &= SCODE_TYPES;
-		type_mask = SCODE_TYPES & ~HAS_IF;
-	} else if (type & DTV_TYPES)
-		type_mask = DTV_TYPES;
-	else if (type & STD_SPECIFIC_TYPES)
-		type_mask = STD_SPECIFIC_TYPES;
-
-	type &= type_mask;
-
-	if (!(type & SCODE))
-		type_mask = ~0;
-
-	/* Seek for exact match */
-	for (i = 0; i < priv->firm_size; i++) {
-		if ((type == (priv->firm[i].type & type_mask)) &&
-		    (*id == priv->firm[i].id))
-			goto found;
-	}
-
 	/* Seek for generic video standard match */
 	for (i = 0; i < priv->firm_size; i++) {
-		v4l2_std_id match_mask;
-		int nr_matches;
+		v4l2_std_id	id_diff_mask =
+			(priv->firm[i].id ^ (*id)) & (*id);
+		unsigned int	type_diff_mask =
+			(priv->firm[i].type ^ type)
+			& (BASE_TYPES | DTV_TYPES | LCD | NOGD | MONO | SCODE);
+		unsigned int	nr_diffs;
 
-		if (type != (priv->firm[i].type & type_mask))
+		if (type_diff_mask
+		    & (BASE | INIT1 | FM | DTV6 | DTV7 | DTV78 | DTV8 | SCODE))
 			continue;
 
-		match_mask = *id & priv->firm[i].id;
-		if (!match_mask)
-			continue;
-
-		if ((*id & match_mask) == *id)
-			goto found; /* Supports all the requested standards */
+		nr_diffs = hweight64(id_diff_mask) + hweight32(type_diff_mask);
+		if (!nr_diffs)	/* Supports all the requested standards */
+			goto found;
 
-		nr_matches = hweight64(match_mask);
-		if (nr_matches > best_nr_matches) {
-			best_nr_matches = nr_matches;
+		if (nr_diffs < best_nr_diffs) {
+			best_nr_diffs = nr_diffs;
 			best_i = i;
 		}
 	}
 
-	if (best_nr_matches > 0) {
-		printk("Selecting best matching firmware (%d bits) for "
-			  "type=", best_nr_matches);
+	/* FIXME: Would make sense to seek for type "hint" match ? */
+	if (best_i < 0) {
+		i = -ENOENT;
+		goto ret;
+	}
+
+	if (best_nr_diffs > 0U) {
+		printk("Selecting best matching firmware (%u bits differ) for "
+		       "type=", best_nr_diffs);
 		printk("(%x), id %016llx:\n", type, (unsigned long long)*id);
 		i = best_i;
-		goto found;
 	}
 
-	/*FIXME: Would make sense to seek for type "hint" match ? */
-
-	i = -ENOENT;
-	goto ret;
-
 found:
 	*id = priv->firm[i].id;
 

--------------000107010204010907090603--
