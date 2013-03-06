Return-path: <linux-media-owner@vger.kernel.org>
Received: from woodbine.london.02.net ([87.194.255.145]:47735 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3CFASP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 19:18:15 -0500
Received: from cartman.offog.org (94.194.126.16) by woodbine.london.02.net (8.5.140)
        id 50D1077A0291A714 for linux-media@vger.kernel.org; Wed, 6 Mar 2013 00:11:46 +0000
Received: from ats by cartman.offog.org with local (Exim 4.80.1)
	(envelope-from <ats@offog.org>)
	id 1UD1xR-0003Gj-RF
	for linux-media@vger.kernel.org; Wed, 06 Mar 2013 00:11:45 +0000
Date: Wed, 6 Mar 2013 00:11:45 +0000
From: Adam Sampson <ats@offog.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-apps/scan: distinguish transponders with different
 polarisations
Message-ID: <20130306001145.GI3420@cartman.at.offog.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've just gone to listen to a DVB-S radio station from Eutelsat 28A, and
was a bit surprised when "scan" either didn't find it, or found it with
the wrong polarisation. With -vvv, the cause was reasonably easy to see:

| $ echo 'S 12607000 V 27500000 2/3' >transponders
| $ scan -l universal -x0 -t3 -vvv transponders
| scanning transponders
| [...]
| initial transponder 12607000 V 27500000 2
| >>> tune to: 12607:v:0:27500
| [...]
| parse_nit:1271: transport_stream_id 0x0a35
| parse_satellite_delivery_system_descriptor:461: 0x20/0xa35 12606:h:0:27500
| is_same_transponder:217: f1 = 12607000 is same TP as f2 = 12606650

Oh no it isn't! The one it's found in the NIT is horizontally polarised,
and the initial one I gave it was vertically polarised... but
find_transponder doesn't check that the polarisation matches. It assumes
that transponders can be uniquely identified by frequency -- which is a
reasonable assumption for DVB-T and DVB-C, but not for DVB-S.

I've attached a patch that makes it check the polarisation, and renames
is_same_transponder to is_same_frequency in the interests of being a bit
more explicit about what exactly it's checking. With the patch, I get
about 100 more FTA channels correctly identified on 28.2E -- however, I
haven't tested it on anything other than my DVB-S setup, so you probably
don't want to apply it without some more experimentation.

(Tracking this down was probably more interesting than listening to the
radio would have been anyway!)

Thanks,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>

--5vNYLRcllDrimb99
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

--5vNYLRcllDrimb99--
