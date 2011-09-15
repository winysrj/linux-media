Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:45620 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1IORQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 13:16:00 -0400
Received: by wyj26 with SMTP id 26so3726236wyj.11
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 10:15:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110406071512.GB8115@aniel>
References: <AANLkTimexhCMBSd7UNr1gizgbnarwS9kucZC0nWSBJxX@mail.gmail.com>
	<201103151450.08708@orion.escape-edv.de>
	<20110404110519.GE24212@aniel>
	<201104060839.08855@orion.escape-edv.de>
	<20110406071512.GB8115@aniel>
Date: Thu, 15 Sep 2011 19:09:26 +0200
Message-ID: <CAFb9v3xJZF0ght0j_vd3FqGhS5ko888icQvqMG7zxPJaf9-+Kg@mail.gmail.com>
Subject: Re: [PATCH] DVB-APPS: azap gets -p argument
From: Christian Ulrich <chrulri@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=002354332f0e6379ad04acfdf04b
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--002354332f0e6379ad04acfdf04b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Patch still not pushed?

2011/4/6 Janne Grunau <j@jannau.net>:
> On Wed, Apr 06, 2011 at 08:39:05AM +0200, Oliver Endriss wrote:
>> On Monday 04 April 2011 13:05:19 Janne Grunau wrote:
>> > On Tue, Mar 15, 2011 at 02:50:05PM +0100, Oliver Endriss wrote:
>> > > The PAT/PMT from the stream does not describe the dvr stream correct=
ly.
>> > >
>> > > The dvr device provides *some* PIDs of the transponder, while the
>> > > PAT/PMT reference *all* programs of the transponder.
>> >
>> > True, the PAT references some PMT pids which won't be included. All pi=
ds
>> > from the desired program should be included. A transport stream withou=
t
>> > PAT/PMT is as invalid as the stream with incorrect PAT/PMT/missing pid=
s
>> > but the second is easier to handle for player software than the first.
>>
>> A sane player can handle a TS stream without PAT/PMT.
>> Iirc mplayer never had any problems.
>
> mplayer with default options has only no problems as long as the video
> codec is mpeg2 and possible mpeg 1 layer 2 audio. Try any H.264 stream
> and see it fail. That was the reason why I want to change the behaviour
> with -r in the first place. http://blog.fefe.de/?ts=3Db58fb6b1 (german
> content) triggered it.
>
> I don't care too much. Can someone please push Christian's original
> patch adding -p to azap.
>
> Janne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--002354332f0e6379ad04acfdf04b
Content-Type: application/octet-stream; name="azap_patpmt.patch"
Content-Disposition: attachment; filename="azap_patpmt.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gslzuwr70

