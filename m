Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59980 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZKCXKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2009 18:10:13 -0500
Received: by bwz27 with SMTP id 27so8209181bwz.21
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 15:10:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AEC08F0.70205@redhat.com>
References: <846899810910241711s6fb5939fq3a693a92a2a76310@mail.gmail.com>
	 <4AEC08F0.70205@redhat.com>
Date: Wed, 4 Nov 2009 00:10:17 +0100
Message-ID: <846899810911031510p252dadfeu3fa058c7b8733270@mail.gmail.com>
Subject: Re: [PATCH] isl6421.c - added optional features: tone control and
	temporary diseqc overcurrent
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Ales Jurik <ajurik@quick.cz>
Content-Type: multipart/mixed; boundary=001485f792f0ee338304777f98ca
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001485f792f0ee338304777f98ca
Content-Type: text/plain; charset=ISO-8859-1

Hi Mauro,

thank you for your valued hints. I'm commenting inside
message:

> First of all, please check all your patches with checkpatch, to be sure
> that they don't have any CodingStyle troubles. There are some on your
> patch (the better is to read README.patches for more info useful
> for developers).

Did checkpatch testing and has fixed all errors/warnings except
of 3 warning regarding longer line (all 3 lines has exactly
one char over 80, so I guess it should not bother much).
Of course if this rule is a must, then I can fix that also).

>>
>> Attached patch adds two optional (so, disabled by default
>> and therefore could not break any compatibility) features:
>>
>> 1, tone_control=1
>> When enabled, ISL6421 overrides frontend's tone control
>> function (fe->ops.set_tone) by its own one.
>>
>
> On your comments, the better is to describe why someone would need
> to use such option. You should also add a quick hint about that at the
> option description.

Well, I'm not sure I can make some good hint why such option can
be useful by someone. I can only say that isl6121 has possibility
to drive 22k tone, so why not enable usage of it?

Of course, we made such code because we were using exactly
this way of 22k control in our device.

>>
>> 2, overcurrent_enable=1
>> When enabled, overcurrent protection is disabled during
>> sending diseqc command. Such option is usable when ISL6421
>> catch overcurrent threshold and starts limiting output.
>> Note: protection is disabled only during sending
>> of diseqc command, until next set_tone() usage.
>> What typically means only max up to few hundreds of ms.
>> WARNING: overcurrent_enable=1 is dangerous
>> and can damage your device. Use with care
>> and only if you really know what you do.
>>
>
> I'm not sure if it is a good idea to have this... Why/when someone would
> need this?
>

I know that it is a bit dangerous option, so I can understand you can
don't like it :)

But I would like to note again - such way of using is permitted
by datasheet (otherwise it would not be even possible to enable it)
and we learnt when used correctly (it is enabled only within diseqc
sequence), it boost rotor moving or fixes using some "power-eating"
diseqc switches.

If you still feel it is better to not support bit strange mode, then
I can live with "#if 0" commented out blocks or adding some
kernel config option with something like ISL6421_ENABLE_OVERCURRENT
or so.

> If we go ahead and add this one, you should add a notice about it at the
> parameter.
> I would also print a big WARNING message at the dmesg if the module were
> loaded
> with this option turned on.

Added some WARNING printing to dmesg when option is enabled.

Regards

/Honza

---

Signed-off-by: Jan Petrous <jpetrous@gmail.com>
Signed-off-by: Ales Jurik <ajurik@quick.cz>

--001485f792f0ee338304777f98ca
Content-Type: text/x-patch; charset=US-ASCII; name="isl6421-tonectrl_overcurr.patch"
Content-Disposition: attachment; filename="isl6421-tonectrl_overcurr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g1l9me8c0

