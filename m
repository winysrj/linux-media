Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65378 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1AROmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 09:42:51 -0500
Received: by wyb28 with SMTP id 28so6190981wyb.19
        for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 06:42:50 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 18 Jan 2011 16:42:49 +0200
Message-ID: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>
Subject: [libdvben50221] [PATCH] Assign same resource_id in
 open_session_response when "resource non-existent"
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=00163649a31924a4f5049a1fea3c
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--00163649a31924a4f5049a1fea3c
Content-Type: text/plain; charset=ISO-8859-1

Attached a patch for a bug in the lookup_callback function, were in
case of a non-existent resource, the connected_resource_id is not
initialized and then used in the open_session_response call of the
session layer.

Tomer

--00163649a31924a4f5049a1fea3c
Content-Type: text/x-patch; charset=US-ASCII; name="en50221_stdcam_llci.diff"
Content-Disposition: attachment; filename="en50221_stdcam_llci.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gj2wya6n0

ZGlmZiAtciBkMzUwOWQ2ZTk0OTkgbGliL2xpYmR2YmVuNTAyMjEvZW41MDIyMV9zdGRjYW1fbGxj
aS5jCi0tLSBhL2xpYi9saWJkdmJlbjUwMjIxL2VuNTAyMjFfc3RkY2FtX2xsY2kuYwlTYXQgQXVn
IDA4IDE5OjE3OjIxIDIwMDkgKzAyMDAKKysrIGIvbGliL2xpYmR2YmVuNTAyMjEvZW41MDIyMV9z
dGRjYW1fbGxjaS5jCVR1ZSBKYW4gMTggMTQ6NTE6MzQgMjAxMSArMDIwMApAQCAtMzUxLDYgKzM1
MSwxMCBAQAogCQl9CiAJfQogCisJLyogSW4gY2FzZSB0aGUgcmVvdXNyY2UgZG9lcyBub3QgZXhp
c3QsIHJldHVybiB0aGUgc2FtZSBpZCBpbiB0aGUgcmVzcG9uc2UuCisJICAgU2VlIDcuMi42LjIg
Ki8KKwkqY29ubmVjdGVkX3Jlc291cmNlX2lkID0gcmVxdWVzdGVkX3Jlc291cmNlX2lkOworCiAJ
cmV0dXJuIC0xOwogfQogCg==
--00163649a31924a4f5049a1fea3c--
