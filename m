Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server30.ukservers.net ([217.10.138.207])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1Kc3j7-0002Xs-Ex
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 21:45:47 +0200
Received: from sy7608 (203-97-171-185.cable.telstraclear.net [203.97.171.185])
	by server30.ukservers.net (Postfix smtp) with SMTP id A787059C28B
	for <linux-dvb@linuxtv.org>; Sat,  6 Sep 2008 20:45:45 +0100 (BST)
Message-ID: <2ef701c91059$12152840$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 7 Sep 2008 07:27:36 +1200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_2E86_01C910BB.334EC9A0"
Subject: [linux-dvb] TT C-1501 patch and multiproto not compile
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

------=_NextPart_000_2E86_01C910BB.334EC9A0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Hi

I can't get the attached patch to compile with the current or with 7213 of 
the multi-proto branch.  I get the following errors.

Also, is the support for this TechnoTrend variant card going to be included 
as standard?

[root@freddy multiproto]# make
make -C /usr/src/development/multiproto/v4l
make[1]: Entering directory `/usr/src/development/multiproto/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25.14-108.fc9.x86_64/build
make -C /lib/modules/2.6.25.14-108.fc9.x86_64/build 
SUBDIRS=/usr/src/development/multiproto/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.25.14-108.fc9.x86_64'
  CC [M]  /usr/src/development/multiproto/v4l/budget-ci.o
/usr/src/development/multiproto/v4l/budget-ci.c:1342: error: variable 
'tda10023_config' has initializer but incomplete type
/usr/src/development/multiproto/v4l/budget-ci.c:1343: error: unknown field 
'demod_address' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1343: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1343: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1344: error: unknown field 
'invert' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1344: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1344: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1345: error: unknown field 
'xtal' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1345: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1345: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1346: error: unknown field 
'pll_m' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1346: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1346: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1347: error: unknown field 
'pll_p' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1347: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1347: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1348: error: unknown field 
'pll_n' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1348: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1348: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c:1349: error: unknown field 
'deltaf' specified in initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1349: warning: excess 
elements in struct initializer
/usr/src/development/multiproto/v4l/budget-ci.c:1349: warning: (near 
initialization for 'tda10023_config')
/usr/src/development/multiproto/v4l/budget-ci.c: In function 
'frontend_init':
/usr/src/development/multiproto/v4l/budget-ci.c:1422: warning: passing 
argument 1 of '__a' from incompatible pointer type
make[3]: *** [/usr/src/development/multiproto/v4l/budget-ci.o] Error 1
make[2]: *** [_module_/usr/src/development/multiproto/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.25.14-108.fc9.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/development/multiproto/v4l'
make: *** [all] Error 2
[root@freddy multiproto]#


Can anyone help?

Thanks

Simon

------=_NextPart_000_2E86_01C910BB.334EC9A0
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

------=_NextPart_000_2E86_01C910BB.334EC9A0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_2E86_01C910BB.334EC9A0--
