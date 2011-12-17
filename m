Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52567 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1LQAuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 19:50:51 -0500
Received: by eaaj10 with SMTP id j10so3357150eaa.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 16:50:49 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Dec 2011 01:50:49 +0100
Message-ID: <CAEN_-SAJ0hYgd+DdW+2c8J8YO1mwgB6AO+N8vvUs+0xXxQd28g@mail.gmail.com>
Subject: Fix possible null dereference for Leadtek DTV 3200H
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175cdc7cd6491f04b43f1b79
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175cdc7cd6491f04b43f1b79
Content-Type: text/plain; charset=ISO-8859-1

Fix possible null dereference for Leadtek DTV 3200H XC4000 tuner when
no firmware file available.

--0015175cdc7cd6491f04b43f1b79
Content-Type: text/x-patch; charset=UTF-8;
	name="0003-Fix-possible-null-dereference-for-Leadtek-DTV-3200H-.patch"
Content-Disposition: attachment;
	filename="0003-Fix-possible-null-dereference-for-Leadtek-DTV-3200H-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw9wuzr70

RnJvbSAxNzM5OTFhOTc5ZjVmNzVkYmJhZjM4ZjFiMDUzZDUwMDQzYTQwNzI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaXJvc2xhdiBTbHVnZcWIIDx0aHVuZGVyLm1AZW1haWwuY3o+
CkRhdGU6IFN1biwgMTEgRGVjIDIwMTEgMjI6NTc6NTggKzAxMDAKU3ViamVjdDogW1BBVENIXSBG
aXggcG9zc2libGUgbnVsbCBkZXJlZmVyZW5jZSBmb3IgTGVhZHRlayBEVFYgMzIwMEggWEM0MDAw
IHR1bmVyIHdoZW4gbm8gZmlybXdhcmUgZmlsZSBhdmFpbGFibGUuCgotLS0KIGRyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWR2Yi5jIHwgICAgNSArKysrKwogMSBmaWxlcyBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVv
L2N4MjM4ODUvY3gyMzg4NS1kdmIuYwppbmRleCBiY2I0NWJlLi5mMDQ4MmIyIDEwMDY0NAotLS0g
YS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYworKysgYi9kcml2ZXJz
L21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwpAQCAtOTQwLDYgKzk0MCwxMSBAQCBz
dGF0aWMgaW50IGR2Yl9yZWdpc3RlcihzdHJ1Y3QgY3gyMzg4NV90c3BvcnQgKnBvcnQpCiAKIAkJ
CWZlID0gZHZiX2F0dGFjaCh4YzQwMDBfYXR0YWNoLCBmZTAtPmR2Yi5mcm9udGVuZCwKIAkJCQkJ
JmRldi0+aTJjX2J1c1sxXS5pMmNfYWRhcCwgJmNmZyk7CisJCQlpZiAoIWZlKSB7CisJCQkJcHJp
bnRrKEtFUk5fRVJSICIlcy8yOiB4YzQwMDAgYXR0YWNoIGZhaWxlZFxuIiwKKwkJCQkgICAgICAg
ZGV2LT5uYW1lKTsKKwkJCQlnb3RvIGZyb250ZW5kX2RldGFjaDsKKwkJCX0KIAkJfQogCQlicmVh
azsKIAljYXNlIENYMjM4ODVfQk9BUkRfVEJTXzY5MjA6Ci0tIAoxLjcuMi4zCgo=
--0015175cdc7cd6491f04b43f1b79--
