Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1KHAyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 19:54:22 -0500
Received: by wyh15 with SMTP id 15so5093735wyh.19
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2011 16:54:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EB7CD59.1010303@redhat.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
	<CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
	<20111020170811.GD7530@jannau.net>
	<CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
	<CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com>
	<CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
	<4EB7CD59.1010303@redhat.com>
Date: Mon, 7 Nov 2011 19:54:20 -0500
Message-ID: <CAOTqeXoavdYLkfp+FRLj3v24z2m+xZHiKhnOOiHJhZ+Y858y9w@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Taylor Ralph <taylor.ralph@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151758b3989ad48c04b12e9c09
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00151758b3989ad48c04b12e9c09
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 7, 2011 at 7:21 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 21-10-2011 01:33, Taylor Ralph escreveu:
>> On Thu, Oct 20, 2011 at 3:26 PM, Taylor Ralph <taylor.ralph@gmail.com> w=
rote:
>>> On Thu, Oct 20, 2011 at 2:14 PM, Devin Heitmueller
>>> <dheitmueller@kernellabs.com> wrote:
>>>> On Thu, Oct 20, 2011 at 1:08 PM, Janne Grunau <j@jannau.net> wrote:
>>>>> I think such scenario is unlikely but I don't know it for sure and
>>>>> I don't want to force anyone to test every firmware version.
>>>>> Ignoring them for firmware version < 16 should be safe since we assum=
e
>>>>> they had no effect. Returning -EINVAL might break API-ignoring
>>>>> applications written with the HD PVR in mind but I think it's a bette=
r
>>>>> approach than silently ignoring those controls.
>>>>
>>>> At this point, let's just make it so that the old behavior is
>>>> unchanged for old firmwares, meaning from both an API standpoint as
>>>> well as what the values are. =A0At some point if somebody cares enough
>>>> to go back and fix the support so that the controls actually work with
>>>> old firmwares, they can take that up as a separate task. =A0In reality=
,
>>>> it is likely that nobody will ever do that, as the "easy answer" is
>>>> just to upgrade to firmware 16.
>>>>
>>>> Taylor, could you please tweak your patch to that effect and resubmit?
>>>>
>>>
>>> Sure, I'll try to get to it tonight and have it tested.
>>>
>>
>> OK, I've updated the patch per your requests. I made this patch
>> against the latest kernel source but I'm unable to test since my
>> 2.6.32 kernel has symbol issues with the new v4l code.
>
> Please, add your Signed-off-by: to the patch. This is a requirement for
> it to be accepted upstream[1].
>
> Thanks,
> Mauro
>
> [1] See: http://linuxtv.org/wiki/index.php/Development:_Submitting_Patche=
s#Developer.27s_Certificate_of_Origin_1.1
>
>>
>> Regards.
>> --
>> Taylor
>
>

Sorry about that. The updated patch is attached.

Thanks.
--
Taylor

