Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:63802 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZEVUZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 16:25:59 -0400
Received: by fxm12 with SMTP id 12so87580fxm.37
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 13:25:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090522234201.4ee5cf47@bk.ru>
References: <53876.82.95.219.165.1243013567.squirrel@webmail.xs4all.nl>
	 <1a297b360905221048p5a7c548anbdef992b5a1a697d@mail.gmail.com>
	 <20090522234201.4ee5cf47@bk.ru>
Date: Sat, 23 May 2009 00:25:59 +0400
Message-ID: <1a297b360905221325r46432d02g8a97b1361e7958ac@mail.gmail.com>
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
From: Manu Abraham <abraham.manu@gmail.com>
To: Goga777 <goga777@bk.ru>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636c5aa41907d6b046a861139
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001636c5aa41907d6b046a861139
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Fri, May 22, 2009 at 11:42 PM, Goga777 <goga777@bk.ru> wrote:
>> >> What is the most stable DVB-S2 PCI card?
>
> I use hvr4000 without any problem.


Yes, no issues. Just that it is based a Generation 1 demodulator which
are limited in capabilities even for a Generation 1 demodulator. Also that the
statistics are just home made empirical values, rather than real ones.


>> > In short, the Hauppauge NOVA-HD-S2 is the one to buy. Yes, it's somewhat
>> > more expensive but it's the best DVB-S2 based PCI card concerning
>> > stability and usability with for example VDR.
>>
>>
>> Unfortunately, the Nova HD-S2 won't support any DVB-S2 stream with
>> symbol rates > 30 MSPS, also it supports only DVB-S2 NBC mode
>
> is there any dvb-s2 channels with sr > 30 msps ??



Of course, Generation 2 transmissions there are quite a lot of new things.
There are are some broadcasts on Intelsat 903 with 45 MSPS.
That's what i know for now, There could be more though.

There will be more of it, as broadcaster goes the 2nd generation path, as
well as broadcasters who don't want PC users to capture the stream on
Home PC's. (Till vendors come up with new hardware to do that)



>> of operation, being based on an older generation demodulator.
>
> what about quality indicators - snr and ber in your drivers ? do they work correctly ?

Yes, they do, currently it is on a dBm/10 scale.

(The statistics on the Nova HD are just crude just based on empirical
home tests,
not real statistics though.)

If you need statistics normalized to the current API (TT S2 1600),
attached is a
patch that fixes STR and SNR calculation and normalizes the value into the
0..0xFFFF range.

If you find any issues with the driver, please do report it over here.
Currently haven't
seen any issues by any of the testers.

--001636c5aa41907d6b046a861139
Content-Type: text/x-diff; charset=US-ASCII; name="stv090x-str_snr-fixes.diff"
Content-Disposition: attachment; filename="stv090x-str_snr-fixes.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fv1bzj480

