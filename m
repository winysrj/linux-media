Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1KLF4Z-0005mu-QD
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 12:26:24 +0200
Message-ID: <008401c8ebe5$4e09ea90$450011ac@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 22 Jul 2008 22:25:43 +1200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0081_01C8EC49.E142FA90"
Subject: [linux-dvb] 682Mhz problem with TT-1501 driver in v4l-dvb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0081_01C8EC49.E142FA90
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Hi - please help!!!!

I have patched the v4l-dvb driver with Sigmund Augdal's changes to support 
C-1501.  I can't get channels to work on all but one frequency - 682Mhz.
Frequencies which work:  578, 586, 594, 602, 610, 626, 634, 642, 666, 674 
Mhz.

I have some channels at 674Mhz and at 682Mhz.  My initial is:
# Initial Testing
# freq sr fec mod
# freq sr fec mod
C 674000000 6900000 AUTO QAM64
C 682000000 6900000 AUTO QAM64


Scanning gives me:
./scan -A 2 test_initial
initial transponder 674000000 6900000 9 3
initial transponder 682000000 6900000 9 3
>>> tune to: 674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64
0x0000 0x0321: pmt_pid 0x0029 T -- Sky Movies (running, scrambled)
0x0000 0x0322: pmt_pid 0x002a T -- Sky Movies Greats (running, scrambled)
0x0000 0x0323: pmt_pid 0x002b T -- Trackside (running, scrambled)
>>> tune to: 682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0030
WARNING: filter timeout pid 0x002d
WARNING: filter timeout pid 0x0029
WARNING: filter timeout pid 0x002f
WARNING: filter timeout pid 0x002a

-------------->>  What does this pid timeout mean??



I end up with channels:

Living 
Channel:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1309:1409:809
UKTV:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1310:1410:810
The Cheese:674000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:1420:820
[0385]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:901
[0386]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:902
[0387]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1303:1403:903
[0388]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:904
[0389]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:905


-------------->>  Has picked up the pids, but missing information??



When I try and czap them, I get:

[root@freddy scan]# czap -c ~/.channels.conf.tmp TV3
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.channels.conf.tmp'
  2 TV3:578000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:1303:1403:1003
  2 TV3: f 578000000, s 6900000, i 2, fec 9, qam 3, v 0x517, a 0x57b
status 00 | signal 9090 | snr b9b9 | ber 000fffff | unc 00000032 |
status 1f | signal e1e1 | snr f2f2 | ber 000005e8 | unc 000001ec | 
FE_HAS_LOCK
status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e1e1 | snr f3f3 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal e1e1 | snr f2f2 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK


but with 682Mhz, I get a lock but loads of errors:

[root@freddy scan]# czap -c ~/.channels.conf.tmp [0385]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.channels.conf.tmp'
  1 [0385]:682000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64:0:0:901
  1 [0385]: f 682000000, s 6900000, i 2, fec 9, qam 3, v 0, a 0
status 03 | signal 8f8f | snr b9b9 | ber 000fffff | unc 00000032 |
status 1f | signal cfcf | snr dcdc | ber 000005e8 | unc 000061a7 | 
FE_HAS_LOCK
status 1f | signal cfcf | snr dcdc | ber 000005e8 | unc 000061e8 | 
FE_HAS_LOCK
status 1f | signal cfcf | snr dede | ber 000006c0 | unc 00006234 | 
FE_HAS_LOCK
status 1f | signal cfcf | snr e0e0 | ber 000006a9 | unc 0000627f | 
FE_HAS_LOCK
status 1f | signal cfcf | snr dbdb | ber 000006a5 | unc 000062b6 | 
FE_HAS_LOCK



Any ideas??? 

------=_NextPart_000_0081_01C8EC49.E142FA90
Content-Type: application/octet-stream;
	name="c-1501_try2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="c-1501_try2.patch"

Signed-off-by: Sigmund Augdal <sigmund@snap.tv>
diff -r 6541620a09b7 linux/drivers/media/dvb/ttpci/budget-ci.c
--- a/linux/drivers/media/dvb/ttpci/budget-ci.c	Tue Jun 03 10:32:16 2008 =
-0300
+++ b/linux/drivers/media/dvb/ttpci/budget-ci.c	Thu Jun 05 11:02:28 2008 =
+0200
@@ -46,6 +46,8 @@
 #include "lnbp21.h"
 #include "bsbe1.h"
 #include "bsru6.h"
+#include "tda1002x.h"
+#include "tda827x.h"
=20
 /*
  * Regarding DEBIADDR_IR:
@@ -1069,6 +1071,16 @@
=20
=20
=20
+static struct tda10023_config tda10023_config =3D {
+	.demod_address =3D 0xc,
+	.invert =3D 0,
+	.xtal =3D 16000000,
+	.pll_m =3D 11,
+	.pll_p =3D 3,
+	.pll_n =3D 1,
+	.deltaf =3D 0xA511,
+};
+
 static void frontend_init(struct budget_ci *budget_ci)
 {
 	switch (budget_ci->budget.dev->pci->subsystem_device) {
@@ -1137,6 +1149,20 @@
 			}
 		}
=20
+		break;
+	case 0x101a: /* TT Budget-C-1501 (philips tda10023/philips tda8274A) =
*/
+		budget_ci->budget.dvb_frontend =3D
+			dvb_attach(tda10023_attach, &tda10023_config,
+				   &budget_ci->budget.i2c_adap, 0x48);
+		if (budget_ci->budget.dvb_frontend) {
+			if (dvb_attach(tda827x_attach,
+				       budget_ci->budget.dvb_frontend, 0x61,
+				       &budget_ci->budget.i2c_adap, NULL)
+			    =3D=3D NULL)
+				printk(KERN_ERR "%s: No tda827x found!\n",
+				       __func__);
+			break;
+		}
 		break;
 	}
=20
@@ -1226,6 +1252,7 @@
 MAKE_BUDGET_INFO(ttbt2, "TT-Budget/WinTV-NOVA-T	 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbtci, "TT-Budget-T-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
=20
 static struct pci_device_id pci_tbl[] =3D {
 	MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1234,6 +1261,7 @@
 	MAKE_EXTENSION_PCI(ttbt2, 0x13c2, 0x1011),
 	MAKE_EXTENSION_PCI(ttbtci, 0x13c2, 0x1012),
 	MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
+	MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101A),
 	{
 	 .vendor =3D 0,
 	 }

------=_NextPart_000_0081_01C8EC49.E142FA90
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_0081_01C8EC49.E142FA90--
