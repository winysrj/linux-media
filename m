Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:39140 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZEEI2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 04:28:17 -0400
Date: Tue, 5 May 2009 11:08:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] libv4l: spca508 UV inversion
Message-ID: <20090505110846.0780d860@free.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dS+IIQhHMFzEOLRPnK9RIW3"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/dS+IIQhHMFzEOLRPnK9RIW3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hello Hans,

People with a spca508 webcam report a color inversion in the images.
Here is a simple patch to fix this problem.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/dS+IIQhHMFzEOLRPnK9RIW3
Content-Type: application/octet-stream; name=patch.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=patch.pat

bGlidjRsOiBVViBjb2xvciBpbnZlcnNpb24gaW4gc3BjYTUwOCBkZWNvZGluZy4KClNpZ25lZC1v
ZmYtYnk6IEplYW4tRnJhbmNvaXMgTW9pbmUgPG1vaW5lamZAZnJlZS5mcj4KCmRpZmYgLXIgZTc4
OTRlYWNiY2E3IHY0bDItYXBwcy9saWJ2NGwvbGlidjRsY29udmVydC9saWJ2NGxjb252ZXJ0LmMK
LS0tIGEvdjRsMi1hcHBzL2xpYnY0bC9saWJ2NGxjb252ZXJ0L2xpYnY0bGNvbnZlcnQuYwlUdWUg
TWF5IDA1IDEwOjAxOjExIDIwMDkgKzAyMDAKKysrIGIvdjRsMi1hcHBzL2xpYnY0bC9saWJ2NGxj
b252ZXJ0L2xpYnY0bGNvbnZlcnQuYwlUdWUgTWF5IDA1IDExOjAzOjAyIDIwMDkgKzAyMDAKQEAg
LTU4NSw3ICs1ODUsNyBAQAogCSAgdjRsY29udmVydF9zcGNhNTA1X3RvX3l1djQyMChzcmMsIGQs
IHdpZHRoLCBoZWlnaHQsIHl2dSk7CiAJICBicmVhazsKIAljYXNlIFY0TDJfUElYX0ZNVF9TUENB
NTA4OgotCSAgdjRsY29udmVydF9zcGNhNTA4X3RvX3l1djQyMChzcmMsIGQsIHdpZHRoLCBoZWln
aHQsIHl2dSk7CisJICB2NGxjb252ZXJ0X3NwY2E1MDhfdG9feXV2NDIwKHNyYywgZCwgd2lkdGgs
IGhlaWdodCwgIXl2dSk7CiAJICBicmVhazsKIAljYXNlIFY0TDJfUElYX0ZNVF9TTjlDMjBYX0k0
MjA6CiAJICB2NGxjb252ZXJ0X3NuOWMyMHhfdG9feXV2NDIwKHNyYywgZCwgd2lkdGgsIGhlaWdo
dCwgeXZ1KTsK

--MP_/dS+IIQhHMFzEOLRPnK9RIW3--
