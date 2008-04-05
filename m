Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1Ji8EE-0007aH-Id
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 15:14:43 +0200
Received: by fk-out-0910.google.com with SMTP id z22so757703fkz.1
	for <linux-dvb@linuxtv.org>; Sat, 05 Apr 2008 06:14:35 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sat, 5 Apr 2008 15:14:28 +0200
References: <200803212024.17198.christophpfister@gmail.com>
	<200803281820.54243.christophpfister@gmail.com>
	<200804040133.05892@orion.escape-edv.de>
In-Reply-To: <200804040133.05892@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0s39H9Ch/ops1h6"
Message-Id: <200804051514.28207.christophpfister@gmail.com>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

--Boundary-00=_0s39H9Ch/ops1h6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Freitag 04 April 2008 schrieb Oliver Endriss:
> Christoph Pfister wrote:
> > > > <<<fix-knc1-dvbs-ci.diff>>>
> > > >        case SUBID_DVBS_KNC1:
> > > >        case SUBID_DVBS_KNC1_PLUS:
> > > >        case SUBID_DVBS_EASYWATCH_1:
> > > >+               budget_av->reinitialise_demod = 1;
> > > >
> > > > Fix CI interface on (some) KNC1 DVBS cards
> > > > Quoting the commit introducing reinitialise_demod (3984 / by adq):
> > > > "These cards [KNC1 DVBT and DVBC] need special handling for CI -
> > > > reinitialising the frontend device when the CI module is reset."
> > > > Apparently my 1894:0010 also needs that fix, because once you
> > > > initialise CI/CAM you lose lock. Signed-off-by: Christoph Pfister
> > > > <pfister@linuxtv.org>
> > >
> > > Are you _sure_ that 'reinitialise_demod = 1' is required by all 3 card
> > > types, and does not hurt for SUBID_DVBS_KNC1_PLUS (1131:0011,
> > > 1894:0011) and SUBID_DVBS_EASYWATCH_1 (1894:001a)?
> >
> > Do you want me to limit reinitialise_demod to the one type of card I'm
> > using or is it ok for you this way?
>
> Yes, please. We should not add a quirk unless we have verified that it
> is really required. It is easier to add a hack than to remove it. ;-)

Ok.

> > (I'll repost a modified version of the first patch removing the 0xff
> > check altogether later today ...)
>
> OK. I'll commit your patches this weekend.

Here is the final version - thanks :)

Christoph

--Boundary-00=_0s39H9Ch/ops1h6
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-knc1-dvbs-ci.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-knc1-dvbs-ci.diff"

# HG changeset patch
# User Christoph Pfister <pfister@linuxtv.org>
# Date 1207400970 -7200
# Node ID 107968b904703af90f0d242b7759e460caf5e454
# Parent  5f32121d01cf58806df26a7a3e5be4f5e63576ac
Fix CI interface on (some) KNC1 DVBS cards
Quoting the commit introducing reinitialise_demod (3984 / by adq):
"These cards [KNC1 DVBT and DVBC] need special handling for CI - reinitialising the frontend
device when the CI module is reset."
Apparently my 1894:0010 also needs that fix, because once you initialise CI/CAM you lose lock.
Signed-off-by: Christoph Pfister <pfister@linuxtv.org>

diff -r 5f32121d01cf -r 107968b90470 linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Sat Apr 05 14:56:16 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Sat Apr 05 15:09:30 2008 +0200
@@ -941,6 +941,12 @@ static void frontend_init(struct budget_
 	switch (saa->pci->subsystem_device) {
 
 	case SUBID_DVBS_KNC1:
+		/*
+		 * maybe that setting is needed for other dvb-s cards as well,
+		 * but so far it has been only confirmed for this type
+		 */
+		budget_av->reinitialise_demod = 1;
+		/* fall through */
 	case SUBID_DVBS_KNC1_PLUS:
 	case SUBID_DVBS_EASYWATCH_1:
 		if (saa->pci->subsystem_vendor == 0x1894) {

--Boundary-00=_0s39H9Ch/ops1h6
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-budget-av-cam.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-budget-av-cam.diff"

# HG changeset patch
# User Christoph Pfister <pfister@linuxtv.org>
# Date 1207400176 -7200
# Node ID 5f32121d01cf58806df26a7a3e5be4f5e63576ac
# Parent  1abbd650fe07ab0ea0a18dfbd1213d431dd29ccd
Fix support for certain cams in buget-av
The current ci implementation doesn't accept 0xff when reading data bytes (address == 0),
thus breaks cams which report a buffer size of 0x--ff like my orion one.
Remove the 0xff check altogether, because validation is really the job of a higher layer.
Signed-off-by: Christoph Pfister <pfister@linuxtv.org>

diff -r 1abbd650fe07 -r 5f32121d01cf linux/drivers/media/dvb/ttpci/budget-av.c
--- a/linux/drivers/media/dvb/ttpci/budget-av.c	Thu Apr 03 17:08:04 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-av.c	Sat Apr 05 14:56:16 2008 +0200
@@ -178,7 +178,7 @@ static int ciintf_read_cam_control(struc
 	udelay(1);
 
 	result = ttpci_budget_debiread(&budget_av->budget, DEBICICAM, address & 3, 1, 0, 0);
-	if ((result == -ETIMEDOUT) || ((result == 0xff) && ((address & 3) < 2))) {
+	if (result == -ETIMEDOUT) {
 		ciintf_slot_shutdown(ca, slot);
 		printk(KERN_INFO "budget-av: cam ejected 3\n");
 		return -ETIMEDOUT;

--Boundary-00=_0s39H9Ch/ops1h6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_0s39H9Ch/ops1h6--
