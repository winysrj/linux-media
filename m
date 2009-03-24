Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:28154 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZCXXNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:13:48 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2789132ywb.1
        for <linux-media@vger.kernel.org>; Tue, 24 Mar 2009 16:13:46 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 17:13:42 -0600
Message-ID: <2df568dc0903241613h3d1d8217y5bf8dff5d69de690@mail.gmail.com>
Subject: saa7134 streaming broken?
From: Gordon Smith <spider.karma+video4linux-list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SGVsbG8gLQoKSSBoYXZlIGEgUlREIFRlY2hub2xvZ2llcyBWRkc3MzUwIChzYWE3MTM0IGJhc2Vk
LCB0d28gY2hhbm5lbCwgbm8gdHVuZXIpLgoKSSdkIGxpa2UgdG8gc3RyZWFtIHRoZSBjb21wcmVz
c2VkIGRhdGEuCgpJL08gcmVhZCB3b3JrczoKwqDCoMKgIHY0bDItYXBwcy90ZXN0L2NhcHR1cmUt
ZXhhbXBsZSAtLWRldmljZSAvZGV2L3ZpZGVvMiAtLXJlYWQKCmJ1dCBzdHJlYW1pbmcgZG9lcyBu
b3Q6CgokIHY0bDItYXBwcy90ZXN0L2NhcHR1cmUtZXhhbXBsZSAtLWRldmljZSAvZGV2L3ZpZGVv
MiAtLW1tYXAKL2Rldi92aWRlbzIgZG9lcyBub3Qgc3VwcG9ydCBtZW1vcnkgbWFwcGluZzogSW52
YWxpZCBhcmd1bWVudAoKVGhpcyBpcyBlcnJvciBFSU5WQUwgZnJvbSBpb2N0bCggVklESU9DX1JF
UUJVRlMgKS4KClN0cmVhbWluZyBpcyBsaXN0ZWQgYXMgYSBjYXBhYmlsaXR5IG9mIHRoZSBkZXZp
Y2U6CgokIHY0bDItZGJnIC0tZGV2aWNlIC9kZXYvdmlkZW8yIC0taW5mbwpEcml2ZXIgaW5mbzoK
wqDCoMKgwqDCoMKgwqAgRHJpdmVyIG5hbWXCoMKgIDogc2FhNzEzNArCoMKgwqDCoMKgwqDCoCBD
YXJkIHR5cGXCoMKgwqDCoCA6IFJURCBFbWJlZGRlZCBUZWNobm9sb2dpZXMgVkZHNzMKwqDCoMKg
wqDCoMKgwqAgQnVzIGluZm/CoMKgwqDCoMKgIDogUENJOjAwMDA6MDI6MDguMArCoMKgwqDCoMKg
wqDCoCBEcml2ZXIgdmVyc2lvbjogNTI2CsKgwqDCoMKgwqDCoMKgIENhcGFiaWxpdGllc8KgIDog
MHgwNTAwMDAwMQrCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVmlkZW8gQ2FwdHVyZQrC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgUmVhZC9Xcml0ZQrCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgU3RyZWFtaW5nCgoKSXMgdGhlcmUgaG9wZSB0aGF0IHN0cmVhbWluZyBj
YW4gd29yaz8KClRoYW5rIHlvdSwKR29yZG9uCg==