LS0tIGxpbnV4dHYtZHZiLWFwcHMvdXRpbC9zemFwL2F6YXAuYy5vcmlnCTIwMTEtMDMtMDQgMTE6
NDM6MDAuMTMzNzU3MDAxICswMTAwCisrKyBsaW51eHR2LWR2Yi1hcHBzL3V0aWwvc3phcC9hemFw
LmMJMjAxMS0wMy0wNSAwMjoxNTozMS4yODk3NTY0NDMgKzAxMDAKQEAgLTE3MSw3ICsxNzEsNyBA
QAogCiAKIGludCBwYXJzZShjb25zdCBjaGFyICpmbmFtZSwgY29uc3QgY2hhciAqY2hhbm5lbCwK
LQkgIHN0cnVjdCBkdmJfZnJvbnRlbmRfcGFyYW1ldGVycyAqZnJvbnRlbmQsIGludCAqdnBpZCwg
aW50ICphcGlkKQorCSAgc3RydWN0IGR2Yl9mcm9udGVuZF9wYXJhbWV0ZXJzICpmcm9udGVuZCwg
aW50ICp2cGlkLCBpbnQgKmFwaWQsIGludCAqc2lkKQogewogCWludCBmZDsKIAlpbnQgZXJyOwpA
QCAtMjA0LDYgKzIwNCw5IEBACiAJaWYgKChlcnIgPSB0cnlfcGFyc2VfaW50KGZkLCBhcGlkLCAi
QXVkaW8gUElEIikpKQogCQlyZXR1cm4gLTY7CiAKKwlpZiAoKGVyciA9IHRyeV9wYXJzZV9pbnQo
ZmQsIHNpZCwgIlNlcnZpY2UgSUQiKSkpCisJCXJldHVybiAtNzsKKwogCWNsb3NlKGZkKTsKIAog
CXJldHVybiAwOwpAQCAtMjY2LDcgKzI2OSw3IEBACiB9CiAKIAotc3RhdGljIGNvbnN0IGNoYXIg
KnVzYWdlID0gIlxudXNhZ2U6ICVzIFstYSBhZGFwdGVyX251bV0gWy1mIGZyb250ZW5kX2lkXSBb
LWQgZGVtdXhfaWRdIFstYyBjb25mX2ZpbGVdIFstcl0gPGNoYW5uZWwgbmFtZT5cblxuIjsKK3N0
YXRpYyBjb25zdCBjaGFyICp1c2FnZSA9ICJcbnVzYWdlOiAlcyBbLWEgYWRhcHRlcl9udW1dIFst
ZiBmcm9udGVuZF9pZF0gWy1kIGRlbXV4X2lkXSBbLWMgY29uZl9maWxlXSBbLXJdIFstcF0gPGNo
YW5uZWwgbmFtZT5cblxuIjsKIAogCiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCkBA
IC0yNzYsMTEgKzI3OSwxMyBAQAogCWNoYXIgKmNvbmZuYW1lID0gTlVMTDsKIAljaGFyICpjaGFu
bmVsID0gTlVMTDsKIAlpbnQgYWRhcHRlciA9IDAsIGZyb250ZW5kID0gMCwgZGVtdXggPSAwLCBk
dnIgPSAwOwotCWludCB2cGlkLCBhcGlkOworCWludCB2cGlkLCBhcGlkLCBzaWQsIHBtdHBpZCA9
IDA7CisJaW50IHBhdF9mZCwgcG10X2ZkOwogCWludCBmcm9udGVuZF9mZCwgYXVkaW9fZmQsIHZp
ZGVvX2ZkOwogCWludCBvcHQ7CisJaW50IHJlY19wc2kgPSAwOwogCi0Jd2hpbGUgKChvcHQgPSBn
ZXRvcHQoYXJnYywgYXJndiwgImhybjphOmY6ZDpjOiIpKSAhPSAtMSkgeworCXdoaWxlICgob3B0
ID0gZ2V0b3B0KGFyZ2MsIGFyZ3YsICJocnBuOmE6ZjpkOmM6IikpICE9IC0xKSB7CiAJCXN3aXRj
aCAob3B0KSB7CiAJCWNhc2UgJ2EnOgogCQkJYWRhcHRlciA9IHN0cnRvdWwob3B0YXJnLCBOVUxM
LCAwKTsKQEAgLTI5NCw2ICsyOTksOSBAQAogCQljYXNlICdyJzoKIAkJCWR2ciA9IDE7CiAJCQli
cmVhazsKKwkJY2FzZSAncCc6CisJCQlyZWNfcHNpID0gMTsKKwkJCWJyZWFrOwogCQljYXNlICdj
JzoKIAkJCWNvbmZuYW1lID0gb3B0YXJnOwogCQkJYnJlYWs7CkBAIC0zMzMsNyArMzQxLDcgQEAK
IAogCW1lbXNldCgmZnJvbnRlbmRfcGFyYW0sIDAsIHNpemVvZihzdHJ1Y3QgZHZiX2Zyb250ZW5k
X3BhcmFtZXRlcnMpKTsKIAotCWlmIChwYXJzZSAoY29uZm5hbWUsIGNoYW5uZWwsICZmcm9udGVu
ZF9wYXJhbSwgJnZwaWQsICZhcGlkKSkKKwlpZiAocGFyc2UgKGNvbmZuYW1lLCBjaGFubmVsLCAm
ZnJvbnRlbmRfcGFyYW0sICZ2cGlkLCAmYXBpZCwgJnNpZCkpCiAJCXJldHVybiAtMTsKIAogCWlm
ICgoZnJvbnRlbmRfZmQgPSBvcGVuKEZST05URU5EX0RFViwgT19SRFdSKSkgPCAwKSB7CkBAIC0z
NDQsNiArMzUyLDI5IEBACiAJaWYgKHNldHVwX2Zyb250ZW5kIChmcm9udGVuZF9mZCwgJmZyb250
ZW5kX3BhcmFtKSA8IDApCiAJCXJldHVybiAtMTsKIAorCisgICAgICAgIGlmIChyZWNfcHNpKSB7
CisgICAgICAgICAgICBwbXRwaWQgPSBnZXRfcG10X3BpZChERU1VWF9ERVYsIHNpZCk7CisgICAg
ICAgICAgICBpZiAocG10cGlkIDw9IDApIHsKKyAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwiY291bGRuJ3QgZmluZCBwbXQtcGlkIGZvciBzaWQgJTA0eFxuIixzaWQpOworICAgICAgICAg
ICAgICAgIHJldHVybiAtMTsKKyAgICAgICAgICAgIH0KKworICAgICAgICAgICAgaWYgKChwYXRf
ZmQgPSBvcGVuKERFTVVYX0RFViwgT19SRFdSKSkgPCAwKSB7CisgICAgICAgICAgICAgICAgcGVy
cm9yKCJvcGVuaW5nIHBhdCBkZW11eCBmYWlsZWQiKTsKKyAgICAgICAgICAgICAgICByZXR1cm4g
LTE7CisgICAgICAgICAgICB9CisgICAgICAgICAgICBpZiAoc2V0X3Blc2ZpbHRlcihwYXRfZmQs
IDAsIERNWF9QRVNfT1RIRVIsIGR2cikgPCAwKQorICAgICAgICAgICAgICAgIHJldHVybiAtMTsK
KworICAgICAgICAgICAgaWYgKChwbXRfZmQgPSBvcGVuKERFTVVYX0RFViwgT19SRFdSKSkgPCAw
KSB7CisgICAgICAgICAgICAgICAgcGVycm9yKCJvcGVuaW5nIHBtdCBkZW11eCBmYWlsZWQiKTsK
KyAgICAgICAgICAgICAgICByZXR1cm4gLTE7CisgICAgICAgICAgICB9CisgICAgICAgICAgICBp
ZiAoc2V0X3Blc2ZpbHRlcihwbXRfZmQsIHBtdHBpZCwgRE1YX1BFU19PVEhFUiwgZHZyKSA8IDAp
CisgICAgICAgICAgICAgICAgcmV0dXJuIC0xOworICAgICAgICB9CisKICAgICAgICAgaWYgKCh2
aWRlb19mZCA9IG9wZW4oREVNVVhfREVWLCBPX1JEV1IpKSA8IDApIHsKICAgICAgICAgICAgICAg
ICBQRVJST1IoImZhaWxlZCBvcGVuaW5nICclcyciLCBERU1VWF9ERVYpOwogICAgICAgICAgICAg
ICAgIHJldHVybiAtMTsKQEAgLTM2Myw2ICszOTQsOCBAQAogCiAJY2hlY2tfZnJvbnRlbmQgKGZy
b250ZW5kX2ZkKTsKIAorICAgICAgICBjbG9zZSAocGF0X2ZkKTsKKyAgICAgICAgY2xvc2UgKHBt
dF9mZCk7CiAJY2xvc2UgKGF1ZGlvX2ZkKTsKIAljbG9zZSAodmlkZW9fZmQpOwogCWNsb3NlIChm
cm9udGVuZF9mZCk7Cg==
--002354332f0e6379ad04acfdf04b--
