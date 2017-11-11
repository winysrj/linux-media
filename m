Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:49215 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdKKTGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 14:06:40 -0500
Received: by mail-qt0-f169.google.com with SMTP id p44so5022424qtj.6
        for <linux-media@vger.kernel.org>; Sat, 11 Nov 2017 11:06:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171111180159.fb33mc2t467ygfqw@gofer.mess.org>
References: <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org>
 <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
 <20171023185750.5m5qo575myogzbhz@gofer.mess.org> <CACG2urzH5dAtnasGfjiK1Y8owGcsn0VtRSEWX75A6mb0pyuSRw@mail.gmail.com>
 <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org> <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan> <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
 <20171111105643.ozwukzmdhalxhoho@gofer.mess.org> <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
 <20171111180159.fb33mc2t467ygfqw@gofer.mess.org>
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Sat, 11 Nov 2017 20:06:38 +0100
Message-ID: <CACG2uryHHu-vvHj0B1wGRYZuczB5_8cbD3LBscaBmbN-LFJQMg@mail.gmail.com>
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="94eb2c03457eac2b30055db9bcbd"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--94eb2c03457eac2b30055db9bcbd
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

I hope this one will be okay.


2017-11-11 19:01 GMT+01:00 Sean Young <sean@mess.org>:
> Hi Laurent,
>
> On Sat, Nov 11, 2017 at 06:53:54PM +0100, Laurent Caumont wrote:
>> Hi Sean,
>>
>> I just realized that files in media_build/linux/driver are not
>> associate with a git repository. They are retrieved by the build
>> command.
>> So, I cloned the linux-stable repository to generate the patch.
>
> Great, thank you.
>
> We need a Signed-off-by: line to accept your patch, see part 11 of
>
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> Thanks,
>
> Sean

--94eb2c03457eac2b30055db9bcbd
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-media-dvb-i2c-transfers-over-usb-use-kmalloc-instead.patch"
Content-Disposition: attachment;
	filename="0001-media-dvb-i2c-transfers-over-usb-use-kmalloc-instead.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j9vpcbw70

RnJvbSBiZjQ4Y2I4OTg4YTAzMzUwMzhlOGRmMWE0MGYxZDFiMmNmNDIyNWQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMYXVyZW50IENhdW1vbnQgPGxjYXVtb250MkBnbWFpbC5jb20+
CkRhdGU6IFNhdCwgMTEgTm92IDIwMTcgMTg6NDQ6NDYgKzAxMDAKU3ViamVjdDogW1BBVENIXSBt
ZWRpYTogZHZiOiBpMmMgdHJhbnNmZXJzIG92ZXIgdXNiIC0gdXNlIGttYWxsb2MgaW5zdGVhZAog
c3RhY2sgU2lnbmVkLW9mZi1ieTogTGF1cmVudCBDYXVtb250IDxsY2F1bW9udDJAZ21haWwuY29t
PgoKLS0tCiBkcml2ZXJzL21lZGlhL3VzYi9kdmItdXNiL2RpYnVzYi1jb21tb24uYyB8IDIyICsr
KysrKysrKysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdXNiL2R2Yi11c2IvZGli
dXNiLWNvbW1vbi5jIGIvZHJpdmVycy9tZWRpYS91c2IvZHZiLXVzYi9kaWJ1c2ItY29tbW9uLmMK
aW5kZXggODIwN2U2OTAuLmUxYzMxMzgxIDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3VzYi9k
dmItdXNiL2RpYnVzYi1jb21tb24uYworKysgYi9kcml2ZXJzL21lZGlhL3VzYi9kdmItdXNiL2Rp
YnVzYi1jb21tb24uYwpAQCAtMjIzLDggKzIyMywyNiBAQCBFWFBPUlRfU1lNQk9MKGRpYnVzYl9p
MmNfYWxnbyk7CiAKIGludCBkaWJ1c2JfcmVhZF9lZXByb21fYnl0ZShzdHJ1Y3QgZHZiX3VzYl9k
ZXZpY2UgKmQsIHU4IG9mZnMsIHU4ICp2YWwpCiB7Ci0JdTggd2J1ZlsxXSA9IHsgb2ZmcyB9Owot
CXJldHVybiBkaWJ1c2JfaTJjX21zZyhkLCAweDUwLCB3YnVmLCAxLCB2YWwsIDEpOworCSAgdTgg
KndidWY7CisJICB1OCAqcmJ1ZjsKKwkgIGludCByYzsKKwkgIAorCSAgcmJ1ZiA9IGttYWxsb2Mo
MSwgR0ZQX0tFUk5FTCk7CisJICBpZiAoIXJidWYpCisJICAgIHJldHVybiAtRU5PTUVNOworCSAK
KwkgIHdidWYgPSBrbWFsbG9jKDEsIEdGUF9LRVJORUwpOworCSAgaWYgKCF3YnVmKQorCSAgICBy
ZXR1cm4gLUVOT01FTTsKKwkgIAorICAgICAgICAgKndidWYgPSBvZmZzOworCisJIHJjID0gZGli
dXNiX2kyY19tc2coZCwgMHg1MCwgd2J1ZiwgMSwgcmJ1ZiwgMSk7CisgICAgICAgICBrZnJlZSh3
YnVmKTsKKwkgKnZhbCA9ICpyYnVmOworCSBrZnJlZShyYnVmKTsKKwkgIAorCXJldHVybiByYzsK
IH0KIEVYUE9SVF9TWU1CT0woZGlidXNiX3JlYWRfZWVwcm9tX2J5dGUpOwogCi0tIAoyLjE0LjEK
Cg==
--94eb2c03457eac2b30055db9bcbd--
