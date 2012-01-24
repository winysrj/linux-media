Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:35255 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753834Ab2AXQA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 11:00:28 -0500
Message-ID: <4F1ED598.9010406@gmx.de>
Date: Tue, 24 Jan 2012 17:00:24 +0100
From: Stefan Blochberger <Stefan.Blochberger@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: iMon stopped working
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My iMon LCD is not working anymore. The build module (imon.ko) has jaust
a size of ~6kb. the last working one had ~33kb. Can you pleas check,
what happned.

The faulty imon.ko is loading and also gives output on modinfo, but does
not give any error alt loading nor it is crealting die /dev/lcd.

this Output is taken from loading the dvb-s driver:
Jan 24 10:18:55 [kernel] Latest git patches (needed if you report a bug
to linux-media@vger.kernel.org):
Jan 24 10:18:55 [kernel] _59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge
branch 'v4l_for_linus' into staging/for_v3.4
Jan 24 10:18:55 [kernel] _72565224609a23a60d10fcdf42f87a2fa8f7b16d
[media] cxd2820r: sleep on DVB-T/T2 delivery system switch
Jan 24 10:18:55 [kernel] _46de20a78ae4b122b79fc02633e9a6c3d539ecad
[media] anysee: fix CI init

-- 
Gruß aus Gelnhausen
  Stefan Blochberger
_______________________________________________________

 Diese eMail kann mit Hilfe Ihrer elektronischen
 Signatur (PGP) auf Echtheit überprüft werden.
 ->> Internet-Seite: http://Stefan.Blochberger.de
_______________________________________________________

 Das Wurstfingerphänomen:
 Tippst Du zwei Tasten gleichzeitig, wird derjenige
 Buchstabe auf dem Monitor erscheinen,
 den Du nicht wolltest. [Murphy's Gesetz]
_______________________________________________________
Nr.: 40 von 195

