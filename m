Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JcmrA-0007G1-8r
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 20:25:27 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1180763fge.25
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 12:24:44 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: v4l-dvb-maintainer@linuxtv.org
Date: Fri, 21 Mar 2008 20:24:17 +0100
MIME-Version: 1.0
Message-Id: <200803212024.17198.christophpfister@gmail.com>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_htA5H2I/0CyOo7G"
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

--Boundary-00=_htA5H2I/0CyOo7G
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Can somebody please pick up those patches (descriptions inlined)?

Thanks,

Christoph

--Boundary-00=_htA5H2I/0CyOo7G
Content-Type: text/x-diff;
  charset="us-ascii";
  name="fix-budget-av-cam.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-budget-av-cam.diff"

# HG changeset patch
# User Christoph Pfister <pfister@linuxtv.org>
# Date 1206124155 -3600
# Node ID f252381440c1f36ae6f3e0daded1451806d0bd8b
# Parent  1886a5ea2f84935a8356b926e0820db04e0adc84
Fix support for certain cams in buget-av
The current ci implementation doesn't accept 0xff when reading data bytes (address == 0),
thus breaks cams which report a buffer size of 0x--ff like my orion one.
Limit the 0xff check to the only register left, the status register.
Signed-off-by: Christoph Pfister <pfister@linuxtv.org>

diff -r 1886a5ea2f84 -r f252381440c1 linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:29:15 2008 +0100
@@ -178,7 +178,7 @@ static int ciintf_read_cam_control(struc
 	udelay(1);
 
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 3, 1, 0, 0);
-	if ((result == -ETIMEDOUT) || ((result == 0xff) && ((address & 3) < 2))) {
+	if ((result == -ETIMEDOUT) || ((result == 0xff) && ((address & 3) == 1))) {
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 3\n");
 		return -ETIMEDOUT;

--Boundary-00=_htA5H2I/0CyOo7G
Content-Type: text/x-diff;
  charset="us-ascii";
  name="fix-knc1-dvbs-ci.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-knc1-dvbs-ci.diff"

# HG changeset patch
# User Christoph Pfister <pfister@linuxtv.org>
# Date 1206125034 -3600
# Node ID dc4505c2491d301a28ec06a669b272b3e47168b1
# Parent  f252381440c1f36ae6f3e0daded1451806d0bd8b
Fix CI interface on (some) KNC1 DVBS cards
Quoting the commit introducing reinitialise_demod (3984 / by adq):
"These cards [KNC1 DVBT and DVBC] need special handling for CI - reinitialising the frontend
device when the CI module is reset."
Apparently my 1894:0010 also needs that fix, because once you initialise CI/CAM you lose lock.
Signed-off-by: Christoph Pfister <pfister@linuxtv.org>

diff -r f252381440c1 -r dc4505c2491d linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:29:15 2008 +0100
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Fri Mar 21 19:43:54 2008 +0100
@@ -943,6 +943,7 @@ static void frontend_init(struct budget_
 	case SUBID_DVBS_KNC1:
 	case SUBID_DVBS_KNC1_PLUS:
 	case SUBID_DVBS_EASYWATCH_1:
+		budget_av->reinitialise_demod = 1;
 		if (saa->pci->subsystem_vendor == 0x1894) {
 			fe = dvb_attach(stv0299_attach, &cinergy_1200s_1894_0010_config,
 					     &budget_av->budget.i2c_adap);

--Boundary-00=_htA5H2I/0CyOo7G
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_htA5H2I/0CyOo7G--
