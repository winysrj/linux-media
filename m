Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab1KNTju (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 14:39:50 -0500
Received: by wyh15 with SMTP id 15so6253349wyh.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 11:39:49 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Nov 2011 01:09:48 +0530
Message-ID: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
Subject: PATCH v3: Query DVB frontend delivery capabilities (was: Re: PATCH:
 Query DVB frontend capabilities)
From: Manu Abraham <abraham.manu@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: multipart/mixed; boundary=0016e6dee805a310a604b1b708f8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016e6dee805a310a604b1b708f8
Content-Type: text/plain; charset=ISO-8859-1

On 11/12/11, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
>> Em 11-11-2011 20:07, Manu Abraham escreveu:
>>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
>>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>>>>> <mchehab@redhat.com> wrote:
>>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>>>> The purpose of the patch is to
>>>>> query DVB delivery system capabilities alone, rather than DVB frontend
>>>>> info/capability.
>>>>>
>>>>> Attached is a revised version 2 of the patch, which addresses the
>>>>> issues that were raised.
>>>>
>>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
>>>> Please, when submitting upstream, don't forget to increment DVB version
>>>> and
>>>> add touch at DocBook, in order to not increase the gap between API specs
>>>> and the
>>>> implementation.
>>>
>>> Ok, thanks for the feedback, will do that.
>>>
>>> The naming issue is trivial. I would like to have a shorter name
>>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
>>> device capability.
>>
>> CAPS is not a good name, as there are those two CAPABILITIES calls there
>> (well, currently not implemented). So, it can lead in to some confusion.
>>
>> DTV_ENUM_DELIVERY could be an alternative for a short name to be used
>> there.
>
> I like "enum", because it suggests that it's a read-only property.
>
> DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
> alternative.

This is a bit more sensible and meaningful than the others. I like
this one better than the others.

Attached is a version 3 patch which addresses all the issues that were raised.

Regards,
Manu

--0016e6dee805a310a604b1b708f8
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-DVB-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0001-DVB-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSA5MGEwMGZmYmFhMWNkZDFlNDlmNjNjM2Y2ZjkxMmVlNWZkNDIwYTZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IE1vbiwgMTQgTm92IDIwMTEgMDM6MTc6NDQgKzA1MzAKU3ViamVjdDogW1BBVENIXSBE
VkI6IFF1ZXJ5IERWQiBmcm9udGVuZCBkZWxpdmVyeSBjYXBhYmlsaXRpZXMuCgogQ3VycmVudGx5
LCBmb3IgYW55IG11bHRpLXN0YW5kYXJkIGZyb250ZW5kIGl0IGlzIGFzc3VtZWQgdGhhdCBpdCBq
dXN0CiBoYXMgYSBzaW5nbGUgc3RhbmRhcmQgY2FwYWJpbGl0eS4gVGhpcyBpcyBmaW5lIGluIHNv
bWUgY2FzZXMsIGJ1dAogbWFrZXMgdGhpbmdzIGhhcmQgd2hlbiB0aGVyZSBhcmUgaW5jb21wYXRp
YmxlIHN0YW5kYXJkcyBpbiBjb25qdWN0aW9uLgogRWc6IERWQi1TIGNhbiBiZSBzZWVuIGFzIGEg
c3Vic2V0IG9mIERWQi1TMiwgYnV0IHRoZSBzYW1lIGRvZXNuJ3QgaG9sZAogdGhlIHNhbWUgZm9y
IERTUy4gVGhpcyBpcyBub3Qgc3BlY2lmaWMgdG8gYW55IGRyaXZlciBhcyBpdCBpcywgYnV0IGEK
IGdlbmVyaWMgaXNzdWUuIFRoaXMgd2FzIGhhbmRsZWQgY29ycmVjdGx5IGluIHRoZSBtdWx0aXBy
b3RvIHRyZWUsCiB3aGlsZSBzdWNoIGZ1bmN0aW9uYWxpdHkgaXMgbWlzc2luZyBmcm9tIHRoZSB2
NSBBUEkgdXBkYXRlLgoKIGh0dHA6Ly93d3cubGludXh0di5vcmcvcGlwZXJtYWlsL3Zkci8yMDA4
LU5vdmVtYmVyLzAxODQxNy5odG1sCgogTGF0ZXIgb24gYSBGRV9DQU5fMkdfTU9EVUxBVElPTiB3
YXMgYWRkZWQgYXMgYSBoYWNrIHRvIHdvcmthcm91bmQgdGhpcwogaXNzdWUgaW4gdGhlIHY1IEFQ
SSwgYnV0IHRoYXQgaGFjayBpcyBpbmNhcGFibGUgb2YgYWRkcmVzc2luZyB0aGUKIGlzc3VlLCBh
cyBpdCBjYW4gYmUgdXNlZCB0byBzaW1wbHkgZGlzdGluZ3Vpc2ggYmV0d2VlbiBEVkItUyBhbmQK
IERWQi1TMiBhbG9uZSwgb3IgYW5vdGhlciBYIHZzIFgyIG1vZHVsYXRpb24uIElmIHRoZXJlIGFy
ZSBtb3JlIHN5c3RlbXMsCiB0aGVuIHlvdSBoYXZlIGEgcG90ZW50aWFsIGlzc3VlLgoKIEFuIGFw
cGxpY2F0aW9uIG5lZWRzIHRvIHF1ZXJ5IHRoZSBkZXZpY2UgY2FwYWJpbGl0aWVzIGJlZm9yZSBy
ZXF1ZXN0aW5nCiBhbnkgb3BlcmF0aW9uIGZyb20gdGhlIGRldmljZS4KClNpZ25lZC1vZmYtYnk6
IE1hbnUgQWJyYWhhbSA8YWJyYWhhbS5tYW51QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21lZGlh
L2R2Yi9kdmItY29yZS9kdmJfZnJvbnRlbmQuYyB8ICAgMzYgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysKIGluY2x1ZGUvbGludXgvZHZiL2Zyb250ZW5kLmggICAgICAgICAgICAgIHwgICAg
NCArKy0KIGluY2x1ZGUvbGludXgvZHZiL3ZlcnNpb24uaCAgICAgICAgICAgICAgIHwgICAgMiAr
LQogMyBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9mcm9udGVuZC5jIGIvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2Zyb250ZW5kLmMKaW5kZXggMmMwYWNkYi4uMTM2
OGQ4YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2Zyb250ZW5k
LmMKKysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2Zyb250ZW5kLmMKQEAgLTk3
Myw2ICs5NzMsOCBAQCBzdGF0aWMgc3RydWN0IGR0dl9jbWRzX2ggZHR2X2NtZHNbRFRWX01BWF9D
T01NQU5EICsgMV0gPSB7CiAJX0RUVl9DTUQoRFRWX0dVQVJEX0lOVEVSVkFMLCAwLCAwKSwKIAlf
RFRWX0NNRChEVFZfVFJBTlNNSVNTSU9OX01PREUsIDAsIDApLAogCV9EVFZfQ01EKERUVl9ISUVS
QVJDSFksIDAsIDApLAorCisJX0RUVl9DTUQoRFRWX0VOVU1fREVMU1lTLCAwLCAwKSwKIH07CiAK
IHN0YXRpYyB2b2lkIGR0dl9wcm9wZXJ0eV9kdW1wKHN0cnVjdCBkdHZfcHJvcGVydHkgKnR2cCkK
QEAgLTEyMDcsNiArMTIwOSwzNyBAQCBzdGF0aWMgaW50IGR2Yl9mcm9udGVuZF9pb2N0bF9sZWdh
Y3koc3RydWN0IGZpbGUgKmZpbGUsCiBzdGF0aWMgaW50IGR2Yl9mcm9udGVuZF9pb2N0bF9wcm9w
ZXJ0aWVzKHN0cnVjdCBmaWxlICpmaWxlLAogCQkJdW5zaWduZWQgaW50IGNtZCwgdm9pZCAqcGFy
Zyk7CiAKK3N0YXRpYyB2b2lkIGR0dl9zZXRfZGVmYXVsdF9kZWxpdmVyeV9jYXBzKGNvbnN0IHN0
cnVjdCBkdmJfZnJvbnRlbmQgKmZlLCBzdHJ1Y3QgZHR2X3Byb3BlcnR5ICpwKQoreworCWNvbnN0
IHN0cnVjdCBkdmJfZnJvbnRlbmRfaW5mbyAqaW5mbyA9ICZmZS0+b3BzLmluZm87CisJdTMyIG5j
YXBzID0gMDsKKworCXN3aXRjaCAoaW5mby0+dHlwZSkgeworCWNhc2UgRkVfUVBTSzoKKwkJcC0+
dS5idWZmZXIuZGF0YVtuY2FwcysrXSA9IFNZU19EVkJTOworCQlpZiAoaW5mby0+Y2FwcyAmIEZF
X0NBTl8yR19NT0RVTEFUSU9OKQorCQkJcC0+dS5idWZmZXIuZGF0YVtuY2FwcysrXSA9IFNZU19E
VkJTMjsKKwkJaWYgKGluZm8tPmNhcHMgJiBGRV9DQU5fVFVSQk9fRkVDKQorCQkJcC0+dS5idWZm
ZXIuZGF0YVtuY2FwcysrXSA9IFNZU19UVVJCTzsKKwkJYnJlYWs7CisJY2FzZSBGRV9RQU06CisJ
CXAtPnUuYnVmZmVyLmRhdGFbbmNhcHMrK10gPSBTWVNfRFZCQ19BTk5FWF9BQzsKKwkJYnJlYWs7
CisJY2FzZSBGRV9PRkRNOgorCQlwLT51LmJ1ZmZlci5kYXRhW25jYXBzKytdID0gU1lTX0RWQlQ7
CisJCWlmIChpbmZvLT5jYXBzICYgRkVfQ0FOXzJHX01PRFVMQVRJT04pCisJCQlwLT51LmJ1ZmZl
ci5kYXRhW25jYXBzKytdID0gU1lTX0RWQlQyOworCQlicmVhazsKKwljYXNlIEZFX0FUU0M6CisJ
CWlmIChpbmZvLT5jYXBzICYgKEZFX0NBTl84VlNCIHwgRkVfQ0FOXzE2VlNCKSkKKwkJCXAtPnUu
YnVmZmVyLmRhdGFbbmNhcHMrK10gPSBTWVNfQVRTQzsKKwkJaWYgKGluZm8tPmNhcHMgJiAoRkVf
Q0FOX1FBTV8xNiB8IEZFX0NBTl9RQU1fNjQgfCBGRV9DQU5fUUFNXzEyOCB8IEZFX0NBTl9RQU1f
MjU2KSkKKwkJCXAtPnUuYnVmZmVyLmRhdGFbbmNhcHMrK10gPSBTWVNfRFZCQ19BTk5FWF9COwor
CQlicmVhazsKKwl9CisJcC0+dS5idWZmZXIubGVuID0gbmNhcHM7Cit9CisKIHN0YXRpYyBpbnQg
ZHR2X3Byb3BlcnR5X3Byb2Nlc3NfZ2V0KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLAogCQkJCSAg
ICBzdHJ1Y3QgZHR2X3Byb3BlcnR5ICp0dnAsCiAJCQkJICAgIHN0cnVjdCBmaWxlICpmaWxlKQpA
QCAtMTIyNyw2ICsxMjYwLDkgQEAgc3RhdGljIGludCBkdHZfcHJvcGVydHlfcHJvY2Vzc19nZXQo
c3RydWN0IGR2Yl9mcm9udGVuZCAqZmUsCiAJfQogCiAJc3dpdGNoKHR2cC0+Y21kKSB7CisJY2Fz
ZSBEVFZfRU5VTV9ERUxTWVM6CisJCWR0dl9zZXRfZGVmYXVsdF9kZWxpdmVyeV9jYXBzKGZlLCB0
dnApOworCQlicmVhazsKIAljYXNlIERUVl9GUkVRVUVOQ1k6CiAJCXR2cC0+dS5kYXRhID0gYy0+
ZnJlcXVlbmN5OwogCQlicmVhazsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZHZiL2Zyb250
ZW5kLmggYi9pbmNsdWRlL2xpbnV4L2R2Yi9mcm9udGVuZC5oCmluZGV4IDFiMTA5NGMuLmY4MGI4
NjMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZHZiL2Zyb250ZW5kLmgKKysrIGIvaW5jbHVk
ZS9saW51eC9kdmIvZnJvbnRlbmQuaApAQCAtMzE2LDcgKzMxNiw5IEBAIHN0cnVjdCBkdmJfZnJv
bnRlbmRfZXZlbnQgewogCiAjZGVmaW5lIERUVl9EVkJUMl9QTFBfSUQJNDMKIAotI2RlZmluZSBE
VFZfTUFYX0NPTU1BTkQJCQkJRFRWX0RWQlQyX1BMUF9JRAorI2RlZmluZSBEVFZfRU5VTV9ERUxT
WVMJCTQ0CisKKyNkZWZpbmUgRFRWX01BWF9DT01NQU5ECQkJCURUVl9FTlVNX0RFTFNZUwogCiB0
eXBlZGVmIGVudW0gZmVfcGlsb3QgewogCVBJTE9UX09OLApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aW51eC9kdmIvdmVyc2lvbi5oIGIvaW5jbHVkZS9saW51eC9kdmIvdmVyc2lvbi5oCmluZGV4IDY2
NTk0YjEuLjA1NTllMmIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZHZiL3ZlcnNpb24uaAor
KysgYi9pbmNsdWRlL2xpbnV4L2R2Yi92ZXJzaW9uLmgKQEAgLTI0LDYgKzI0LDYgQEAKICNkZWZp
bmUgX0RWQlZFUlNJT05fSF8KIAogI2RlZmluZSBEVkJfQVBJX1ZFUlNJT04gNQotI2RlZmluZSBE
VkJfQVBJX1ZFUlNJT05fTUlOT1IgNAorI2RlZmluZSBEVkJfQVBJX1ZFUlNJT05fTUlOT1IgNQog
CiAjZW5kaWYgLypfRFZCVkVSU0lPTl9IXyovCi0tIAoxLjcuMQoK
--0016e6dee805a310a604b1b708f8--
