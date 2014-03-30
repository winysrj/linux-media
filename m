Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32768 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaC3Rm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 13:42:56 -0400
Received: by mail-ig0-f175.google.com with SMTP id ur14so2673892igb.8
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 10:42:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 30 Mar 2014 11:42:56 -0600
Message-ID: <CAA9z4LaSOVb+-nbvrJmEdF+8AUWxER0LTF5gMj4Qg-2TJ_X93Q@mail.gmail.com>
Subject: em28xx_dvb.c errors
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c3055c126b8704f5d6770e
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a11c3055c126b8704f5d6770e
Content-Type: text/plain; charset=ISO-8859-1

I saw a previous email showing the error's but no patch, maybe there
was one but I didnt see it on my end.

It looks like a previous patch was applied wrong? not sure.

Chris

--001a11c3055c126b8704f5d6770e
Content-Type: application/octet-stream; name="em28xx_dvb.c.patch"
Content-Disposition: attachment; filename="em28xx_dvb.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htem86gk0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdXNiL2VtMjh4eC9lbTI4eHgtZHZiLmMgYi9kcml2
ZXJzL21lZGlhL3VzYi9lbTI4eHgvZW0yOHh4LWR2Yi5jCmluZGV4IDUxYzMzNTcuLjdlMTM4YjUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdXNiL2VtMjh4eC9lbTI4eHgtZHZiLmMKKysrIGIv
ZHJpdmVycy9tZWRpYS91c2IvZW0yOHh4L2VtMjh4eC1kdmIuYwpAQCAtMTYwNiw3ICsxNjA2LDYg
QEAgc3RhdGljIGludCBlbTI4eHhfZHZiX3N1c3BlbmQoc3RydWN0IGVtMjh4eCAqZGV2KQogCWVt
Mjh4eF9pbmZvKCJTdXNwZW5kaW5nIERWQiBleHRlbnNpb24iKTsKIAlpZiAoZGV2LT5kdmIpIHsK
IAkJc3RydWN0IGVtMjh4eF9kdmIgKmR2YiA9IGRldi0+ZHZiOwotCQlzdHJ1Y3QgaTJjX2NsaWVu
dCAqY2xpZW50ID0gZHZiLT5pMmNfY2xpZW50X3R1bmVyOwogCiAJCWlmIChkdmItPmZlWzBdKSB7
CiAJCQlyZXQgPSBkdmJfZnJvbnRlbmRfc3VzcGVuZChkdmItPmZlWzBdKTsKQEAgLTE2MzQsNiAr
MTYzMyw3IEBAIHN0YXRpYyBpbnQgZW0yOHh4X2R2Yl9yZXN1bWUoc3RydWN0IGVtMjh4eCAqZGV2
KQogCWVtMjh4eF9pbmZvKCJSZXN1bWluZyBEVkIgZXh0ZW5zaW9uIik7CiAJaWYgKGRldi0+ZHZi
KSB7CiAJCXN0cnVjdCBlbTI4eHhfZHZiICpkdmIgPSBkZXYtPmR2YjsKKwkJc3RydWN0IGkyY19j
bGllbnQgKmNsaWVudCA9IGR2Yi0+aTJjX2NsaWVudF90dW5lcjsKIAogCQlpZiAoZHZiLT5mZVsw
XSkgewogCQkJcmV0ID0gZHZiX2Zyb250ZW5kX3Jlc3VtZShkdmItPmZlWzBdKTsK
--001a11c3055c126b8704f5d6770e--
