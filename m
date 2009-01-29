Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tut.by ([195.137.160.40]:37616 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759846AbZA2Xme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 18:42:34 -0500
From: "Igor M. Liplianin" <liplianin@tut.by>
To: Mika Laitio <lamikr@pilppa.org>, gimli <gimli@dark-green.com>,
	linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
Date: Fri, 30 Jan 2009 00:09:37 +0200
References: <497F7117.9000607@dark-green.com> <200901292242.55298.liplianin@tut.by> <Pine.LNX.4.64.0901292335140.17122@shogun.pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0901292335140.17122@shogun.pilppa.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hkigJnN1UFyy0t7"
Message-Id: <200901300009.37576.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_hkigJnN1UFyy0t7
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 29 January 2009 23:36:43 Mika Laitio=
 =CE=C1=D0=C9=D3=C1=CC(=C1):
> >> Edgar (gimli) Hucek
> >
> > Does simple patch work ?
> > I need your Acked-by :)
>
> Hi, I have only saw one version of your patch in mailing list,
> did you send the simpler version somewhere?
>
> Mika
Sorry, send it to Edgar only.
But it is unintentionally.

=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_hkigJnN1UFyy0t7
Content-Type: text/x-diff;
  charset="koi8-r";
  name="hvr4000.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="hvr4000.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1233253267 -7200
# Node ID 3542d1c1e03add577ce85175327701c552d14856
# Parent  4086371cea7b7f8b461e1a77513274aa43583c8c
Bug fix: Restore HVR-4000 tuning.

From: Igor M. Liplianin <liplianin@me.by>

Some cards uses cx24116 LNB_DC pin for LNB power control,
some not uses, some uses it different way, like HVR-4000.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 4086371cea7b -r 3542d1c1e03a linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Sat Jan 17 17:23:31 2009 +0200
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Thu Jan 29 20:21:07 2009 +0200
@@ -1184,7 +1184,12 @@
 	if (ret != 0)
 		return ret;
 
-	return cx24116_diseqc_init(fe);
+	ret = cx24116_diseqc_init(fe);
+	if (ret != 0)
+		return ret;
+
+	/* HVR-4000 needs this */
+	return cx24116_set_voltage(fe, SEC_VOLTAGE_13);
 }
 
 /*

--Boundary-00=_hkigJnN1UFyy0t7--
