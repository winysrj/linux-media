Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59154 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZDXEfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 00:35:50 -0400
Received: by fxm2 with SMTP id 2so902699fxm.37
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2009 21:35:48 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Apr 2009 06:35:48 +0200
Message-ID: <faf98b150904232135l7593612dr68b7ed9cac9af385@mail.gmail.com>
Subject: [PATCH v2] Enabling of the Winfast TV2000 XP Global TV capture card
	remote control
From: Pieter Van Schaik <vansterpc@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5b8efe08a0b0468458763
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001636c5b8efe08a0b0468458763
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is for supporting the remote control of the Winfast TV2000
XP Global TV capture card. A case statement was added in order to
initialize the GPIO data structures as well as a case statement for
handling the keys correctly when pressed.

Thanks to Hermann for all his help

Regards
Pieter van Schaik

--001636c5b8efe08a0b0468458763
Content-Type: text/x-diff; charset=US-ASCII;
	name="cx88_support_the_remote_of_WINFAST_TV2000_XP_GLOBAL.patch"
Content-Disposition: attachment;
	filename="cx88_support_the_remote_of_WINFAST_TV2000_XP_GLOBAL.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftwe0z9e0

ZGlmZiAtciBhYzM4NjViMTY4ODYgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgt
aW5wdXQuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1pbnB1dC5j
CU1vbiBBcHIgMjAgMDg6NDc6MjIgMjAwOSAtMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2N4ODgvY3g4OC1pbnB1dC5jCU1vbiBBcHIgMjAgMTU6MjU6MTkgMjAwOSArMDIwMApA
QCAtOTIsNiArOTIsNyBAQAogCQlncGlvPShncGlvICYgMHg3ZmQpICsgKGF1eGdwaW8gJiAweGVm
KTsKIAkJYnJlYWs7CiAJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTAwMDoKKwljYXNlIENY
ODhfQk9BUkRfV0lORkFTVF9UVjIwMDBfWFBfR0xPQkFMOgogCQlncGlvID0gKGdwaW8gJiAweDZm
ZikgfCAoKGN4X3JlYWQoTU9fR1AxX0lPKSA8PCA4KSAmIDB4OTAwKTsKIAkJYXV4Z3BpbyA9IGdw
aW87CiAJCWJyZWFrOwpAQCAtMjQzLDYgKzI0NCw3IEBACiAJCWJyZWFrOwogCWNhc2UgQ1g4OF9C
T0FSRF9XSU5GQVNUMjAwMFhQX0VYUEVSVDoKIAljYXNlIENYODhfQk9BUkRfV0lORkFTVF9EVFYx
MDAwOgorCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX1RWMjAwMF9YUF9HTE9CQUw6CiAJCWlyX2Nv
ZGVzID0gaXJfY29kZXNfd2luZmFzdDsKIAkJaXItPmdwaW9fYWRkciA9IE1PX0dQMF9JTzsKIAkJ
aXItPm1hc2tfa2V5Y29kZSA9IDB4OGY4Owo=
--001636c5b8efe08a0b0468458763--
