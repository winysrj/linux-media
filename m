Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36080 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2AHXbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 18:31:35 -0500
Received: by vbbfc26 with SMTP id fc26so2284903vbb.19
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2012 15:31:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 00:31:35 +0100
Message-ID: <CADotOjP-3+CCN+mOaEHFiUUfsyr33zNW0Av8uXSzz0CF0BX1SA@mail.gmail.com>
Subject: [PATCH] v4l-utils: ir-keytable file parsing errors
From: Chris Pockele <chris.pockele.f1@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf307d06cec88c8f04b60cae62
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf307d06cec88c8f04b60cae62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

While configuring a remote control I noticed that the ir-keytable
utility would throw the message "Invalid parameter on line 1" if the
first line following the "table ... type: ..." line is a comment.
Also, if a configuration line is invalid, the line number indication
of the error message is sometimes incorrect, because the comments
before it are not counted.
This happens because of the "continue" statement when processing
comments (or the table/type line), thus skipping the line counter
increase at the end of the loop.  The included patch fixes both
problems by making sure the counter is always increased.
The parse_cfgfile() function had a similar problem.

For the "table ... type: ..." configuration line at the beginning of a
keyfile, I suggest replacing the marker character by something
different from '#'.  That way, it can be commented out by the user,
and it doesn't have to be on the first line.  However, that's
something for another patch and probably up to someone else to decide
:-).  If desirable, I can generate such a patch.

Regards,
Chris

Signed-off-by: Chris Pockel=E9 <chris.pockele.f1@gmail.com>

--20cf307d06cec88c8f04b60cae62
Content-Type: text/x-diff; charset=US-ASCII; name="fix_keyfile_lineno.patch"
Content-Disposition: attachment; filename="fix_keyfile_lineno.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx6ipoit0

ZGlmZiAtcnUgYS91dGlscy9rZXl0YWJsZS9rZXl0YWJsZS5jIGIvdXRpbHMva2V5dGFibGUva2V5
dGFibGUuYwotLS0gYS91dGlscy9rZXl0YWJsZS9rZXl0YWJsZS5jCTIwMTItMDEtMDggMTU6MjI6
MTUuMDAwMDAwMDAwICswMTAwCisrKyBiL3V0aWxzL2tleXRhYmxlL2tleXRhYmxlLmMJMjAxMi0w
MS0wOCAyMToxNzoxMS4yMTU4MjYwMTIgKzAxMDAKQEAgLTIwMSw5ICsyMDEsMTEgQEAKIAogCXdo
aWxlIChmZ2V0cyhzLCBzaXplb2YocyksIGZpbikpIHsKIAkJY2hhciAqcCA9IHM7CisKKwkJbGlu
ZSsrOwogCQl3aGlsZSAoKnAgPT0gJyAnIHx8ICpwID09ICdcdCcpCiAJCQlwKys7Ci0JCWlmICgh
bGluZSAmJiBwWzBdID09ICcjJykgeworCQlpZiAobGluZT09MSAmJiBwWzBdID09ICcjJykgewog
CQkJcCsrOwogCQkJcCA9IHN0cnRvayhwLCAiXG5cdCA9OiIpOwogCQkJZG8gewpAQCAtMjc4LDcg
KzI4MCw2IEBACiAJCQlyZXR1cm4gRU5PTUVNOwogCQl9CiAJCW5leHRrZXkgPSBuZXh0a2V5LT5u
ZXh0OwotCQlsaW5lKys7CiAJfQogCWZjbG9zZShmaW4pOwogCkBAIC0yODYsNyArMjg3LDcgQEAK
IAogZXJyX2VpbnZhbDoKIAlmcHJpbnRmKHN0ZGVyciwgIkludmFsaWQgcGFyYW1ldGVyIG9uIGxp
bmUgJWQgb2YgJXNcbiIsCi0JCWxpbmUgKyAxLCBmbmFtZSk7CisJCWxpbmUsIGZuYW1lKTsKIAly
ZXR1cm4gRUlOVkFMOwogCiB9CkBAIC0zMTEsNiArMzEyLDggQEAKIAogCXdoaWxlIChmZ2V0cyhz
LCBzaXplb2YocyksIGZpbikpIHsKIAkJY2hhciAqcCA9IHM7CisKKwkJbGluZSsrOwogCQl3aGls
ZSAoKnAgPT0gJyAnIHx8ICpwID09ICdcdCcpCiAJCQlwKys7CiAKQEAgLTM0OCw3ICszNTEsNiBA
QAogCQkJcmV0dXJuIEVOT01FTTsKIAkJfQogCQluZXh0Y2ZnID0gbmV4dGNmZy0+bmV4dDsKLQkJ
bGluZSsrOwogCX0KIAlmY2xvc2UoZmluKTsKIApAQCAtMzU2LDcgKzM1OCw3IEBACiAKIGVycl9l
aW52YWw6CiAJZnByaW50ZihzdGRlcnIsICJJbnZhbGlkIHBhcmFtZXRlciBvbiBsaW5lICVkIG9m
ICVzXG4iLAotCQlsaW5lICsgMSwgZm5hbWUpOworCQlsaW5lLCBmbmFtZSk7CiAJcmV0dXJuIEVJ
TlZBTDsKIAogfQo=
--20cf307d06cec88c8f04b60cae62--
