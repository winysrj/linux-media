Return-path: <linux-media-owner@vger.kernel.org>
Received: from yavin4.bsod.eu ([188.164.131.106]:34494 "EHLO yavin4.bsod.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751357AbdBTLlF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 06:41:05 -0500
Received: from yavin4.bsod.eu (localhost [127.0.0.1])
        by yavin4.bsod.eu (Postfix) with ESMTP id 04079EDF8
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 11:33:15 +0000 (GMT)
Received: from yavin4.bsod.eu (unknown [192.168.1.3])
        by yavin4.bsod.eu (Postfix) with ESMTP id D7050EDCF
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 11:33:14 +0000 (GMT)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_0fefb4eea0e696322c9917b855fc6c07"
Date: Mon, 20 Feb 2017 12:33:14 +0100
From: Francesco <francesco@bsod.eu>
To: linux-media@vger.kernel.org
Subject: PATCH: v4l-utils/utils/ir-ctl/irc-ctl.c: fix musl build
Message-ID: <df17ce75ae92e047060082c98a00b50d@bsod.eu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=_0fefb4eea0e696322c9917b855fc6c07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Hi.
This is my fist attempt to send a patch for v4l-utils project.
I maintain v4l-utils package for Alpine Linux (www.alpinelinux.org), a 
musl-based distro.

This patch allows the build for v4l-utils by allowing alternatives to 
GLIBC assumptions.

Thanks for considering.

-- 
:: Francesco ::
Twit.....http://twitter.com/fcolista
E-Mail...francesco@bsod.eu
AboutMe..http://about.me/fcolista
GnuPG ID: C4FB9584
--=_0fefb4eea0e696322c9917b855fc6c07
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=0001-utils-ir-ctl-ir-ctl.c-fix-build-with-musl-library.patch
Content-Disposition: attachment;
 filename=0001-utils-ir-ctl-ir-ctl.c-fix-build-with-musl-library.patch;
 size=1204

RnJvbSA3MWYzOTljYjEzOTljMzVmZjRjZTE2NWMyY2VjMGZjZDMyNTZkMzRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGcmFuY2VzY28gQ29saXN0YSA8ZmNvbGlzdGFAaXRhLnd0YnRz
Lm5ldD4KRGF0ZTogTW9uLCAyMCBGZWIgMjAxNyAxMDoxNjowMSArMDEwMApTdWJqZWN0OiBbUEFU
Q0hdIHV0aWxzL2lyLWN0bC9pci1jdGwuYzogZml4IGJ1aWxkIHdpdGggbXVzbCBsaWJyYXJ5CgpU
aGlzIHBhdGNoIGFsbG93cyB0byBidWlsZCBjb3JyZWN0bHkgdjRsLXV0aWxzIG9uIG11c2wtYmFz
ZWQgZGlzdHJpYnV0aW9ucy4KSXQgcHJvdmlkZXMgYWx0ZXJuYXRpdmUgdG8gZ2xpYmMgYXNzdW1w
dGlvbnMuCi0tLQogdXRpbHMvaXItY3RsL2lyLWN0bC5jIHwgMTQgKysrKysrKysrKysrKysKIDEg
ZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdXRpbHMvaXItY3Rs
L2lyLWN0bC5jIGIvdXRpbHMvaXItY3RsL2lyLWN0bC5jCmluZGV4IGJjNThjZWUwLi4wYmQwZGRj
YyAxMDA2NDQKLS0tIGEvdXRpbHMvaXItY3RsL2lyLWN0bC5jCisrKyBiL3V0aWxzL2lyLWN0bC9p
ci1jdGwuYwpAQCAtNDIsNiArNDIsMjAgQEAKICMgZGVmaW5lIF8oc3RyaW5nKSBzdHJpbmcKICNl
bmRpZgogCisjaWYgIWRlZmluZWQoX19HTElCQ19fKQorCisvKiBFdmFsdWF0ZSBFWFBSRVNTSU9O
LCBhbmQgcmVwZWF0IGFzIGxvbmcgYXMgaXQgcmV0dXJucyAtMSB3aXRoIGBlcnJubycKKyAgIHNl
dCB0byBFSU5UUi4gICovCisKKyMgZGVmaW5lIFRFTVBfRkFJTFVSRV9SRVRSWShleHByZXNzaW9u
KSBcCisgIChfX2V4dGVuc2lvbl9fICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBcCisgICAgKHsgbG9uZyBpbnQgX19yZXN1bHQ7ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCisgICAg
ICAgZG8gX19yZXN1bHQgPSAobG9uZyBpbnQpIChleHByZXNzaW9uKTsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBcCisgICAgICAgd2hpbGUgKF9fcmVzdWx0ID09IC0xTCAmJiBlcnJu
byA9PSBFSU5UUik7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCisgICAgICAgX19yZXN1
bHQ7IH0pKQorCisjZW5kaWYKKwogIyBkZWZpbmUgTl8oc3RyaW5nKSBzdHJpbmcKIAogCi0tIAoy
LjExLjEKCg==
--=_0fefb4eea0e696322c9917b855fc6c07--
