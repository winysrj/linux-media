Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1EEKKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 06:10:20 -0400
Received: by iwn34 with SMTP id 34so1694512iwn.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 03:10:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 May 2011 12:10:19 +0200
Message-ID: <BANLkTinRqcFj5doua4r6d-vwPAym=JGvDw@mail.gmail.com>
Subject: omap3isp clock problems on Beagleboard xM.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: multipart/mixed; boundary=20cf301d446ca3185a04a28494d6
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--20cf301d446ca3185a04a28494d6
Content-Type: text/plain; charset=ISO-8859-1

Hi,
as you know I'm currently working on submitting mt9p031 driver to
mainline, testing it with my Beagleboard xM.
While I was trying to clean Guennadi's patches I ran into the attached
patch which changes a call to "omap3isp_get(isp);" into
"isp_enable_clocks(isp);".

I don't think this is clean since it would unbalance the number of
omap3isp_get() vs omap3isp_put() and we probably don't want that.
What seems clear is if we don't apply this patch the clock is not
actually enabled.

According to my debugging results "isp_disable_clocks()" is never
called, so, after the first call to "isp_enable_clocks()" there
shouldn't be any need to enable the clocks again.

Guennadi, do you know what is the cause of the problem?


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

--20cf301d446ca3185a04a28494d6
Content-Type: text/x-patch; charset=US-ASCII; name="isp.patch"
Content-Disposition: attachment; filename="isp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnbis4e80

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDNpc3AvaXNwLmMgYi9kcml2ZXJz
L21lZGlhL3ZpZGVvL29tYXAzaXNwL2lzcC5jCmluZGV4IDQ3MmE2OTMuLjZhNmVhODYgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDNpc3AvaXNwLmMKKysrIGIvZHJpdmVycy9t
ZWRpYS92aWRlby9vbWFwM2lzcC9pc3AuYwpAQCAtMTc3LDYgKzE3Nyw4IEBAIHN0YXRpYyB2b2lk
IGlzcF9kaXNhYmxlX2ludGVycnVwdHMoc3RydWN0IGlzcF9kZXZpY2UgKmlzcCkKICAgICAgICBp
c3BfcmVnX3dyaXRlbChpc3AsIDAsIE9NQVAzX0lTUF9JT01FTV9NQUlOLCBJU1BfSVJRMEVOQUJM
RSk7CiB9CiAKK3N0YXRpYyBpbnQgaXNwX2VuYWJsZV9jbG9ja3Moc3RydWN0IGlzcF9kZXZpY2Ug
KmlzcCk7CisKIC8qKgogICogaXNwX3NldF94Y2xrIC0gQ29uZmlndXJlcyB0aGUgc3BlY2lmaWVk
IGNhbV94Y2xrIHRvIHRoZSBkZXNpcmVkIGZyZXF1ZW5jeS4KICAqIEBpc3A6IE9NQVAzIElTUCBk
ZXZpY2UKQEAgLTIzOSw3ICsyNDEsNyBAQCBzdGF0aWMgdTMyIGlzcF9zZXRfeGNsayhzdHJ1Y3Qg
aXNwX2RldmljZSAqaXNwLCB1MzIgeGNsaywgdTggeGNsa3NlbCkKIAogICAgICAgIC8qIERvIHdl
IGdvIGZyb20gc3RhYmxlIHdoYXRldmVyIHRvIGNsb2NrPyAqLwogICAgICAgIGlmIChkaXZpc29y
ID49IDIgJiYgaXNwLT54Y2xrX2Rpdmlzb3JbeGNsa3NlbCAtIDFdIDwgMikKLSAgICAgICAgICAg
ICAgIG9tYXAzaXNwX2dldChpc3ApOworICAgICAgICAgICAgICAgaXNwX2VuYWJsZV9jbG9ja3Mo
aXNwKTsKICAgICAgICAvKiBTdG9wcGluZyB0aGUgY2xvY2suICovCiAgICAgICAgZWxzZSBpZiAo
ZGl2aXNvciA8IDIgJiYgaXNwLT54Y2xrX2Rpdmlzb3JbeGNsa3NlbCAtIDFdID49IDIpCiAgICAg
ICAgICAgICAgICBvbWFwM2lzcF9wdXQoaXNwKTsK
--20cf301d446ca3185a04a28494d6--
