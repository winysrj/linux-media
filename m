Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65327 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3AXt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 20:23:49 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so215682wib.10
        for <linux-media@vger.kernel.org>; Thu, 29 May 2014 17:23:48 -0700 (PDT)
Date: Fri, 30 May 2014 01:23:45 +0100
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, oliver@schinagl.nl
Subject: Re: [PATCH 00/12] dvbv5 scan tables for Brazil
Message-ID: <20140530002345.GA12450@lambda.dereenigne.org>
References: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <1401209432-7327-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

On Tue, 27 May 2014 13:50:20 -0300, Mauro Carvalho Chehab wrote:
> This patch series add the DTV scan tables for Brazilian ISDB-T
> and for the Brazilian Countys that have already digital TV.

Thanks for the DVBv5 scan files. I had the attached draft patch sitting
in my tree. I don't think it is ready to be committed yet, but probably
worth sending now to discuss.

How do we want to manage the migration from DVBv3 to DVBv5:
1) point in time migration from DVBv3 to DVBv5?
2) maintain both until DVBv5 is in widespread use?

On a side note, I found a bug in dvb-format-convert; it cannot parse
DVB-T2 DVBv3 scan files.

Jon

--XsQoSWH+UP9D9v3l
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-Makefile-to-convert-DVBv3-files-to-DVBv5.patch"
Content-Transfer-Encoding: quoted-printable

=46rom fdcabb0802a4a40e257d54dbd5e5eba59b9820f7 Mon Sep 17 00:00:00 2001
=46rom: Jonathan McCrohan <jmccrohan@gmail.com>
Date: Fri, 30 May 2014 01:14:42 +0100
Subject: [PATCH] Add Makefile to convert DVBv3 files to DVBv5

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 Makefile | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Makefile

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..fac40e7
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,25 @@
+# Makefile for dtv-scan-tables (26 May 2014)
+# Copyright 2014 Jonathan McCrohan <jmccrohan@gmail.com>
+
+# The vast majority of the DVB scan files contained in this repository
+# are DVBv3 scan files. This format has been deprecated in favor of the
+# DVBv5 scan format.
+#
+# Use this makefile to convert the existing DVBv3 scan files to DVBv5
+# scan files until such time as DVBv5 scan format is in widespread use.
+#
+# Requires dvb-format-convert from v4l-utils.
+
+MKDIR =3D mkdir -p
+DVBFORMATCONVERT =3D dvb-format-convert
+
+DVBFORMATCONVERT_CHANNEL_DVBV5 =3D -ICHANNEL -ODVBV5
+
+DVBV3DIRS =3D atsc dvb-c dvb-s dvb-t
+DVBV3CHANNELFILES =3D $(foreach dir,$(DVBV3DIRS),$(wildcard $(dir)/*))
+
+DVBV5OUTPUTDIR =3D dvbv5
+
+makedvbv5:
+	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV5OUTPUTDIR)/$(var);)
+	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVE=
RT_CHANNEL_DVBV5) $(var) $(DVBV5OUTPUTDIR)/$(var);)
--=20
2.0.0.rc2


--XsQoSWH+UP9D9v3l--

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Signed by Jonathan McCrohan

iQIcBAABCAAGBQJTh8+RAAoJEBVu7Ac3rTKWFA0QAJvJiYliZB8BCcNBTCLoc81k
l9HXfVyszRmeucF+5M2uhx/ry6ZHH35/t5GTRobUeivWGOpwQlKI9Bbx48DbMiZ1
yXCeIGwlj4PhsHTOi25V8/TXEX9hUt8TW+n6QilfcSPHp9OesQPlLjmTNfwfmrUo
POotchPucn1cXFTFiVRjtgpZz1QwMDZLAKYf4UiwB0ClHG6+bVbz2XQ1z4TJZ9VJ
JNOqWpDSWZq9esmRNsagTX2Q9liOFB6CoXtSiDtXzFYUfmgaFQTO6L3YqosXCqq2
UQ2+FQxOSLdXILH9w7Pi82LFDQHZvLoTxuMRd6Pzn7RK2av8egTgfFEgbUY2FdLA
xoZvvaj2PsAFJgSQn6z1mD8KIRLsHjbtB0eItR9lGhzW3Y6mwzt+prbK8FQH2eqs
5FBUK99OotdjT1pJZ0BzUyztiSDQ+1h92g+nbbhaXkvqqfQrGZiu2aNi3VTW/yuW
wDlWJzEvNpVryWufmzycwatCkBviAuSuNV8AveDHmCq/wTlao2/A2nbveYDuwPP/
SgeKm0CetifD1mh/td1c+QgDeRiDtbmyl8r4kQNrhGzH2X44B3W1+WdnFqdkV6Ww
1864f/+0eR/V3kdVfx9rKAeHPMuFxl5HR2zDuoQXJyYiHoYQxP3muhmKcinjWNHg
GT2AhSRUVgqTPCvUJVpt
=AAXq
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
