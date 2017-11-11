Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:52155 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdKKRxz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 12:53:55 -0500
Received: by mail-qk0-f193.google.com with SMTP id f63so987068qke.8
        for <linux-media@vger.kernel.org>; Sat, 11 Nov 2017 09:53:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171111105643.ozwukzmdhalxhoho@gofer.mess.org>
References: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
 <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org> <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
 <20171023185750.5m5qo575myogzbhz@gofer.mess.org> <CACG2urzH5dAtnasGfjiK1Y8owGcsn0VtRSEWX75A6mb0pyuSRw@mail.gmail.com>
 <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org> <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan> <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
 <20171111105643.ozwukzmdhalxhoho@gofer.mess.org>
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Sat, 11 Nov 2017 18:53:54 +0100
Message-ID: <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="001a1147b4ca8a5e94055db8b802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a1147b4ca8a5e94055db8b802
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

I just realized that files in media_build/linux/driver are not
associate with a git repository. They are retrieved by the build
command.
So, I cloned the linux-stable repository to generate the patch.

Regards,
Laurent

2017-11-11 11:56 GMT+01:00 Sean Young <sean@mess.org>:
> Hi Laurent,
>
> On Fri, Nov 10, 2017 at 09:33:58PM +0100, Laurent Caumont wrote:
>> Hi Mauro,
>>
>> I could send you a patch but my git doesn't see the modification I
>> made, so it's unable to generate a patch.
>> I don't know if it's a git issue on ubunu 17.10 or if it's the way the
>> repository was created.
>
> The difference might be in the git index (or not in it). If you send a
> Signed-off-by: Laurent etc line then I'm happy to handle the patch
> generation.
>
> Thanks
>
> Sean

--001a1147b4ca8a5e94055db8b802
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-media-dvb-i2c-transfers-over-usb-use-kmalloc-instead.patch"
Content-Disposition: attachment;
	filename="0001-media-dvb-i2c-transfers-over-usb-use-kmalloc-instead.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j9vmkzvh0

RnJvbSAwM2NlYmQ0NzhiODA2NzcyNTJhMGY0OGQ3MWQwZGUwNWU2YzgyNzQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMYXVyZW50IENhdW1vbnQgPGxjYXVtb250MkBnbWFpbC5jb20+
CkRhdGU6IFNhdCwgMTEgTm92IDIwMTcgMTg6NDQ6NDYgKzAxMDAKU3ViamVjdDogW1BBVENIXSBt
ZWRpYTogZHZiOiBpMmMgdHJhbnNmZXJzIG92ZXIgdXNiIC0gdXNlIGttYWxsb2MgaW5zdGVhZAog
c3RhY2sKCi0tLQogZHJpdmVycy9tZWRpYS91c2IvZHZiLXVzYi9kaWJ1c2ItY29tbW9uLmMgfCAy
MiArKysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3VzYi9kdmItdXNi
L2RpYnVzYi1jb21tb24uYyBiL2RyaXZlcnMvbWVkaWEvdXNiL2R2Yi11c2IvZGlidXNiLWNvbW1v
bi5jCmluZGV4IDgyMDdlNjkwLi5lMWMzMTM4MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS91
c2IvZHZiLXVzYi9kaWJ1c2ItY29tbW9uLmMKKysrIGIvZHJpdmVycy9tZWRpYS91c2IvZHZiLXVz
Yi9kaWJ1c2ItY29tbW9uLmMKQEAgLTIyMyw4ICsyMjMsMjYgQEAgRVhQT1JUX1NZTUJPTChkaWJ1
c2JfaTJjX2FsZ28pOwogCiBpbnQgZGlidXNiX3JlYWRfZWVwcm9tX2J5dGUoc3RydWN0IGR2Yl91
c2JfZGV2aWNlICpkLCB1OCBvZmZzLCB1OCAqdmFsKQogewotCXU4IHdidWZbMV0gPSB7IG9mZnMg
fTsKLQlyZXR1cm4gZGlidXNiX2kyY19tc2coZCwgMHg1MCwgd2J1ZiwgMSwgdmFsLCAxKTsKKwkg
IHU4ICp3YnVmOworCSAgdTggKnJidWY7CisJICBpbnQgcmM7CisJICAKKwkgIHJidWYgPSBrbWFs
bG9jKDEsIEdGUF9LRVJORUwpOworCSAgaWYgKCFyYnVmKQorCSAgICByZXR1cm4gLUVOT01FTTsK
KwkgCisJICB3YnVmID0ga21hbGxvYygxLCBHRlBfS0VSTkVMKTsKKwkgIGlmICghd2J1ZikKKwkg
ICAgcmV0dXJuIC1FTk9NRU07CisJICAKKyAgICAgICAgICp3YnVmID0gb2ZmczsKKworCSByYyA9
IGRpYnVzYl9pMmNfbXNnKGQsIDB4NTAsIHdidWYsIDEsIHJidWYsIDEpOworICAgICAgICAga2Zy
ZWUod2J1Zik7CisJICp2YWwgPSAqcmJ1ZjsKKwkga2ZyZWUocmJ1Zik7CisJICAKKwlyZXR1cm4g
cmM7CiB9CiBFWFBPUlRfU1lNQk9MKGRpYnVzYl9yZWFkX2VlcHJvbV9ieXRlKTsKIAotLSAKMi4x
NC4xCgo=
--001a1147b4ca8a5e94055db8b802--
