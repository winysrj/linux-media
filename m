Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56994 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2D3WGP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 18:06:15 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so2413765vbb.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 15:06:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbxa+WRJi_=Gyk-3La1dvFU4hKD7_Z2754GY2kdQuj9KmQ@mail.gmail.com>
References: <CAOcJUbxHCo7xfGHJZdeEgReJrpCriweSb9s9+-_NfSODLz_NPQ@mail.gmail.com>
	<4F9014CD.1040005@redhat.com>
	<CAHAyoxx+Thhj+EwFbtJcXbkzks=0x+RfdudKOgQT=pqJzePcLw@mail.gmail.com>
	<CAOcJUbyDNGoSdVV0WMVKavJm=RK6tanQTXS8AFzsHmHkGHOGUw@mail.gmail.com>
	<CAOcJUbzyqkfOOR72xDc14B139EECjM9f5yCmC=d0yYQU6Js4jw@mail.gmail.com>
	<CAOcJUbyT7LqdMwWcYa7XRhEvvSQGVftVQmiNBxw4xy+tv4412Q@mail.gmail.com>
	<CAOcJUbxLdZoo36Jkk1kMOhSfPcneupF6bRsMKOmuY6F5xZcErQ@mail.gmail.com>
	<CAOcJUbxt1uwMN-ip76t2F5k--vrtOUD0iTJSzDbsM9T2ajRPJw@mail.gmail.com>
	<CAOcJUbzc=0kQ57XgX7q-2abQAr6Z0cLEreJH6vDbJ_JsFuf6cw@mail.gmail.com>
	<CAOcJUbwCh9zwmY2_i-nqW1naYp_X9rOuW_BOKisrGUzPNNtzTg@mail.gmail.com>
	<CAOcJUbxa+WRJi_=Gyk-3La1dvFU4hKD7_Z2754GY2kdQuj9KmQ@mail.gmail.com>
Date: Mon, 30 Apr 2012 18:06:15 -0400
Message-ID: <CAOcJUbwfTivwMPLdFY=0xWyaOV70Fu77C1neXu6UjxquyQL6sQ@mail.gmail.com>
Subject: Re: ATSC-MH driver support for the Hauppauge WinTV Aero-m
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf307d0126ac2e5104beeca9af
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf307d0126ac2e5104beeca9af
Content-Type: text/plain; charset=ISO-8859-1



--20cf307d0126ac2e5104beeca9af
Content-Type: application/octet-stream;
	name="0009-dvb-usb-increase-MAX_NO_OF_FE_PER_ADAP-from-2-to-3.patch"
Content-Disposition: attachment;
	filename="0009-dvb-usb-increase-MAX_NO_OF_FE_PER_ADAP-from-2-to-3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1o2v02r1

RnJvbSA3YzcwYTM2ZWQ3YTUwZmJhNDQ0ZWI2ODE5ZjViZjkwZDNhMjNjZDRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIEtydWZreSA8bWtydWZreUBsaW51eHR2Lm9yZz4K
RGF0ZTogU3VuLCAyOSBKYW4gMjAxMiAxMzo1MzoxMiAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMDkv
MTBdIGR2Yi11c2I6IGluY3JlYXNlIE1BWF9OT19PRl9GRV9QRVJfQURBUCBmcm9tIDIgdG8gMwoK
U2lnbmVkLW9mZi1ieTogTWljaGFlbCBLcnVma3kgPG1rcnVma3lAbGludXh0di5vcmc+Ci0tLQog
ZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLmggfCAgICAyICstCiAxIGZpbGVzIGNo
YW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2IuaCBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11
c2IvZHZiLXVzYi5oCmluZGV4IDg2Y2ZhODYuLjk5Zjk0NDAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi5oCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11
c2IvZHZiLXVzYi5oCkBAIC0xNTcsNyArMTU3LDcgQEAgc3RydWN0IGR2Yl91c2JfYWRhcHRlcl9m
ZV9wcm9wZXJ0aWVzIHsKIAlpbnQgc2l6ZV9vZl9wcml2OwogfTsKIAotI2RlZmluZSBNQVhfTk9f
T0ZfRkVfUEVSX0FEQVAgMgorI2RlZmluZSBNQVhfTk9fT0ZfRkVfUEVSX0FEQVAgMwogc3RydWN0
IGR2Yl91c2JfYWRhcHRlcl9wcm9wZXJ0aWVzIHsKIAlpbnQgc2l6ZV9vZl9wcml2OwogCi0tIAox
LjcuNS40Cgo=
--20cf307d0126ac2e5104beeca9af--
