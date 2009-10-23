Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:59531 "HELO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751543AbZJWKw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 06:52:28 -0400
Received: by bwz26 with SMTP id 26so946675bwz.7
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 03:52:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 23 Oct 2009 12:52:31 +0200
Message-ID: <aaaa95950910230352x60a697efgcd31ad06246b66f@mail.gmail.com>
Subject: [PATCH] rounding signal strength indicator to nearest int
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=00032555a59a387eff0476980226
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00032555a59a387eff0476980226
Content-Type: text/plain; charset=ISO-8859-1

Attached patch changes v4l2-ctl -T so that the reported strength is
rounded to nearest integer rather than allways rounding down. With
this patch you get 100% when driver returns 0xffff.

Best regards

Sigmund Augdal

--00032555a59a387eff0476980226
Content-Type: application/octet-stream;
	name="v4l2-ctl-signal-strength-rounding.diff"
Content-Disposition: attachment;
	filename="v4l2-ctl-signal-strength-rounding.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g14toc5d0

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gKIyBVc2VyIHJvb3RAbG9jYWxob3N0CiMgRGF0ZSAxMjU2Mjk0
Nzg4IC0xMDgwMAojIE5vZGUgSUQgYWJiMTM4N2Q1NzI3ZGVkNjQyYmYyYjZjMmQ2ZTEyZTEzNzFj
MzYxNwojIFBhcmVudCAgYjMzNTI4NGQzMWEzZmE4NWYxYmIyYTk0OTU2MDQ1YmNiMmU3YzJjMgpS
b3VuZCBzaWduYWwgc3RyZW5ndGggdmFsdWUgdG8gbmVhcmVzdCBpbnRlZ2VyLCByYXRoZXIgdGhh
biByb3VuZGluZyBkb3duIHdoZW4gY29udmVydGluZyB0byBwZXJjZW50ClNpZ25lZC1vZmYtYnk6
IFNpZ211bmQgQXVnZGFsIDxzaWdtdW5kQHNuYXAudHY+CgpkaWZmIC1yIGIzMzUyODRkMzFhMyAt
ciBhYmIxMzg3ZDU3MjcgdjRsMi1hcHBzL3V0aWwvdjRsMi1jdGwuY3BwCi0tLSBhL3Y0bDItYXBw
cy91dGlsL3Y0bDItY3RsLmNwcAlXZWQgT2N0IDIxIDE2OjE0OjEyIDIwMDkgKzAzMDAKKysrIGIv
djRsMi1hcHBzL3V0aWwvdjRsMi1jdGwuY3BwCUZyaSBPY3QgMjMgMTM6NDY6MjggMjAwOSArMDMw
MApAQCAtMjkxMSw3ICsyOTExLDcgQEAgc2V0X3ZpZF9mbXRfZXJyb3I6CiAJCQllbHNlCiAJCQkJ
cHJpbnRmKCJcdEZyZXF1ZW5jeSByYW5nZSAgICAgIDogJS4xZiBNSHogLSAlLjFmIE1IelxuIiwK
IAkJCQkgICAgIHZ0LnJhbmdlbG93IC8gMTYuMCwgdnQucmFuZ2VoaWdoIC8gMTYuMCk7Ci0JCQlw
cmludGYoIlx0U2lnbmFsIHN0cmVuZ3RoL0FGQyAgOiAlZCUlLyVkXG4iLCAoaW50KSh2dC5zaWdu
YWwgLyA2NTUuMzUpLCB2dC5hZmMpOworCQkJcHJpbnRmKCJcdFNpZ25hbCBzdHJlbmd0aC9BRkMg
IDogJWQlJS8lZFxuIiwgKGludCkoKHZ0LnNpZ25hbCAvIDY1NS4zNSkrMC41KSwgdnQuYWZjKTsK
IAkJCXByaW50ZigiXHRDdXJyZW50IGF1ZGlvIG1vZGUgICA6ICVzXG4iLCBhdWRtb2RlMnModnQu
YXVkbW9kZSkpOwogCQkJcHJpbnRmKCJcdEF2YWlsYWJsZSBzdWJjaGFubmVsczogJXNcbiIsCiAJ
CQkJCXJ4c3ViY2hhbnMycyh2dC5yeHN1YmNoYW5zKS5jX3N0cigpKTsK
--00032555a59a387eff0476980226--
