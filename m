Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tut.by ([195.137.160.40]:50369 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZA2TM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 14:12:29 -0500
From: "Igor M. Liplianin" <liplianin@tut.by>
To: gimli <gimli@dark-green.com>, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
Date: Thu, 29 Jan 2009 21:12:15 +0200
References: <497F7117.9000607@dark-green.com> <200901291807.33531.liplianin@tut.by> <4981F064.7070407@dark-green.com>
In-Reply-To: <4981F064.7070407@dark-green.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_P+fgJqCPW2qGxc+"
Message-Id: <200901292112.15587.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_P+fgJqCPW2qGxc+
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: base64
Content-Disposition: inline

9yDTz8/C3cXOyckgz9QgMjkgSmFudWFyeSAyMDA5IDIwOjA3OjMyIGdpbWxpIM7B0MnTwcwowSk6
Cj4gSGksCj4KPiB5b3VyIHBhdGNoIHNlZW1zIHRvIHdvcmsuCklmIGl0IHdvcmtzLCB0aGVuIEkg
cHJlcGFyZSBtb3JlIHNpbXBsZSBwYXRjaC4KCg==

--Boundary-00=_P+fgJqCPW2qGxc+
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

--Boundary-00=_P+fgJqCPW2qGxc+--
