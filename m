Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KzMIx-0003QK-3C
	for linux-dvb@linuxtv.org; Mon, 10 Nov 2008 03:15:04 +0100
Received: by ey-out-2122.google.com with SMTP id 25so787329eya.17
	for <linux-dvb@linuxtv.org>; Sun, 09 Nov 2008 18:14:59 -0800 (PST)
Message-ID: <412bdbff0811091814q231e60a7y899b4410227c02ae@mail.gmail.com>
Date: Sun, 9 Nov 2008 21:14:59 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_60386_15070857.1226283299561"
Subject: [linux-dvb] [PATCH] [RFC] - Should s2api consider ATSC a legacy
	delivery system?
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

------=_Part_60386_15070857.1226283299561
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I tried out Christophe Thommeret's Kaffeine s2api changes, and ran
into a problem.  The u.vsb.modulation field was always zero, resulting
in lgdt330x indicating failures.

I traced through the new dvb_frontend code and it appears that this
field is set when we consider the delivery system to be "legacy".

The following patch causes the s2api to start working with ATSC
devices.  I'm not 100% sure this is the *right* fix, so I am
soliciting feedback on whether this was just an oversight.

I ran into this with both lgdt3303 and the s5h1411 based devices (so
it doesn't appear specific to any particular atsc demod), so unless
I'm crazy it seems like ATSC tuning through s2api is 100% broken.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_60386_15070857.1226283299561
Content-Type: text/x-diff; name=s2api_atsc_is_legacy.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fncharfq0
Content-Disposition: attachment; filename=s2api_atsc_is_legacy.patch

czJhcGkgLSBBVFNDIHNob3VsZCBiZSBjb25zaWRlcmVkIGEgbGVnYWN5IGRlbGl2ZXJ5IHN5c3Rl
bQoKRnJvbTogRGV2aW4gSGVpdG11ZWxsZXIgPGRldmluLmhlaXRtdWVsbGVyQGdtYWlsLmNvbT4K
CkFUU0Mgc2hvdWxkIGJlIGNvbnNpZGVyZWQgYSBsZWdhY3kgZGVsaXZlcnkgc3lzdGVtLCBvciBl
bHNlIGZpZWxkcyBzdWNoIGFzIApwLT51LnZzYi5tb2R1bGF0aW9uIGRvIG5vdCBnZXQgcG9wdWxh
dGVkIChyZXN1bHRpbmcgaW4gc2V0X2Zyb250ZW5kIGZhaWx1cmVzKQoKU2lnbmVkLW9mZi1ieTog
RGV2aW4gSGVpdG11ZWxsZXIgPGRldmluLmhlaXRtdWVsbGVyQGdtYWlsLmNvbT4KCmRpZmYgLXIg
NDY2MDRmNDdmY2ExIGxpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9mcm9udGVu
ZC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9mcm9udGVuZC5j
CUZyaSBOb3YgMDcgMTU6MjQ6MTggMjAwOCAtMDIwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9kdmItY29yZS9kdmJfZnJvbnRlbmQuYwlTdW4gTm92IDA5IDIxOjA0OjA1IDIwMDggLTA1
MDAKQEAgLTEwNjQsNyArMTA2NCw4IEBACiBpbnQgaXNfbGVnYWN5X2RlbGl2ZXJ5X3N5c3RlbShm
ZV9kZWxpdmVyeV9zeXN0ZW1fdCBzKQogewogCWlmKChzID09IFNZU19VTkRFRklORUQpIHx8IChz
ID09IFNZU19EVkJDX0FOTkVYX0FDKSB8fAotCQkocyA9PSBTWVNfRFZCQ19BTk5FWF9CKSB8fCAo
cyA9PSBTWVNfRFZCVCkgfHwgKHMgPT0gU1lTX0RWQlMpKQorCSAgIChzID09IFNZU19EVkJDX0FO
TkVYX0IpIHx8IChzID09IFNZU19EVkJUKSB8fCAocyA9PSBTWVNfRFZCUykgfHwKKwkgICAocyA9
PSBTWVNfQVRTQykpCiAJCXJldHVybiAxOwogCiAJcmV0dXJuIDA7Cg==
------=_Part_60386_15070857.1226283299561
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_60386_15070857.1226283299561--
