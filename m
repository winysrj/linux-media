Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42824 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbZKWNTK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 08:19:10 -0500
Date: Mon, 23 Nov 2009 14:19:10 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: grafgrimm77@gmx.de
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
In-Reply-To: <alpine.LRH.2.00.0911231321270.14263@pub1.ifh.de>
Message-ID: <alpine.LRH.2.00.0911231418350.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz> <alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de> <20091121182514.61b39d23@x2.grafnetz> <alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de> <20091123120310.5b10c9cc@x2.grafnetz> <alpine.LRH.2.00.0911231206450.14263@pub1.ifh.de>
 <20091123123338.7273255b@x2.grafnetz> <alpine.LRH.2.00.0911231321270.14263@pub1.ifh.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579714831-1065765108-1258982350=:14263"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579714831-1065765108-1258982350=:14263
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Mon, 23 Nov 2009, Patrick Boettcher wrote:

> On Mon, 23 Nov 2009, grafgrimm77@gmx.de wrote:
>> [..]
>> ----- hello stupid I2C access ----
>> Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
>> Call Trace:
>> [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
>> [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
>> [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
>> [<ffffffffa00855c9>] ? dvb_pll_attach+0xa9/0x238 [dvb_pll]
>> [..]
>
> Voila.
>
> This is the access with makes the dvb-pll-driver not create the tuner driver.
>
> This is (I forgot the correct name) read-without-write-i2caccess. It is bad 
> handled by the dibusb-driver and it can destroy the eeprom on the USB side.
>
> Please try whether the attached patch fixes the whole situation for you.
>
> If so, please send back a line like this:
>
> Tested-by: Your name <email>

The patch attached.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
--579714831-1065765108-1258982350=:14263
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=dibusb-common-fix
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=dibusb-common-fix

ZGlmZiAtciA1MmRhNTdiNWU4MDAgbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZHZiLXVzYi9kaWJ1c2ItY29tbW9uLmMNCi0tLSBhL2xpbnV4L2RyaXZlcnMv
bWVkaWEvZHZiL2R2Yi11c2IvZGlidXNiLWNvbW1vbi5jCVRodSBOb3YgMTkg
MTc6MTU6MzcgMjAwOSArMDEwMA0KKysrIGIvbGludXgvZHJpdmVycy9tZWRp
YS9kdmIvZHZiLXVzYi9kaWJ1c2ItY29tbW9uLmMJTW9uIE5vdiAyMyAxMzoy
MDoxMCAyMDA5ICswMTAwDQpAQCAtMTQyLDggKzE0MiwxMyBAQA0KIAkJfSBl
bHNlIGlmICgobXNnW2ldLmZsYWdzICYgSTJDX01fUkQpID09IDApIHsNCiAJ
CQlpZiAoZGlidXNiX2kyY19tc2coZCwgbXNnW2ldLmFkZHIsIG1zZ1tpXS5i
dWYsbXNnW2ldLmxlbixOVUxMLDApIDwgMCkNCiAJCQkJYnJlYWs7DQotCQl9
IGVsc2UNCi0JCQlicmVhazsNCisJCX0gZWxzZSBpZiAobXNnW2ldLmFkZHIg
IT0gMHg1MCkgew0KKwkJCS8qIDB4NTAgaXMgdGhlIGFkZHJlc3Mgb2YgdGhl
IGVlcHJvbSAtIHdlIG5lZWQgdG8gcHJvdGVjdCBpdA0KKwkJCSAqIGZyb20g
ZGlidXNiJ3MgYmFkIGkyYyBpbXBsZW1lbnRhdGlvbjogcmVhZHMgd2l0aG91
dA0KKwkJCSAqIHdyaXRpbmcgdGhlIG9mZnNldCBiZWZvcmUgYXJlIGZvcmJp
ZGRlbiAqLw0KKwkJCWlmIChkaWJ1c2JfaTJjX21zZyhkLCBtc2dbaV0uYWRk
ciwgTlVMTCwgMCwgbXNnW2ldLmJ1ZiwgbXNnW2ldLmxlbikgPCAwKQ0KKwkJ
CQlicmVhazsNCisJCX0NCiAJfQ0KIA0KIAltdXRleF91bmxvY2soJmQtPmky
Y19tdXRleCk7DQo=

--579714831-1065765108-1258982350=:14263--
