Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tut.by ([195.137.160.40]:48868 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZA2QKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 11:10:17 -0500
Received: from [213.184.224.34] (account liplianin@tut.by HELO dynamic-vpdn-128-6-50.telecom.by)
  by speedy.tutby.com (CommuniGate Pro SMTP 5.1.12)
  with ESMTPA id 139795718 for linux-media@vger.kernel.org; Thu, 29 Jan 2009 18:07:39 +0200
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
Date: Thu, 29 Jan 2009 18:07:33 +0200
References: <497F7117.9000607@dark-green.com>
In-Reply-To: <497F7117.9000607@dark-green.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FRdgJHGoBgiuiVY"
Message-Id: <200901291807.33531.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_FRdgJHGoBgiuiVY
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 27 January 2009 22:39:51 gimli =CE=
=C1=D0=C9=D3=C1=CC(=C1):
> Hi,
>
> the following changesets breaks Tuning to Vertical Transponders :
>
> http://mercurial.intuxication.org/hg/s2-liplianin/rev/1ca67881d96a
> http://linuxtv.org/hg/v4l-dvb/rev/2cd7efb4cc19
>
> For example :
>
> DMAX;BetaDigital:12246:vC34M2O0S0:S19.2E:27500:511:512=3Ddeu:32:0:10101:1=
:109
>2:0
>
>
> cu
>
> Edgar ( gimli ) Hucek
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

More likely not polarization, but hi band may broken.
Anyway, please, try attached patch.

=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_FRdgJHGoBgiuiVY
Content-Type: text/x-diff;
  charset="koi8-r";
  name="10391.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="10391.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1233189531 -7200
# Node ID d09924ba6c75233d8212ef79076739d9400d79a8
# Parent  43dbc8ebb5a21c8991df5e5ead54b724c0dc18f4
HVR-4000 Test

diff -r 43dbc8ebb5a2 -r d09924ba6c75 linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Thu Jan 29 02:38:51 2009 +0200
@@ -861,6 +861,7 @@
 static int cx24116_set_tone(struct dvb_frontend *fe,
 	fe_sec_tone_mode_t tone)
 {
+	struct cx24116_state *state = fe->demodulator_priv;
 	struct cx24116_cmd cmd;
 	int ret;
 
@@ -870,8 +871,12 @@
 		return -EINVAL;
 	}
 
-	/* Wait for LNB ready */
-	ret = cx24116_wait_for_lnb(fe);
+	if (state->config->use_lnb_dc != 1)
+		ret = cx24116_set_voltage(fe, SEC_VOLTAGE_13);
+	else
+		/* Wait for LNB ready */
+		ret = cx24116_wait_for_lnb(fe);
+
 	if (ret != 0)
 		return ret;
 
diff -r 43dbc8ebb5a2 -r d09924ba6c75 linux/drivers/media/dvb/frontends/cx24116.h
--- a/linux/drivers/media/dvb/frontends/cx24116.h	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/cx24116.h	Thu Jan 29 02:38:51 2009 +0200
@@ -35,6 +35,9 @@
 
 	/* Need to set MPEG parameters */
 	u8 mpg_clk_pos_pol:0x02;
+
+	/* Need to set LNB power control */
+	u8 use_lnb_dc;
 };
 
 #if defined(CONFIG_DVB_CX24116) || \
diff -r 43dbc8ebb5a2 -r d09924ba6c75 linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	Thu Jan 29 02:38:51 2009 +0200
@@ -334,6 +334,7 @@
 
 static struct cx24116_config dvbworld_cx24116_config = {
 	.demod_address = 0x05,
+	.use_lnb_dc = 1,
 };
 
 static int dvb_register(struct cx23885_tsport *port)

--Boundary-00=_FRdgJHGoBgiuiVY--
