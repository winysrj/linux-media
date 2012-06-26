Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56629 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2FZUjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:39:40 -0400
Received: by weyu7 with SMTP id u7so234921wey.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:39:39 -0700 (PDT)
Message-ID: <4FEA1E08.3070703@suse.cz>
Date: Tue, 26 Jun 2012 22:39:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: js@convergence.de, adq_dvb@lidskialf.net
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH dvb-utils] proper dvb-t scan data for Czech Republic
Content-Type: multipart/mixed;
 boundary="------------080108060504080608000600"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080108060504080608000600
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

BTW I would appreciate if you move also dvb-utils to GIT. hg wastes our
time.
-- 
js
suse labs

--------------080108060504080608000600
Content-Type: text/x-patch;
 name="cz-All.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cz-All.patch"

# HG changeset patch
# User Jiri Slaby <jirislaby@gmail.com>
# Date 1340742534 -7200
# Node ID 96025655e6e844af2bc69bd368f8d04a4e5bc58b
# Parent  4030c51d6e7baef760e65d4ff2e8f61af91bec02
proper dvb-t scan data for Czech Republic

The tuning parameters are different for multiplexes 3 and 4. And the
scan data are invalid for them. Further there are few more
transmitters built in here. Especially for mux 4. So it is added too.

diff -r 4030c51d6e7b -r 96025655e6e8 util/scan/dvb-t/cz-All
--- a/util/scan/dvb-t/cz-All	Tue Apr 10 16:44:06 2012 +0200
+++ b/util/scan/dvb-t/cz-All	Tue Jun 26 22:28:54 2012 +0200
@@ -3,39 +3,50 @@
 # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
 # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
 # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and http://www.digitalnitelevize.cz/informace/dvb-t/vysilaci-sit-1.html
+# and http://www.digitalnitelevize.cz/informace/dvb-t/vysilaci-sit-2.html
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# multiplexes 1+2
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
 T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 802000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# multiplex 3
+T 482000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# multiplex 4
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 826000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE

--------------080108060504080608000600--
