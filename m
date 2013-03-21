Return-path: <linux-media-owner@vger.kernel.org>
Received: from anakin.london.02.net ([87.194.255.134]:36175 "EHLO
	anakin.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CULRS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 07:17:18 -0400
Received: from cartman.offog.org (94.194.126.16) by anakin.london.02.net (8.5.140)
        id 50D100E101E99177 for linux-media@vger.kernel.org; Thu, 21 Mar 2013 11:17:17 +0000
Received: from ats by cartman.offog.org with local (Exim 4.80.1)
	(envelope-from <ats@offog.org>)
	id 1UIdUi-0005FE-F4
	for linux-media@vger.kernel.org; Thu, 21 Mar 2013 11:17:16 +0000
Date: Thu, 21 Mar 2013 11:17:16 +0000
From: Adam Sampson <ats@offog.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-apps/scan: distinguish transponders with different
 polarisations
Message-ID: <20130321111715.GA19962@cartman.at.offog.org>
References: <20130306001145.GI3420@cartman.at.offog.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20130306001145.GI3420@cartman.at.offog.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 06, 2013 at 12:11:45AM +0000, Adam Sampson wrote:
> [scan] assumes that transponders can be uniquely identified by
> frequency -- which is a reasonable assumption for DVB-T and DVB-C, but
> not for DVB-S.
> I've attached a patch that makes it check the polarisation, [...]

Does anyone have any thoughts on this -- or is there a separate bug
tracker for dvb-apps I should file the patch in?

Thanks,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scan-check-polarisation.patch"

# HG changeset patch
# User Adam Sampson <ats@offog.org>
# Date 1362526729 0
# Node ID 7eddf860ec93c7170155cdc95c1356e7d9dd5cd2
# Parent  f3a70b206f0f809b53e2de7d77578d15b7d831cb
scan: distinguish transponders with different polarisations

On DVB-S, it's possible to have two transponders with the same
frequency, provided they've got different polarisations -- e.g. Eutelsat
28A has 12560 H and V transponders. However, scan's find_transponder
previously assumed that two transponders were the same if they had the
same frequency.

This patch makes find_transponder check that the polarisations are also
the same, in the DVB-S case, and renames is_same_transponder to
is_same_frequency to make it clearer what it's actually checking.

diff -r f3a70b206f0f -r 7eddf860ec93 util/scan/scan.c
--- a/util/scan/scan.c	Sun Mar 03 12:51:40 2013 +0530
+++ b/util/scan/scan.c	Tue Mar 05 23:38:49 2013 +0000
@@ -206,7 +206,7 @@
 	return tp;
 }
 
-static int is_same_transponder(uint32_t f1, uint32_t f2)
+static int is_same_frequency(uint32_t f1, uint32_t f2)
 {
 	uint32_t diff;
 	if (f1 == f2)
@@ -214,13 +214,13 @@
 	diff = (f1 > f2) ? (f1 - f2) : (f2 - f1);
 	//FIXME: use symbolrate etc. to estimate bandwidth
 	if (diff < 2000) {
-		debug("f1 = %u is same TP as f2 = %u\n", f1, f2);
+		debug("f1 = %u is same frequency as f2 = %u\n", f1, f2);
 		return 1;
 	}
 	return 0;
 }
 
-static struct transponder *find_transponder(uint32_t frequency)
+static struct transponder *find_transponder(uint32_t frequency, enum polarisation pol)
 {
 	struct list_head *pos;
 	struct transponder *tp;
@@ -229,12 +229,14 @@
 		tp = list_entry(pos, struct transponder, list);
 		if (current_tp_only)
 			return tp;
-		if (is_same_transponder(tp->param.frequency, frequency))
+		if (is_same_frequency(tp->param.frequency, frequency)
+		    && (tp->type != FE_QPSK || tp->polarisation == pol))
 			return tp;
 	}
 	list_for_each(pos, &new_transponders) {
 		tp = list_entry(pos, struct transponder, list);
-		if (is_same_transponder(tp->param.frequency, frequency))
+		if (is_same_frequency(tp->param.frequency, frequency)
+		    && (tp->type != FE_QPSK || tp->polarisation == pol))
 			return tp;
 	}
 	return NULL;
@@ -1280,7 +1282,7 @@
 
 		if (tn.type == fe_info.type) {
 			/* only add if develivery_descriptor matches FE type */
-			t = find_transponder(tn.param.frequency);
+			t = find_transponder(tn.param.frequency, tn.polarisation);
 			if (!t)
 				t = alloc_transponder(tn.param.frequency);
 			copy_transponder(t, &tn);
@@ -2012,7 +2014,7 @@
 			/* check if the alternate freqeuncy is really new to us */
 			freq = t->other_f[t->n_other_f - 1];
 			t->n_other_f--;
-			if (find_transponder(freq))
+			if (find_transponder(freq, t->polarisation))
 				goto next;
 
 			/* remember tuning to the old frequency failed */

--cNdxnHkX5QqsyA0e--
