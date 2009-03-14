Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49692 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZCNMDN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 08:03:13 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9C882940138
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 13:03:05 +0100 (CET)
Received: from localhost (lns-bzn-30-82-253-176-172.adsl.proxad.net [82.253.176.172])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 5D8439400FE
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 13:03:02 +0100 (CET)
Date: Sat, 14 Mar 2009 12:59:23 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH] LED control
Message-ID: <20090314125923.4229cd93@free.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/jcjgULK0VCkQjI.dkm6Hrlr"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/jcjgULK0VCkQjI.dkm6Hrlr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Some webcams have one or many lights (LED). This patch makes them
controlable by the applications.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/jcjgULK0VCkQjI.dkm6Hrlr
Content-Type: application/octet-stream; name=led.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=led.pat

ZGlmZiAtciAxMjQ4NTA5ZDhiZWQgbGludXgvaW5jbHVkZS9saW51eC92aWRlb2RldjIuaAotLS0g
YS9saW51eC9pbmNsdWRlL2xpbnV4L3ZpZGVvZGV2Mi5oCVNhdCBNYXIgMTQgMDg6NDQ6NDIgMjAw
OSArMDEwMAorKysgYi9saW51eC9pbmNsdWRlL2xpbnV4L3ZpZGVvZGV2Mi5oCVNhdCBNYXIgMTQg
MTI6NTM6MDAgMjAwOSArMDEwMApAQCAtODg3LDkgKzg4NywxMCBAQAogCVY0TDJfQ09MT1JGWF9C
VwkJPSAxLAogCVY0TDJfQ09MT1JGWF9TRVBJQQk9IDIsCiB9OworI2RlZmluZSBWNEwyX0NJRF9M
RURTCQkJCShWNEwyX0NJRF9CQVNFKzMyKQogCiAvKiBsYXN0IENJRCArIDEgKi8KLSNkZWZpbmUg
VjRMMl9DSURfTEFTVFAxICAgICAgICAgICAgICAgICAgICAgICAgIChWNEwyX0NJRF9CQVNFKzMy
KQorI2RlZmluZSBWNEwyX0NJRF9MQVNUUDEJCQkJKFY0TDJfQ0lEX0JBU0UrMzMpCiAKIC8qICBN
UEVHLWNsYXNzIGNvbnRyb2wgSURzIGRlZmluZWQgYnkgVjRMMiAqLwogI2RlZmluZSBWNEwyX0NJ
RF9NUEVHX0JBU0UgCQkJKFY0TDJfQ1RSTF9DTEFTU19NUEVHIHwgMHg5MDApCmRpZmYgLXIgMTI0
ODUwOWQ4YmVkIHY0bDItc3BlYy9jb250cm9scy5zZ21sCi0tLSBhL3Y0bDItc3BlYy9jb250cm9s
cy5zZ21sCVNhdCBNYXIgMTQgMDg6NDQ6NDIgMjAwOSArMDEwMAorKysgYi92NGwyLXNwZWMvY29u
dHJvbHMuc2dtbAlTYXQgTWFyIDE0IDEyOjUzOjAwIDIwMDkgKzAxMDAKQEAgLTI4MSw2ICsyODEs
MTMgQEAKIDxjb25zdGFudD5WNEwyX0NPTE9SRlhfU0VQSUE8L2NvbnN0YW50PiAoMikuPC9lbnRy
eT4KIAkgIDwvcm93PgogCSAgPHJvdz4KKwkgICAgPGVudHJ5Pjxjb25zdGFudD5WNEwyX0NJRF9M
RURTPC9jb25zdGFudD48L2VudHJ5PgorCSAgICA8ZW50cnk+aW50ZWdlcjwvZW50cnk+CisJICAg
IDxlbnRyeT5Td2l0Y2ggb24gb3Igb2ZmIHRoZSBMRURzIG9yIGlsbHVtaW5hdG9ycyBvZiB0aGUg
ZGV2aWNlLgorSW4gdGhlIGNvbnRyb2wgdmFsdWUsIGVhY2ggTEVEIG1heSBiZSBjb2RlZCBpbiBv
bmUgYml0ICgwOiBvZmYsIDE6IG9uKSBvciBpbgorbWFueSBiaXRzIChsaWdodCBpbnRlbnNpdHkp
LjwvZW50cnk+CisJICA8L3Jvdz4KKwkgIDxyb3c+CiAJICAgIDxlbnRyeT48Y29uc3RhbnQ+VjRM
Ml9DSURfTEFTVFAxPC9jb25zdGFudD48L2VudHJ5PgogCSAgICA8ZW50cnk+PC9lbnRyeT4KIAkg
ICAgPGVudHJ5PkVuZCBvZiB0aGUgcHJlZGVmaW5lZCBjb250cm9sIElEcyAoY3VycmVudGx5Cg==

--MP_/jcjgULK0VCkQjI.dkm6Hrlr--
