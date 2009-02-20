Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 84.122.64.124.dyn.user.ono.com ([84.122.64.124]
	helo=mail.xiterrex.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <terrex@xiterrex.net>) id 1LchVz-0002qt-4f
	for linux-dvb@linuxtv.org; Thu, 26 Feb 2009 15:47:07 +0100
MIME-Version: 1.0
Message-Id: <078bd274de0d26a92ccf.1235153417@localhost>
Date: Fri, 20 Feb 2009 19:10:17 +0100
From: xiterrex@gmail.com
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] New frequency table for Cadiz (Andalusia, Spain)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

# HG changeset patch
# User terrex@xiterrex.net
# Date 1235153250 -3600
# Node ID 078bd274de0d26a92ccff6c7da050edbc299f0b7
# Parent  f83a2a650df2bcf2ce659012f011ee5dcd7b1d74
New frequency table for Cadiz (Andalusia, Spain)

diff -r f83a2a650df2 -r 078bd274de0d util/scan/dvb-t/es-Cadiz
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/es-Cadiz	Fri Feb 20 19:07:30 2009 +0100
@@ -0,0 +1,8 @@
+# DVB-T Cadiz (Andalucia)                      by terrex  Feb 2009
+# T freq bw fec_hi fec_lo mod transm-mode guard-interval hierarchy
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C59
+T 818000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C64
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C66
+T 842000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C67
+T 850000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C68
+T 858000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE                  # C69



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