ZGlmZiAtciBiMzAxZGVmMzUwOTggbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL3N0
djA5MHguYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvc3R2MDkweC5j
CVRodSBNYXkgMjEgMTc6MTg6MTUgMjAwOSArMDIwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlh
L2R2Yi9mcm9udGVuZHMvc3R2MDkweC5jCVRodSBNYXkgMjEgMjM6MjI6MjggMjAwOSArMDIwMApA
QCAtNDIyNywxNCArNDIyNywxMCBAQAogCWludCByZXMgPSAwOwogCWludCBtaW4gPSAwLCBtZWQ7
CiAKLQlpZiAodmFsIDwgdGFiW21pbl0ucmVhZCkKLQkJcmVzID0gdGFiW21pbl0ucmVhbDsKLQll
bHNlIGlmICh2YWwgPj0gdGFiW21heF0ucmVhZCkKLQkJcmVzID0gdGFiW21heF0ucmVhbDsKLQll
bHNlIHsKKwlpZiAoKHZhbCA+PSB0YWJbbWluXS5yZWFkICYmIHZhbCA8IHRhYlttYXhdLnJlYWQp
IHx8ICh2YWwgPj0gdGFiW21heF0ucmVhZCAmJiB2YWwgPCB0YWJbbWluXS5yZWFkKSkgewogCQl3
aGlsZSAoKG1heCAtIG1pbikgPiAxKSB7CiAJCQltZWQgPSAobWF4ICsgbWluKSAvIDI7Ci0JCQlp
ZiAodmFsID49IHRhYlttaW5dLnJlYWQgJiYgdmFsIDwgdGFiW21lZF0ucmVhZCkKKwkJCWlmICgo
dmFsID49IHRhYlttaW5dLnJlYWQgJiYgdmFsIDwgdGFiW21lZF0ucmVhZCkgfHwgKHZhbCA+PSB0
YWJbbWVkXS5yZWFkICYmIHZhbCA8IHRhYlttaW5dLnJlYWQpKQogCQkJCW1heCA9IG1lZDsKIAkJ
CWVsc2UKIAkJCQltaW4gPSBtZWQ7CkBAIC00MjQzLDYgKzQyMzksMTggQEAKIAkJICAgICAgICh0
YWJbbWF4XS5yZWFsIC0gdGFiW21pbl0ucmVhbCkgLwogCQkgICAgICAgKHRhYlttYXhdLnJlYWQg
LSB0YWJbbWluXS5yZWFkKSkgKwogCQkJdGFiW21pbl0ucmVhbDsKKwl9IGVsc2UgeworCQlpZiAo
dGFiW21pbl0ucmVhZCA8IHRhYlttYXhdLnJlYWQpIHsKKwkJCWlmICh2YWwgPCB0YWJbbWluXS5y
ZWFkKQorCQkJCXJlcyA9IHRhYlttaW5dLnJlYWw7CisJCQllbHNlIGlmICh2YWwgPj0gdGFiW21h
eF0ucmVhZCkKKwkJCQlyZXMgPSB0YWJbbWF4XS5yZWFsOworCQl9IGVsc2UgeworCQkJaWYgKHZh
bCA+PSB0YWJbbWluXS5yZWFkKQorCQkJCXJlcyA9IHRhYlttaW5dLnJlYWw7CisJCQllbHNlIGlm
ICh2YWwgPCB0YWJbbWF4XS5yZWFkKQorCQkJCXJlcyA9IHRhYlttYXhdLnJlYWw7CisJCX0KIAl9
CiAKIAlyZXR1cm4gcmVzOwpAQCAtNDI1MiwxNiArNDI2MCwyMSBAQAogewogCXN0cnVjdCBzdHYw
OTB4X3N0YXRlICpzdGF0ZSA9IGZlLT5kZW1vZHVsYXRvcl9wcml2OwogCXUzMiByZWc7Ci0JczMy
IGFnYzsKKwlzMzIgYWdjXzAsIGFnY18xLCBhZ2M7CisJczMyIHN0cjsKIAogCXJlZyA9IFNUVjA5
MHhfUkVBRF9ERU1PRChzdGF0ZSwgQUdDSVFJTjEpOwotCWFnYyA9IFNUVjA5MHhfR0VURklFTERf
UHgocmVnLCBBR0NJUV9WQUxVRV9GSUVMRCk7Ci0KLQkqc3RyZW5ndGggPSBzdHYwOTB4X3RhYmxl
X2xvb2t1cChzdHYwOTB4X3JmX3RhYiwgQVJSQVlfU0laRShzdHYwOTB4X3JmX3RhYikgLSAxLCBh
Z2MpOworCWFnY18xID0gU1RWMDkweF9HRVRGSUVMRF9QeChyZWcsIEFHQ0lRX1ZBTFVFX0ZJRUxE
KTsKKwlyZWcgPSBTVFYwOTB4X1JFQURfREVNT0Qoc3RhdGUsIEFHQ0lRSU4wKTsKKwlhZ2NfMCA9
IFNUVjA5MHhfR0VURklFTERfUHgocmVnLCBBR0NJUV9WQUxVRV9GSUVMRCk7CisJYWdjID0gTUFL
RVdPUkQxNihhZ2NfMSwgYWdjXzApOworCisJc3RyID0gc3R2MDkweF90YWJsZV9sb29rdXAoc3R2
MDkweF9yZl90YWIsIEFSUkFZX1NJWkUoc3R2MDkweF9yZl90YWIpIC0gMSwgYWdjKTsKIAlpZiAo
YWdjID4gc3R2MDkweF9yZl90YWJbMF0ucmVhZCkKLQkJKnN0cmVuZ3RoID0gNTsKKwkJc3RyID0g
MDsKIAllbHNlIGlmIChhZ2MgPCBzdHYwOTB4X3JmX3RhYltBUlJBWV9TSVpFKHN0djA5MHhfcmZf
dGFiKSAtIDFdLnJlYWQpCi0JCSpzdHJlbmd0aCA9IC0xMDA7CisJCXN0ciA9IC0xMDA7CisJKnN0
cmVuZ3RoID0gKHN0ciArIDEwMCkgKiAweEZGRkYgLyAxMDA7CiAKIAlyZXR1cm4gMDsKIH0KQEAg
LTQyNzIsNiArNDI4NSw3IEBACiAJdTMyIHJlZ18wLCByZWdfMSwgcmVnLCBpOwogCXMzMiB2YWxf
MCwgdmFsXzEsIHZhbCA9IDA7CiAJdTggbG9ja19mOworCXMzMiBzbnI7CiAKIAlzd2l0Y2ggKHN0
YXRlLT5kZWxzeXMpIHsKIAljYXNlIFNUVjA5MHhfRFZCUzI6CkBAIC00MjgzLDE0ICs0Mjk3LDEz
IEBACiAJCQkJcmVnXzEgPSBTVFYwOTB4X1JFQURfREVNT0Qoc3RhdGUsIE5OT1NQTEhUMSk7CiAJ
CQkJdmFsXzEgPSBTVFYwOTB4X0dFVEZJRUxEX1B4KHJlZ18xLCBOT1NQTEhUX05PUk1FRF9GSUVM
RCk7CiAJCQkJcmVnXzAgPSBTVFYwOTB4X1JFQURfREVNT0Qoc3RhdGUsIE5OT1NQTEhUMCk7Ci0J
CQkJdmFsXzAgPSBTVFYwOTB4X0dFVEZJRUxEX1B4KHJlZ18xLCBOT1NQTEhUX05PUk1FRF9GSUVM
RCk7CisJCQkJdmFsXzAgPSBTVFYwOTB4X0dFVEZJRUxEX1B4KHJlZ18wLCBOT1NQTEhUX05PUk1F
RF9GSUVMRCk7CiAJCQkJdmFsICArPSBNQUtFV09SRDE2KHZhbF8xLCB2YWxfMCk7CiAJCQkJbXNs
ZWVwKDEpOwogCQkJfQogCQkJdmFsIC89IDE2OwotCQkJKmNuciA9IHN0djA5MHhfdGFibGVfbG9v
a3VwKHN0djA5MHhfczJjbl90YWIsIEFSUkFZX1NJWkUoc3R2MDkweF9zMmNuX3RhYikgLSAxLCB2
YWwpOwotCQkJaWYgKHZhbCA8IHN0djA5MHhfczJjbl90YWJbQVJSQVlfU0laRShzdHYwOTB4X3My
Y25fdGFiKSAtIDFdLnJlYWQpCi0JCQkJKmNuciA9IDEwMDA7CisJCQlzbnIgPSBzdHYwOTB4X3Rh
YmxlX2xvb2t1cChzdHYwOTB4X3MyY25fdGFiLCBBUlJBWV9TSVpFKHN0djA5MHhfczJjbl90YWIp
IC0gMSwgdmFsKTsKKwkJCSpjbnIgPSBzbnIgKiAweEZGRkYgLyBzdHYwOTB4X3MyY25fdGFiW0FS
UkFZX1NJWkUoc3R2MDkweF9zMmNuX3RhYikgLSAxXS5yZWFsOwogCQl9CiAJCWJyZWFrOwogCkBA
IC00MzA0LDE0ICs0MzE3LDEzIEBACiAJCQkJcmVnXzEgPSBTVFYwOTB4X1JFQURfREVNT0Qoc3Rh
dGUsIE5PU0RBVEFUMSk7CiAJCQkJdmFsXzEgPSBTVFYwOTB4X0dFVEZJRUxEX1B4KHJlZ18xLCBO
T1NEQVRBVF9VTk5PUk1FRF9GSUVMRCk7CiAJCQkJcmVnXzAgPSBTVFYwOTB4X1JFQURfREVNT0Qo
c3RhdGUsIE5PU0RBVEFUMCk7Ci0JCQkJdmFsXzAgPSBTVFYwOTB4X0dFVEZJRUxEX1B4KHJlZ18x
LCBOT1NEQVRBVF9VTk5PUk1FRF9GSUVMRCk7CisJCQkJdmFsXzAgPSBTVFYwOTB4X0dFVEZJRUxE
X1B4KHJlZ18wLCBOT1NEQVRBVF9VTk5PUk1FRF9GSUVMRCk7CiAJCQkJdmFsICArPSBNQUtFV09S
RDE2KHZhbF8xLCB2YWxfMCk7CiAJCQkJbXNsZWVwKDEpOwogCQkJfQogCQkJdmFsIC89IDE2Owot
CQkJKmNuciA9IHN0djA5MHhfdGFibGVfbG9va3VwKHN0djA5MHhfczFjbl90YWIsIEFSUkFZX1NJ
WkUoc3R2MDkweF9zMWNuX3RhYikgLSAxLCB2YWwpOwotCQkJaWYgKHZhbCA8IHN0djA5MHhfczJj
bl90YWJbQVJSQVlfU0laRShzdHYwOTB4X3MxY25fdGFiKSAtIDFdLnJlYWQpCi0JCQkJKmNuciA9
IDEwMDA7CisJCQlzbnIgPSBzdHYwOTB4X3RhYmxlX2xvb2t1cChzdHYwOTB4X3MxY25fdGFiLCBB
UlJBWV9TSVpFKHN0djA5MHhfczFjbl90YWIpIC0gMSwgdmFsKTsKKwkJCSpjbnIgPSBzbnIgKiAw
eEZGRkYgLyBzdHYwOTB4X3MxY25fdGFiW0FSUkFZX1NJWkUoc3R2MDkweF9zMWNuX3RhYikgLSAx
XS5yZWFsOwogCQl9CiAJCWJyZWFrOwogCWRlZmF1bHQ6Cg==
--001636c5aa41907d6b046a861139--