ZGlmZiAtciA5ZDliYzkyZDdjMzMgZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2lzbDY0MjEu
YwotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvaXNsNjQyMS5jCVNhdCBTZXAgMTkg
MTI6NDg6NDQgMjAwOSArMDIwMAorKysgYi9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvaXNs
NjQyMS5jCVR1ZSBOb3YgMDMgMjM6MjM6MDUgMjAwOSArMDEwMApAQCAtMyw2ICszLDkgQEAKICAq
CiAgKiBDb3B5cmlnaHQgKEMpIDIwMDYgQW5kcmV3IGRlIFF1aW5jZXkKICAqIENvcHlyaWdodCAo
QykgMjAwNiBPbGl2ZXIgRW5kcmlzcworICogQ29weXJpZ2h0IChDKSAyMDA5IEFsZXMgSnVyaWsg
YW5kIEphbiBQZXRyb3VzIChhZGRlZCBvcHRpb25hbCAyMmsgdG9uZQorICogICAgICAgICAgICAg
ICAgICAgIHN1cHBvcnQgYW5kIHRlbXBvcmFyeSBkaXNlcWMgb3ZlcmN1cnJlbnQgZW5hYmxlIHVu
dGlsCisgKiAgICAgICAgICAgICAgICAgICAgbmV4dCBjb21tYW5kIC0gc2V0IHZvbHRhZ2Ugb3Ig
dG9uZSkKICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRp
c3RyaWJ1dGUgaXQgYW5kL29yCiAgKiBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQpAQCAtMzUsMTIgKzM4LDIzIEBACiAjaW5jbHVkZSAi
ZHZiX2Zyb250ZW5kLmgiCiAjaW5jbHVkZSAiaXNsNjQyMS5oIgogCitzdGF0aWMgaW50IHRvbmVf
Y29udHJvbDsKK21vZHVsZV9wYXJhbSh0b25lX2NvbnRyb2wsIGludCwgU19JUlVHTyk7CitNT0RV
TEVfUEFSTV9ERVNDKHRvbmVfY29udHJvbCwgIlNldCBJU0w2NDIxIHRvIGNvbnRyb2wgMjJrSHog
dG9uZSIpOworCitzdGF0aWMgaW50IG92ZXJjdXJyZW50X2VuYWJsZTsKK21vZHVsZV9wYXJhbShv
dmVyY3VycmVudF9lbmFibGUsIGludCwgU19JUlVHTyk7CitNT0RVTEVfUEFSTV9ERVNDKG92ZXJj
dXJyZW50X2VuYWJsZSwgIlNldCBJU0w2NDIxIHRvIHRlbXBvcmFyeSBlbmFibGUgIgorCQkib3Zl
cmN1cnJlbnQgd2hlbiBkaXNlcWMgY29tbWFuZCBpcyBhY3RpdmUiKTsKKwogc3RydWN0IGlzbDY0
MjEgewogCXU4CQkJY29uZmlnOwogCXU4CQkJb3ZlcnJpZGVfb3I7CiAJdTgJCQlvdmVycmlkZV9h
bmQ7CiAJc3RydWN0IGkyY19hZGFwdGVyCSppMmM7CiAJdTgJCQlpMmNfYWRkcjsKKwlpbnQgKCpk
aXNlcWNfc2VuZF9tYXN0ZXJfY21kX29yaWcpKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLAorCQkJ
c3RydWN0IGR2Yl9kaXNlcWNfbWFzdGVyX2NtZCAqY21kKTsKIH07CiAKIHN0YXRpYyBpbnQgaXNs
NjQyMV9zZXRfdm9sdGFnZShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwgZmVfc2VjX3ZvbHRhZ2Vf
dCB2b2x0YWdlKQpAQCAtNjAsNiArNzQsNTUgQEAgc3RhdGljIGludCBpc2w2NDIxX3NldF92b2x0
YWdlKHN0cnVjdCBkdgogCQlicmVhazsKIAljYXNlIFNFQ19WT0xUQUdFXzE4OgogCQlpc2w2NDIx
LT5jb25maWcgfD0gKElTTDY0MjFfRU4xIHwgSVNMNjQyMV9WU0VMMSk7CisJCWJyZWFrOworCWRl
ZmF1bHQ6CisJCXJldHVybiAtRUlOVkFMOworCX07CisKKwlpc2w2NDIxLT5jb25maWcgfD0gaXNs
NjQyMS0+b3ZlcnJpZGVfb3I7CisJaXNsNjQyMS0+Y29uZmlnICY9IGlzbDY0MjEtPm92ZXJyaWRl
X2FuZDsKKworCXJldHVybiAoaTJjX3RyYW5zZmVyKGlzbDY0MjEtPmkyYywgJm1zZywgMSkgPT0g
MSkgPyAwIDogLUVJTzsKK30KKworc3RhdGljIGludCBpc2w2NDIxX3NlbmRfZGlzZXFjKHN0cnVj
dCBkdmJfZnJvbnRlbmQgKmZlLAorCQkJCXN0cnVjdCBkdmJfZGlzZXFjX21hc3Rlcl9jbWQgKmNt
ZCkKK3sKKwlzdHJ1Y3QgaXNsNjQyMSAqaXNsNjQyMSA9IChzdHJ1Y3QgaXNsNjQyMSAqKSBmZS0+
c2VjX3ByaXY7CisJc3RydWN0IGkyY19tc2cgbXNnID0gewkuYWRkciA9IGlzbDY0MjEtPmkyY19h
ZGRyLCAuZmxhZ3MgPSAwLAorCQkJCS5idWYgPSAmaXNsNjQyMS0+Y29uZmlnLAorCQkJCS5sZW4g
PSBzaXplb2YoaXNsNjQyMS0+Y29uZmlnKSB9OworCisJaXNsNjQyMS0+Y29uZmlnIHw9IElTTDY0
MjFfRENMOworCisJaXNsNjQyMS0+Y29uZmlnIHw9IGlzbDY0MjEtPm92ZXJyaWRlX29yOworCWlz
bDY0MjEtPmNvbmZpZyAmPSBpc2w2NDIxLT5vdmVycmlkZV9hbmQ7CisKKwlpZiAoaTJjX3RyYW5z
ZmVyKGlzbDY0MjEtPmkyYywgJm1zZywgMSkgIT0gMSkKKwkJcmV0dXJuIC1FSU87CisKKwlpc2w2
NDIxLT5jb25maWcgJj0gfklTTDY0MjFfRENMOworCisJcmV0dXJuIGlzbDY0MjEtPmRpc2VxY19z
ZW5kX21hc3Rlcl9jbWRfb3JpZyhmZSwgY21kKTsKK30KKworc3RhdGljIGludCBpc2w2NDIxX3Nl
dF90b25lKHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBmZV9zZWNfdG9uZV9tb2RlX3QgdG9uZSkK
K3sKKwlzdHJ1Y3QgaXNsNjQyMSAqaXNsNjQyMSA9IChzdHJ1Y3QgaXNsNjQyMSAqKSBmZS0+c2Vj
X3ByaXY7CisJc3RydWN0IGkyY19tc2cgbXNnID0gewkuYWRkciA9IGlzbDY0MjEtPmkyY19hZGRy
LCAuZmxhZ3MgPSAwLAorCQkJCS5idWYgPSAmaXNsNjQyMS0+Y29uZmlnLAorCQkJCS5sZW4gPSBz
aXplb2YoaXNsNjQyMS0+Y29uZmlnKSB9OworCisJaXNsNjQyMS0+Y29uZmlnICY9IH4oSVNMNjQy
MV9FTlQxKTsKKworCXByaW50ayhLRVJOX0lORk8gIiVzOiAlc1xuIiwgX19mdW5jX18sICgodG9u
ZSA9PSBTRUNfVE9ORV9PRkYpID8KKwkJCQkiT2ZmIiA6ICJPbiIpKTsKKworCXN3aXRjaCAodG9u
ZSkgeworCWNhc2UgU0VDX1RPTkVfT046CisJCWlzbDY0MjEtPmNvbmZpZyB8PSBJU0w2NDIxX0VO
VDE7CisJCWJyZWFrOworCWNhc2UgU0VDX1RPTkVfT0ZGOgogCQlicmVhazsKIAlkZWZhdWx0Ogog
CQlyZXR1cm4gLUVJTlZBTDsKQEAgLTkxLDE4ICsxNTQsMjYgQEAgc3RhdGljIGludCBpc2w2NDIx
X2VuYWJsZV9oaWdoX2xuYl92b2x0YQogCiBzdGF0aWMgdm9pZCBpc2w2NDIxX3JlbGVhc2Uoc3Ry
dWN0IGR2Yl9mcm9udGVuZCAqZmUpCiB7CisJc3RydWN0IGlzbDY0MjEgKmlzbDY0MjEgPSAoc3Ry
dWN0IGlzbDY0MjEgKikgZmUtPnNlY19wcml2OworCiAJLyogcG93ZXIgb2ZmICovCiAJaXNsNjQy
MV9zZXRfdm9sdGFnZShmZSwgU0VDX1ZPTFRBR0VfT0ZGKTsKKworCWlmIChvdmVyY3VycmVudF9l
bmFibGUpCisJCWZlLT5vcHMuZGlzZXFjX3NlbmRfbWFzdGVyX2NtZCA9CisJCQlpc2w2NDIxLT5k
aXNlcWNfc2VuZF9tYXN0ZXJfY21kX29yaWc7CiAKIAkvKiBmcmVlICovCiAJa2ZyZWUoZmUtPnNl
Y19wcml2KTsKIAlmZS0+c2VjX3ByaXYgPSBOVUxMOwogfQogCi1zdHJ1Y3QgZHZiX2Zyb250ZW5k
ICppc2w2NDIxX2F0dGFjaChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwgc3RydWN0IGkyY19hZGFw
dGVyICppMmMsIHU4IGkyY19hZGRyLAotCQkgICB1OCBvdmVycmlkZV9zZXQsIHU4IG92ZXJyaWRl
X2NsZWFyKQorc3RydWN0IGR2Yl9mcm9udGVuZCAqaXNsNjQyMV9hdHRhY2goc3RydWN0IGR2Yl9m
cm9udGVuZCAqZmUsCisJCXN0cnVjdCBpMmNfYWRhcHRlciAqaTJjLCB1OCBpMmNfYWRkciwgdTgg
b3ZlcnJpZGVfc2V0LAorCQl1OCBvdmVycmlkZV9jbGVhcikKIHsKIAlzdHJ1Y3QgaXNsNjQyMSAq
aXNsNjQyMSA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBpc2w2NDIxKSwgR0ZQX0tFUk5FTCk7CisK
IAlpZiAoIWlzbDY0MjEpCiAJCXJldHVybiBOVUxMOwogCkBAIC0xMzEsNiArMjAyLDMzIEBAIHN0
cnVjdCBkdmJfZnJvbnRlbmQgKmlzbDY0MjFfYXR0YWNoKHN0cnUKIAkvKiBvdmVycmlkZSBmcm9u
dGVuZCBvcHMgKi8KIAlmZS0+b3BzLnNldF92b2x0YWdlID0gaXNsNjQyMV9zZXRfdm9sdGFnZTsK
IAlmZS0+b3BzLmVuYWJsZV9oaWdoX2xuYl92b2x0YWdlID0gaXNsNjQyMV9lbmFibGVfaGlnaF9s
bmJfdm9sdGFnZTsKKwlpZiAodG9uZV9jb250cm9sKQorCQlmZS0+b3BzLnNldF90b25lID0gaXNs
NjQyMV9zZXRfdG9uZTsKKworCXByaW50ayhLRVJOX0lORk8gIklTTDY0MjEgYXR0YWNoZWQgb24g
YWRkcj0leFxuIiwgaTJjX2FkZHIpOworCisJaWYgKG92ZXJjdXJyZW50X2VuYWJsZSkgeworCQlp
ZiAoKG92ZXJyaWRlX3NldCAmIElTTDY0MjFfRENMKSB8fAorCQkJCShvdmVycmlkZV9jbGVhciAm
IElTTDY0MjFfRENMKSkgeworCQkJLyogdGhlcmUgaXMgbm8gc2Vuc2UgdG8gdXNlIG92ZXJjdXJy
ZW50X2VuYWJsZQorCQkJICogd2l0aCBEQ0wgYml0IHNldCBpbiBhbnkgb3ZlcnJpZGUgYnl0ZSAq
LworCQkJaWYgKG92ZXJyaWRlX3NldCAmIElTTDY0MjFfRENMKQorCQkJCXByaW50ayhLRVJOX1dB
Uk5JTkcgIklTTDY0MjEgb3ZlcmN1cnJlbnRfZW5hYmxlIgorCQkJCQkJIiB3aXRoIERDTCBiaXQg
aW4gb3ZlcnJpZGVfc2V0LCIKKwkJCQkJCSIgb3ZlcmN1cnJlbnRfZW5hYmxlIGlnbm9yZWRcbiIp
OworCQkJaWYgKG92ZXJyaWRlX2NsZWFyICYgSVNMNjQyMV9EQ0wpCisJCQkJcHJpbnRrKEtFUk5f
V0FSTklORyAiSVNMNjQyMSBvdmVyY3VycmVudF9lbmFibGUiCisJCQkJCQkiIHdpdGggRENMIGJp
dCBpbiBvdmVycmlkZV9jbGVhciwiCisJCQkJCQkiIG92ZXJjdXJyZW50X2VuYWJsZSBpZ25vcmVk
XG4iKTsKKwkJfSBlbHNlIHsKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIklTTDY0MjEgb3ZlcmN1
cnJlbnRfZW5hYmxlICIKKwkJCQkJIiBhY3RpdmF0ZWQuIFdBUk5JTkc6IGl0IGNhbiBiZSAiCisJ
CQkJCSIgZGFuZ2Vyb3VzIGZvciB5b3VyIGhhcmR3YXJlISIpOworCQkJaXNsNjQyMS0+ZGlzZXFj
X3NlbmRfbWFzdGVyX2NtZF9vcmlnID0KKwkJCQlmZS0+b3BzLmRpc2VxY19zZW5kX21hc3Rlcl9j
bWQ7CisJCQlmZS0+b3BzLmRpc2VxY19zZW5kX21hc3Rlcl9jbWQgPSBpc2w2NDIxX3NlbmRfZGlz
ZXFjOworCQl9CisJfQogCiAJcmV0dXJuIGZlOwogfQo=
--001485f792f0ee338304777f98ca--