--00151758b3989ad48c04b12e9c09
Content-Type: application/octet-stream; name="hdpvr_v3.diff"
Content-Disposition: attachment; filename="hdpvr_v3.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_guq6scbi0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIvaGRwdnItY29yZS5jIGIvZHJp
dmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3JlLmMKaW5kZXggNDQxZGFjZi4uNjg3Mjgy
ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3JlLmMKKysr
IGIvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3JlLmMKQEAgLTE1NCwxMCArMTU0
LDIwIEBAIHN0YXRpYyBpbnQgZGV2aWNlX2F1dGhvcml6YXRpb24oc3RydWN0IGhkcHZyX2Rldmlj
ZSAqZGV2KQogCX0KICNlbmRpZgogCisJZGV2LT5md192ZXIgPSBkZXYtPnVzYmNfYnVmWzFdOwor
CiAJdjRsMl9pbmZvKCZkZXYtPnY0bDJfZGV2LCAiZmlybXdhcmUgdmVyc2lvbiAweCV4IGRhdGVk
ICVzXG4iLAotCQkJICBkZXYtPnVzYmNfYnVmWzFdLCAmZGV2LT51c2JjX2J1ZlsyXSk7CisJCQkg
IGRldi0+ZndfdmVyLCAmZGV2LT51c2JjX2J1ZlsyXSk7CisKKwlpZiAoZGV2LT5md192ZXIgPiAw
eDE1KSB7CisJCWRldi0+b3B0aW9ucy5icmlnaHRuZXNzCT0gMHg4MDsKKwkJZGV2LT5vcHRpb25z
LmNvbnRyYXN0CT0gMHg0MDsKKwkJZGV2LT5vcHRpb25zLmh1ZQk9IDB4ZjsKKwkJZGV2LT5vcHRp
b25zLnNhdHVyYXRpb24JPSAweDQwOworCQlkZXYtPm9wdGlvbnMuc2hhcnBuZXNzCT0gMHg4MDsK
Kwl9CiAKLQlzd2l0Y2ggKGRldi0+dXNiY19idWZbMV0pIHsKKwlzd2l0Y2ggKGRldi0+ZndfdmVy
KSB7CiAJY2FzZSBIRFBWUl9GSVJNV0FSRV9WRVJTSU9OOgogCQlkZXYtPmZsYWdzICY9IH5IRFBW
Ul9GTEFHX0FDM19DQVA7CiAJCWJyZWFrOwpAQCAtMTY5LDcgKzE3OSw3IEBAIHN0YXRpYyBpbnQg
ZGV2aWNlX2F1dGhvcml6YXRpb24oc3RydWN0IGhkcHZyX2RldmljZSAqZGV2KQogCWRlZmF1bHQ6
CiAJCXY0bDJfaW5mbygmZGV2LT52NGwyX2RldiwgInVudGVzdGVkIGZpcm13YXJlLCB0aGUgZHJp
dmVyIG1pZ2h0IgogCQkJICAiIG5vdCB3b3JrLlxuIik7Ci0JCWlmIChkZXYtPnVzYmNfYnVmWzFd
ID49IEhEUFZSX0ZJUk1XQVJFX1ZFUlNJT05fQUMzKQorCQlpZiAoZGV2LT5md192ZXIgPj0gSERQ
VlJfRklSTVdBUkVfVkVSU0lPTl9BQzMpCiAJCQlkZXYtPmZsYWdzIHw9IEhEUFZSX0ZMQUdfQUMz
X0NBUDsKIAkJZWxzZQogCQkJZGV2LT5mbGFncyAmPSB+SERQVlJfRkxBR19BQzNfQ0FQOwpAQCAt
MjcwLDYgKzI4MCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaGRwdnJfb3B0aW9ucyBoZHB2cl9k
ZWZhdWx0X29wdGlvbnMgPSB7CiAJLmJpdHJhdGVfbW9kZQk9IEhEUFZSX0NPTlNUQU5ULAogCS5n
b3BfbW9kZQk9IEhEUFZSX1NJTVBMRV9JRFJfR09QLAogCS5hdWRpb19jb2RlYwk9IFY0TDJfTVBF
R19BVURJT19FTkNPRElOR19BQUMsCisJLyogb3JpZ2luYWwgcGljdHVyZSBjb250cm9scyBmb3Ig
ZmlybXdhcmUgdmVyc2lvbiA8PSAweDE1ICovCisJLyogdXBkYXRlZCBpbiBkZXZpY2VfYXV0aG9y
aXphdGlvbigpIGZvciBuZXdlciBmaXJtd2FyZSAqLwogCS5icmlnaHRuZXNzCT0gMHg4NiwKIAku
Y29udHJhc3QJPSAweDgwLAogCS5odWUJCT0gMHg4MCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vaGRwdnIvaGRwdnItdmlkZW8uYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIv
aGRwdnItdmlkZW8uYwppbmRleCAwODdmN2MwLi4zNmJiMDU3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L21lZGlhL3ZpZGVvL2hkcHZyL2hkcHZyLXZpZGVvLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRl
by9oZHB2ci9oZHB2ci12aWRlby5jCkBAIC03MjIsMjEgKzcyMiwzOSBAQCBzdGF0aWMgY29uc3Qg
czMyIHN1cHBvcnRlZF92NGwyX2N0cmxzW10gPSB7CiB9OwogCiBzdGF0aWMgaW50IGZpbGxfcXVl
cnljdHJsKHN0cnVjdCBoZHB2cl9vcHRpb25zICpvcHQsIHN0cnVjdCB2NGwyX3F1ZXJ5Y3RybCAq
cWMsCi0JCQkgIGludCBhYzMpCisJCQkgIGludCBhYzMsIGludCBmd192ZXIpCiB7CiAJaW50IGVy
cjsKIAorCWlmIChmd192ZXIgPiAweDE1KSB7CisJCXN3aXRjaCAocWMtPmlkKSB7CisJCWNhc2Ug
VjRMMl9DSURfQlJJR0hUTkVTUzoKKwkJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywg
MHgwLCAweGZmLCAxLCAweDgwKTsKKwkJY2FzZSBWNEwyX0NJRF9DT05UUkFTVDoKKwkJCXJldHVy
biB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDQwKTsKKwkJY2FzZSBW
NEwyX0NJRF9TQVRVUkFUSU9OOgorCQkJcmV0dXJuIHY0bDJfY3RybF9xdWVyeV9maWxsKHFjLCAw
eDAsIDB4ZmYsIDEsIDB4NDApOworCQljYXNlIFY0TDJfQ0lEX0hVRToKKwkJCXJldHVybiB2NGwy
X2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweDFlLCAxLCAweGYpOworCQljYXNlIFY0TDJfQ0lE
X1NIQVJQTkVTUzoKKwkJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZm
LCAxLCAweDgwKTsKKwkJfQorCX0gZWxzZSB7CisJCXN3aXRjaCAocWMtPmlkKSB7CisJCWNhc2Ug
VjRMMl9DSURfQlJJR0hUTkVTUzoKKwkJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywg
MHgwLCAweGZmLCAxLCAweDg2KTsKKwkJY2FzZSBWNEwyX0NJRF9DT05UUkFTVDoKKwkJCXJldHVy
biB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDgwKTsKKwkJY2FzZSBW
NEwyX0NJRF9TQVRVUkFUSU9OOgorCQkJcmV0dXJuIHY0bDJfY3RybF9xdWVyeV9maWxsKHFjLCAw
eDAsIDB4ZmYsIDEsIDB4ODApOworCQljYXNlIFY0TDJfQ0lEX0hVRToKKwkJCXJldHVybiB2NGwy
X2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDgwKTsKKwkJY2FzZSBWNEwyX0NJ
RF9TSEFSUE5FU1M6CisJCQlyZXR1cm4gdjRsMl9jdHJsX3F1ZXJ5X2ZpbGwocWMsIDB4MCwgMHhm
ZiwgMSwgMHg4MCk7CisJCX0KKwl9CisKIAlzd2l0Y2ggKHFjLT5pZCkgewotCWNhc2UgVjRMMl9D
SURfQlJJR0hUTkVTUzoKLQkJcmV0dXJuIHY0bDJfY3RybF9xdWVyeV9maWxsKHFjLCAweDAsIDB4
ZmYsIDEsIDB4ODYpOwotCWNhc2UgVjRMMl9DSURfQ09OVFJBU1Q6Ci0JCXJldHVybiB2NGwyX2N0
cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDgwKTsKLQljYXNlIFY0TDJfQ0lEX1NB
VFVSQVRJT046Ci0JCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAx
LCAweDgwKTsKLQljYXNlIFY0TDJfQ0lEX0hVRToKLQkJcmV0dXJuIHY0bDJfY3RybF9xdWVyeV9m
aWxsKHFjLCAweDAsIDB4ZmYsIDEsIDB4ODApOwotCWNhc2UgVjRMMl9DSURfU0hBUlBORVNTOgot
CQlyZXR1cm4gdjRsMl9jdHJsX3F1ZXJ5X2ZpbGwocWMsIDB4MCwgMHhmZiwgMSwgMHg4MCk7CiAJ
Y2FzZSBWNEwyX0NJRF9NUEVHX0FVRElPX0VOQ09ESU5HOgogCQlyZXR1cm4gdjRsMl9jdHJsX3F1
ZXJ5X2ZpbGwoCiAJCQlxYywgVjRMMl9NUEVHX0FVRElPX0VOQ09ESU5HX0FBQywKQEAgLTc5NCw3
ICs4MTIsOCBAQCBzdGF0aWMgaW50IHZpZGlvY19xdWVyeWN0cmwoc3RydWN0IGZpbGUgKmZpbGUs
IHZvaWQgKnByaXZhdGVfZGF0YSwKIAogCQlpZiAocWMtPmlkID09IHN1cHBvcnRlZF92NGwyX2N0
cmxzW2ldKQogCQkJcmV0dXJuIGZpbGxfcXVlcnljdHJsKCZkZXYtPm9wdGlvbnMsIHFjLAotCQkJ
CQkgICAgICBkZXYtPmZsYWdzICYgSERQVlJfRkxBR19BQzNfQ0FQKTsKKwkJCQkJICAgICAgZGV2
LT5mbGFncyAmIEhEUFZSX0ZMQUdfQUMzX0NBUCwKKwkJCQkJICAgICAgZGV2LT5md192ZXIpOwog
CiAJCWlmIChxYy0+aWQgPCBzdXBwb3J0ZWRfdjRsMl9jdHJsc1tpXSkKIAkJCWJyZWFrOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci5oIGIvZHJpdmVycy9tZWRp
YS92aWRlby9oZHB2ci9oZHB2ci5oCmluZGV4IGQ2NDM5ZGIuLmZlYTNjNjkgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIvaGRwdnIuaAorKysgYi9kcml2ZXJzL21lZGlhL3Zp
ZGVvL2hkcHZyL2hkcHZyLmgKQEAgLTExMyw2ICsxMTMsNyBAQCBzdHJ1Y3QgaGRwdnJfZGV2aWNl
IHsKIAkvKiB1c2IgY29udHJvbCB0cmFuc2ZlciBidWZmZXIgYW5kIGxvY2sgKi8KIAlzdHJ1Y3Qg
bXV0ZXgJCXVzYmNfbXV0ZXg7CiAJdTgJCQkqdXNiY19idWY7CisJdTgJCQlmd192ZXI7CiB9Owog
CiBzdGF0aWMgaW5saW5lIHN0cnVjdCBoZHB2cl9kZXZpY2UgKnRvX2hkcHZyX2RldihzdHJ1Y3Qg
djRsMl9kZXZpY2UgKnY0bDJfZGV2KQoKU2lnbmVkLW9mZi1ieTogVGF5bG9yIFJhbHBoIDx0cmFs
cGhAbXl0aHR2Lm9yZz4K
--00151758b3989ad48c04b12e9c09--
