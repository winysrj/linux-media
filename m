Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33511 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZLSRLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2009 12:11:52 -0500
MIME-Version: 1.0
In-Reply-To: <20091218191859.ca78c2f1.randy.dunlap@oracle.com>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
	 <20091218191859.ca78c2f1.randy.dunlap@oracle.com>
Date: Sat, 19 Dec 2009 21:11:50 +0400
Message-ID: <1a297b360912190911v77b8519dtd5a93556a8693dd9@mail.gmail.com>
Subject: Re: linux-next: Tree for December 19 (media/mantis)
From: Manu Abraham <abraham.manu@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
Content-Type: multipart/mixed; boundary=0016e6d97735bef1f3047b17f338
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016e6d97735bef1f3047b17f338
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 19, 2009 at 7:18 AM, Randy Dunlap <randy.dunlap@oracle.com> wro=
te:
> On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> I said:
>> > News: =A0there will be no linux-next releases until at least Dec 24 an=
d,
>> > more likely, Dec 29. =A0Have a Merry Christmas and take a break. =A0:-=
)
>>
>> Well, I decided I had time for one more so it will be based in -rc1).
>>
>> This one has not had the build testing *between* merges, but has had all
>> the normal build testing at the end. =A0Since the latter testing showed =
no
>> problems, this just means that there may be more unbisectable points in
>> the tree (but that is unlikely).
>
>
>
> ERROR: "ir_input_register" [drivers/media/dvb/mantis/mantis_core.ko] unde=
fined!
> ERROR: "ir_input_unregister" [drivers/media/dvb/mantis/mantis_core.ko] un=
defined!
> ERROR: "ir_input_init" [drivers/media/dvb/mantis/mantis_core.ko] undefine=
d!
> ERROR: "input_free_device" [drivers/media/dvb/mantis/mantis_core.ko] unde=
fined!
> ERROR: "input_allocate_device" [drivers/media/dvb/mantis/mantis_core.ko] =
undefined!
>
>
>
> CONFIG_INPUT=3Dn

Attached patch to fix the issue.

Fix Input dependency for Mantis

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

Regards,
Manu

--0016e6d97735bef1f3047b17f338
Content-Type: text/x-patch; charset=US-ASCII; name="fix-mantis-input-dependency.patch"
Content-Disposition: attachment;
	filename="fix-mantis-input-dependency.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3encs4j0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL21hbnRpcy9LY29uZmlnIGIvZHJpdmVycy9t
ZWRpYS9kdmIvbWFudGlzL0tjb25maWcKaW5kZXggZjkyMTljZC4uZjdiNzJhMyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL0tjb25maWcKKysrIGIvZHJpdmVycy9tZWRpYS9k
dmIvbWFudGlzL0tjb25maWcKQEAgLTEsNiArMSw2IEBACiBjb25maWcgTUFOVElTX0NPUkUKIAl0
cmlzdGF0ZSAiTWFudGlzL0hvcHBlciBQQ0kgYnJpZGdlIGJhc2VkIGRldmljZXMiCi0JZGVwZW5k
cyBvbiBQQ0kgJiYgSTJDCisJZGVwZW5kcyBvbiBQQ0kgJiYgSTJDICYmIElOUFVUCiAKIAloZWxw
CiAJICBTdXBwb3J0IGZvciBQQ0kgY2FyZHMgYmFzZWQgb24gdGhlIE1hbnRpcyBhbmQgSG9wcGVy
IFBDaSBicmlkZ2UuCg==
--0016e6d97735bef1f3047b17f338--
