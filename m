Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:48054 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752897Ab0ERHdA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 03:33:00 -0400
Received: from unknown (HELO email.aon.at) ([172.18.1.197])
          (envelope-sender <linux-media-maillinglist@mrq1.org>)
          by fallback43.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 18 May 2010 07:26:19 -0000
Received: from 80-123-47-89.adsl.highway.telekom.at (HELO mrq1.org) ([80.123.47.89])
          (envelope-sender <linux-media-maillinglist@mrq1.org>)
          by smarthub98.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 18 May 2010 07:26:17 -0000
Date: Tue, 18 May 2010 09:26:17 +0200
From: Hermann Gausterer <linux-media-maillinglist@mrq1.org>
To: linux-media@vger.kernel.org
Cc: Hermann Gausterer <linux-media-maillinglist@mrq1.org>
Subject: [RESEND][PATCH] Technotrend S2-3200 ships with a TT 1500 remote
Message-ID: <20100518072617.GA4375@mrq1.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The Technotrend Budget S2-3200 ships with the
Technotrend 1500 bundled remote which is already supported.
Just add the right Subsystem Device ID.

Signed-off-by: Hermann Gausterer <git-kernel-2010@mrq1.org>
---
 drivers/media/dvb/ttpci/budget-ci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/=
budget-ci.c
index b5c6813..4526d66 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -234,6 +234,7 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 		break;
 	case 0x1010:
 	case 0x1017:
+	case 0x1019:
 	case 0x101a:
 		/* for the Technotrend 1500 bundled remote */
 		ir_input_init(input_dev, &budget_ci->ir.state,
--=20
1.6.0.4


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFL8kEZAdCXZ1Xu7u4RAninAKCNSOa9/16hMQq8sH9NpVe1AXrwYACeMv7k
nUJHhF5pf3G1ZwQrjlg05W4=
=8rQ2
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
