Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gnuzifer.de ([78.46.242.17]:48168 "EHLO mail.gnuzifer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3DLQqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 12:46:46 -0400
Received: from cl-653.leo-01.de.sixxs.net ([2a01:1e8:e100:28c::2]:48808 helo=localhost)
	by mail.gnuzifer.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <till.maas@till.name>)
	id 1UQgno-0003x2-3P
	for linux-media@vger.kernel.org; Fri, 12 Apr 2013 18:26:16 +0200
Date: Fri, 12 Apr 2013 18:26:14 +0200
From: Till Maas <opensource@till.name>
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-apps: initial scan file de-NetAachen
Message-ID: <20130412162614.GA3412@genius.invalid>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I created an initial scan file for the German provider Net Aachen (see
attachment).

Regards
Till

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="de-NetAachen.patch"

# HG changeset patch
# User Till Maas <opensource@till.name>
# Date 1365783843 -7200
# Node ID fcdee9c712c94ac8b830dcbfec31ea2e5489adc3
# Parent  f3a70b206f0f809b53e2de7d77578d15b7d831cb
add util/scan/dvb-c/de-NetAachen

initial scan file for Net Aachen

diff --git a/util/scan/dvb-c/de-NetAachen b/util/scan/dvb-c/de-NetAachen
new file mode 100644
--- /dev/null
+++ b/util/scan/dvb-c/de-NetAachen
@@ -0,0 +1,47 @@
+#------------------------------------------------------------------------------
+# file automatically generated by w_scan
+# (http://wirbel.htpc-forum.de/w_scan/index2.html)
+#! <w_scan> 20120605 1 0 CABLE DE </w_scan>
+# Manually adjusted by reducing whitespace between fec and mod
+#------------------------------------------------------------------------------
+# location and provider: Germany, Aachen, NetAachen, http://www.netaachen.de/
+# date (yyyy-mm-dd)    : 2013-04-11
+# provided by (opt)    : Till Maas <opensource@till.name>
+#
+# C[2] [plp_id] [data_slice_id] [system_id] <freq> <sr> <fec> <mod> [# comment]
+#------------------------------------------------------------------------------
+C 113000000 6900000 AUTO QAM256	# NetCologne
+C 642000000 6900000 AUTO QAM256	# NetCologne
+C 618000000 6900000 AUTO QAM256	# NetCologne
+C 634000000 6900000 AUTO QAM256	# NetCologne
+C 626000000 6900000 AUTO QAM256	# NetCologne
+C 562000000 6900000 AUTO QAM256	# NetCologne
+C 402000000 6900000 AUTO QAM256	# NetCologne
+C 121000000 6900000 AUTO QAM256	# NetCologne
+C 570000000 6900000 AUTO QAM256	# NetCologne
+C 394000000 6900000 AUTO QAM256	# NetCologne
+C 586000000 6900000 AUTO QAM256	# NetCologne
+C 650000000 6900000 AUTO QAM256	# NetCologne
+C 658000000 6900000 AUTO QAM256	# NetCologne
+C 666000000 6900000 AUTO QAM256	# NetCologne
+C 674000000 6900000 AUTO QAM256	# NetCologne
+C 682000000 6900000 AUTO QAM256	# NetCologne
+C 690000000 6900000 AUTO QAM256
+C 714000000 6900000 AUTO QAM256
+C 602000000 6900000 AUTO QAM256
+C 410000000 6900000 AUTO QAM256	# NetCologne
+C 418000000 6900000 AUTO QAM256	# NetCologne
+C 530000000 6900000 AUTO QAM256	# NetCologne
+C 538000000 6900000 AUTO QAM256	# NetCologne
+C 346000000 6900000 AUTO QAM256	# NetCologne
+C 338000000 6900000 AUTO QAM256	# NetCologne
+C 129000000 6900000 AUTO QAM256	# NetCologne
+C 354000000 6900000 AUTO QAM64	# BetaDigital
+C 362000000 6900000 AUTO QAM64	# BetaDigital
+C 370000000 6900000 AUTO QAM64	# BetaDigital
+C 386000000 6900000 AUTO QAM64	# BetaDigital
+C 378000000 6900000 AUTO QAM64	# BetaDigital
+C 610000000 6900000 AUTO QAM256
+C 578000000 6900000 AUTO QAM256
+C 698000000 6900000 AUTO QAM256
+C 706000000 6900000 AUTO QAM256

--pWyiEgJYm5f9v55/--
