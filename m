Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34256 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbBKCLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2015 21:11:33 -0500
Received: by iery20 with SMTP id y20so937744ier.1
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2015 18:11:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKoAQ7m8kBFSNbd=Sw8+1Ou5X4LDm9Yvmz+_SZOgYuaYCu=YSA@mail.gmail.com>
References: <CAKoAQ7m8kBFSNbd=Sw8+1Ou5X4LDm9Yvmz+_SZOgYuaYCu=YSA@mail.gmail.com>
Date: Tue, 10 Feb 2015 18:11:32 -0800
Message-ID: <CAKoAQ7nfi5LzVnQHKZtyiMDqpavFTkx9SMJaju3dGBiXjVz=bA@mail.gmail.com>
Subject: Fwd: [PATCH] Correction doco NV12/NV21M Chroma indexes
From: Miguel Casas-Sanchez <mcasas@chromium.org>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a1140e638b484f7050ec68587
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a1140e638b484f7050ec68587
Content-Type: text/plain; charset=UTF-8

In the linuxtv.org entry with the description of V4L2_PIX_FMT_NV{12,21}
@ http://linuxtv.org/downloads/v4l-dvb-apis/re30.html
it reads:

start +  0:Y'00 Y'01 Y'02 Y'03
start +  4:Y'10 Y'11 Y'12 Y'13
start +  8:Y'20 Y'21 Y'22 Y'23
start + 12:Y'30 Y'31 Y'32 Y'33
start + 16:Cb00 Cr00 Cb01 Cr01
start + 20:Cb10 Cr10 Cb11 Cr11

whereas the last line should read:

start + 20:Cb20 Cr20 Cb21 Cr21

--001a1140e638b484f7050ec68587
Content-Type: text/x-patch; charset=US-ASCII; name="V4L2_PIX_FMT_NV12M.correction.patch"
Content-Disposition: attachment;
	filename="V4L2_PIX_FMT_NV12M.correction.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i5tvk3fq0

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vRG9jQm9vay9tZWRpYS92NGwvcGl4Zm10LW52MTIu
eG1sIGIvRG9jdW1lbnRhdGlvbi9Eb2NCb29rL21lZGlhL3Y0bC9waXhmbXQtbnYxMi54bWwKaW5k
ZXggODRkZDRmZC4uMWRhMTJlMyAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9Eb2NCb29rL21l
ZGlhL3Y0bC9waXhmbXQtbnYxMi54bWwKKysrIGIvRG9jdW1lbnRhdGlvbi9Eb2NCb29rL21lZGlh
L3Y0bC9waXhmbXQtbnYxMi54bWwKQEAgLTc4LDEwICs3OCwxMCBAQCBwaXhlbCBpbWFnZTwvdGl0
bGU+CiAJCSAgICA8L3Jvdz4KIAkJICAgIDxyb3c+CiAJCSAgICAgIDxlbnRyeT5zdGFydCZuYnNw
OysmbmJzcDsyMDo8L2VudHJ5PgotCQkgICAgICA8ZW50cnk+Q2I8c3Vic2NyaXB0PjEwPC9zdWJz
Y3JpcHQ+PC9lbnRyeT4KLQkJICAgICAgPGVudHJ5PkNyPHN1YnNjcmlwdD4xMDwvc3Vic2NyaXB0
PjwvZW50cnk+Ci0JCSAgICAgIDxlbnRyeT5DYjxzdWJzY3JpcHQ+MTE8L3N1YnNjcmlwdD48L2Vu
dHJ5PgotCQkgICAgICA8ZW50cnk+Q3I8c3Vic2NyaXB0PjExPC9zdWJzY3JpcHQ+PC9lbnRyeT4K
KwkJICAgICAgPGVudHJ5PkNiPHN1YnNjcmlwdD4yMDwvc3Vic2NyaXB0PjwvZW50cnk+CisJCSAg
ICAgIDxlbnRyeT5DcjxzdWJzY3JpcHQ+MjA8L3N1YnNjcmlwdD48L2VudHJ5PgorCQkgICAgICA8
ZW50cnk+Q2I8c3Vic2NyaXB0PjIxPC9zdWJzY3JpcHQ+PC9lbnRyeT4KKwkJICAgICAgPGVudHJ5
PkNyPHN1YnNjcmlwdD4yMTwvc3Vic2NyaXB0PjwvZW50cnk+CiAJCSAgICA8L3Jvdz4KIAkJICA8
L3Rib2R5PgogCQk8L3Rncm91cD4K
--001a1140e638b484f7050ec68587--
