Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1KVAbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 19:31:21 -0500
Received: by iage36 with SMTP id e36so7989923iag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 16:31:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ECAEB37.4040404@linuxtv.org>
References: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
	<4ECAEB37.4040404@linuxtv.org>
Date: Mon, 21 Nov 2011 19:31:20 -0500
Message-ID: <CAOcJUbyPoqNku_Hu6ZLTxDb_EgV2P+Dui1Nq46LxUgtzycU_CQ@mail.gmail.com>
Subject: Re: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities
 to identify devices correctly.
From: Michael Krufky <mkrufky@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: multipart/mixed; boundary=90e6ba6e86b82602fd04b247ecbb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--90e6ba6e86b82602fd04b247ecbb
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Nov 21, 2011 at 7:22 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 21.11.2011 22:05, Manu Abraham wrote:
>> Hi,
>>
>> As discussed prior, the following changes help to advertise a
>> frontend's delivery system capabilities.
>>
>> Sending out the patches as they are being worked out.
>>
>> The following patch series are applied against media_tree.git
>> after the following commit
>
> Patches 7, 9 and 10 semm to be unneeded, because they just set the defaults.
>
> Regarding the patches adding SYS_DSS: If I remember correctly, DSS
> doesn't use MPEG-2 TS packets. Do we have a way to deliver DSS payload
> to userspace?
>
> Regards,
> Andreas

I need this as well for delivering ATSC-MH raw payload to userspace.
I propose the following patch (attached)

--90e6ba6e86b82602fd04b247ecbb
Content-Type: application/octet-stream;
	name="dvb-demux-add-functionality-to-send-raw-payload-to-t.patch"
Content-Disposition: attachment;
	filename="dvb-demux-add-functionality-to-send-raw-payload-to-t.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gva653qs0

RnJvbSAwMzIwYTdlMTBlYmIzNDNkMGY5NjEyMDM1ZGQwOTkyNzNkOTFmYzE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTWljaGFlbCBLcnVma3kgPG1rcnVma3lAa2VybmVsbGFicy5j
b20+DQpEYXRlOiBTYXQsIDI3IEF1ZyAyMDExIDE3OjQ2OjM3IC0wNDAwDQpTdWJqZWN0OiBbUEFU
Q0ggMDUvMTNdIGR2Yi1kZW11eDogYWRkIGZ1bmN0aW9uYWxpdHkgdG8gc2VuZCByYXcgcGF5bG9h
ZCB0byB0aGUgZHZyIGRldmljZQ0KDQpJZiB5b3VyIGRyaXZlciBuZWVkcyB0byBkZWxpdmVyIHRo
ZSByYXcgcGF5bG9hZCB0byB1c2Vyc3BhY2Ugd2l0aG91dA0KcGFzc2luZyB0aHJvdWdoIHRoZSBr
ZXJuZWwgZGVtdXgsIHVzZSBmdW5jdGlvbjogZHZiX2RteF9zd2ZpbHRlcl9yYXcNCg0KU2lnbmVk
LW9mZi1ieTogTWljaGFlbCBLcnVma3kgPG1rcnVma3lAa2VybmVsbGFicy5jb20+DQotLS0NCiBk
cml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZGVtdXguYyB8ICAgMTAgKysrKysrKysrKw0K
IGRyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9kZW11eC5oIHwgICAgMiArKw0KIDIgZmls
ZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9kZW11eC5jIGIvZHJpdmVycy9tZWRp
YS9kdmIvZHZiLWNvcmUvZHZiX2RlbXV4LmMNCmluZGV4IGZhYTM2NzEuLmQ4MjQ2OWYgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZGVtdXguYw0KKysrIGIvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2RlbXV4LmMNCkBAIC01NjgsNiArNTY4LDE2IEBA
IHZvaWQgZHZiX2RteF9zd2ZpbHRlcl8yMDQoc3RydWN0IGR2Yl9kZW11eCAqZGVtdXgsIGNvbnN0
IHU4ICpidWYsIHNpemVfdCBjb3VudCkNCiB9DQogRVhQT1JUX1NZTUJPTChkdmJfZG14X3N3Zmls
dGVyXzIwNCk7DQogDQordm9pZCBkdmJfZG14X3N3ZmlsdGVyX3JhdyhzdHJ1Y3QgZHZiX2RlbXV4
ICpkZW11eCwgY29uc3QgdTggKmJ1Ziwgc2l6ZV90IGNvdW50KQ0KK3sNCisJc3Bpbl9sb2NrKCZk
ZW11eC0+bG9jayk7DQorDQorCWRlbXV4LT5mZWVkLT5jYi50cyhidWYsIGNvdW50LCBOVUxMLCAw
LCAmZGVtdXgtPmZlZWQtPmZlZWQudHMsIERNWF9PSyk7DQorDQorCXNwaW5fdW5sb2NrKCZkZW11
eC0+bG9jayk7DQorfQ0KK0VYUE9SVF9TWU1CT0woZHZiX2RteF9zd2ZpbHRlcl9yYXcpOw0KKw0K
IHN0YXRpYyBzdHJ1Y3QgZHZiX2RlbXV4X2ZpbHRlciAqZHZiX2RteF9maWx0ZXJfYWxsb2Moc3Ry
dWN0IGR2Yl9kZW11eCAqZGVtdXgpDQogew0KIAlpbnQgaTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZGVtdXguaCBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1j
b3JlL2R2Yl9kZW11eC5oDQppbmRleCBhN2Q4NzZmLi5mYTcxODhhIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLWNvcmUvZHZiX2RlbXV4LmgNCisrKyBiL2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi1jb3JlL2R2Yl9kZW11eC5oDQpAQCAtMTQ1LDUgKzE0NSw3IEBAIHZvaWQgZHZiX2Rt
eF9zd2ZpbHRlcl9wYWNrZXRzKHN0cnVjdCBkdmJfZGVtdXggKmR2YmRteCwgY29uc3QgdTggKmJ1
ZiwNCiB2b2lkIGR2Yl9kbXhfc3dmaWx0ZXIoc3RydWN0IGR2Yl9kZW11eCAqZGVtdXgsIGNvbnN0
IHU4ICpidWYsIHNpemVfdCBjb3VudCk7DQogdm9pZCBkdmJfZG14X3N3ZmlsdGVyXzIwNChzdHJ1
Y3QgZHZiX2RlbXV4ICpkZW11eCwgY29uc3QgdTggKmJ1ZiwNCiAJCQkgIHNpemVfdCBjb3VudCk7
DQordm9pZCBkdmJfZG14X3N3ZmlsdGVyX3JhdyhzdHJ1Y3QgZHZiX2RlbXV4ICpkZW11eCwgY29u
c3QgdTggKmJ1ZiwNCisJCQkgIHNpemVfdCBjb3VudCk7DQogDQogI2VuZGlmIC8qIF9EVkJfREVN
VVhfSF8gKi8NCi0tIA0KMS43LjAuNA0KDQo=
--90e6ba6e86b82602fd04b247ecbb--
