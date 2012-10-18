Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab2JRL3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 07:29:09 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so4085366bkc.19
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2012 04:29:08 -0700 (PDT)
Message-ID: <507FE801.7040102@googlemail.com>
Date: Thu, 18 Oct 2012 13:29:05 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Erik Andren <erik.andren@gmail.com>
Subject: [PATCH] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
Content-Type: multipart/mixed;
 boundary="------------090602030508090204020101"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090602030508090204020101
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've got an webcam upside down report for the following system:

     System Information
             Manufacturer: FUJITSU SIEMENS
             Product Name: AMILO Pi 2530
             Version:
             Serial Number:
             UUID: <removed>
             Wake-up Type: Power Switch
             SKU Number: Not Specified
             Family: Not Specified

     Base Board Information
             Manufacturer: FUJITSU SIEMENS
             Product Name: F42
             Version: 00030D0000000001
             Serial Number: <removed>

Currently an entry in the gspca/m5602 quirk table is missing. Please add 
the attached patch to the DVB kernel tree.

Thanks,
Gregor

--------------090602030508090204020101
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-Add-Fujitsu-Siemens-Amilo-Pi-2530-to-gspca-upside-do.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-Add-Fujitsu-Siemens-Amilo-Pi-2530-to-gspca-upside-do.pa";
 filename*1="tch"

RnJvbSA4MmI2ODQ3MTRmOWNlZTEwYzdiNWM0Yzc4NzNjZDhlNjVhOTM3YWEzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBHcmVnb3IgSmFzbnkgPGdqYXNueUBnb29nbGVtYWls
LmNvbT4KRGF0ZTogVGh1LCAxOCBPY3QgMjAxMiAxMzoyMDo0NyArMDIwMApTdWJqZWN0OiBb
UEFUQ0hdIEFkZCBGdWppdHN1IFNpZW1lbnMgQW1pbG8gUGkgMjUzMCB0byBnc3BjYSB1cHNp
ZGUgZG93biB0YWJsZS4KClRoZSBETUkgaW5mb3JtYXRpb24gZm9yIHRoaXMgc3lzdGVtOgoK
U3lzdGVtIEluZm9ybWF0aW9uCiAgICAgICAgTWFudWZhY3R1cmVyOiBGVUpJVFNVIFNJRU1F
TlMKICAgICAgICBQcm9kdWN0IE5hbWU6IEFNSUxPIFBpIDI1MzAKICAgICAgICBWZXJzaW9u
OgogICAgICAgIFNlcmlhbCBOdW1iZXI6CiAgICAgICAgVVVJRDogPHJlbW92ZWQ+CiAgICAg
ICAgV2FrZS11cCBUeXBlOiBQb3dlciBTd2l0Y2gKICAgICAgICBTS1UgTnVtYmVyOiBOb3Qg
U3BlY2lmaWVkCiAgICAgICAgRmFtaWx5OiBOb3QgU3BlY2lmaWVkCgpIYW5kbGUgMHgwMDAy
LCBETUkgdHlwZSAyLCA4IGJ5dGVzCkJhc2UgQm9hcmQgSW5mb3JtYXRpb24KICAgICAgICBN
YW51ZmFjdHVyZXI6IEZVSklUU1UgU0lFTUVOUwogICAgICAgIFByb2R1Y3QgTmFtZTogRjQy
CiAgICAgICAgVmVyc2lvbjogMDAwMzBEMDAwMDAwMDAwMQogICAgICAgIFNlcmlhbCBOdW1i
ZXI6IDxyZW1vdmVkPgoKU2lnbmVkLW9mZi1ieTogR3JlZ29yIEphc255IDxnamFzbnlAZ29v
Z2xlbWFpbC5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS91c2IvZ3NwY2EvbTU2MDIvbTU2MDJf
czVrNGFhLmMgfCAgICA2ICsrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS91c2IvZ3Nw
Y2EvbTU2MDIvbTU2MDJfczVrNGFhLmMgYi9kcml2ZXJzL21lZGlhL3VzYi9nc3BjYS9tNTYw
Mi9tNTYwMl9zNWs0YWEuYwppbmRleCBjYzhlYzNmLi5jOGUxNTcyIDEwMDY0NAotLS0gYS9k
cml2ZXJzL21lZGlhL3VzYi9nc3BjYS9tNTYwMi9tNTYwMl9zNWs0YWEuYworKysgYi9kcml2
ZXJzL21lZGlhL3VzYi9nc3BjYS9tNTYwMi9tNTYwMl9zNWs0YWEuYwpAQCAtNzQsNiArNzQs
MTIgQEAgc3RhdGljCiAJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIkFNSUxPIFBh
IDI1NDgiKQogCQl9CiAJfSwgeworCQkuaWRlbnQgPSAiRnVqaXRzdS1TaWVtZW5zIEFtaWxv
IFBpIDI1MzAiLAorCQkubWF0Y2hlcyA9IHsKKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRP
UiwgIkZVSklUU1UgU0lFTUVOUyIpLAorCQkJRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUs
ICJBTUlMTyBQaSAyNTMwIikKKwkJfQorCX0sIHsKIAkJLmlkZW50ID0gIk1TSSBHWDcwMCIs
CiAJCS5tYXRjaGVzID0gewogCQkJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiTWljcm8t
U3RhciBJbnRlcm5hdGlvbmFsIiksCi0tIAoxLjcuMi41Cgo=
--------------090602030508090204020101--
