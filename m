Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065AbcALDvc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 22:51:32 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 71FBC42E5D9
	for <linux-media@vger.kernel.org>; Tue, 12 Jan 2016 03:51:32 +0000 (UTC)
Received: from t440s.akl.redhat.com (ovpn-113-40.phx2.redhat.com [10.3.113.40])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u0C3pVtJ010348
	for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 22:51:32 -0500
From: Steven Ellis <sellis@redhat.com>
Subject: Add support for additional LNB types with LO of 11300 and 10700
To: linux-media@vger.kernel.org
Message-ID: <56947843.8060801@redhat.com>
Date: Tue, 12 Jan 2016 16:51:31 +1300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Here in NZ we regularly see Wide Band 10700LO and 11300LO LNBs for
services on Optus D1/C1/D2

I've added their ranges to test scanning with the newer libdvdv5 utils
as per below.


diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 473a24b..13165fd 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -75,6 +75,20 @@ static const struct dvb_sat_lnb lnb[] = {
                        { 10945, 11450 }
                },
        }, {
+               .name = "L10700",
+               .alias = "L10700",
+               .lowfreq = 10700,
+               .freqrange = {
+                       { 11750, 12750 }
+               },
+       }, {
+               .name = "L11300",
+               .alias = "L11300",
+               .lowfreq = 11300,
+               .freqrange = {
+                       { 12250, 12750 }
+               },
+       }, {
                .name = "Astra",
                .alias = "ENHANCED",
                .lowfreq = 9750,


-- 
Steven Ellis
Senior Solution Architect - Red Hat New Zealand <http://www.redhat.co.nz/>
*T:* +64 9 887 3207
*M:* +64 21 321 673
*E:* sellis@redhat.com <mailto:sellis@redhat.com>

