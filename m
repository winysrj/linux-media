Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:57510 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2LTDTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 22:19:55 -0500
Received: by mail-qa0-f42.google.com with SMTP id hg5so4897552qab.15
        for <linux-media@vger.kernel.org>; Wed, 19 Dec 2012 19:19:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPM=9twKSyYzg_Fv6JQM9tBCATgH_z8+TGPmkv_ritHH4XYOUg@mail.gmail.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
	<CAPM=9twKSyYzg_Fv6JQM9tBCATgH_z8+TGPmkv_ritHH4XYOUg@mail.gmail.com>
Date: Thu, 20 Dec 2012 13:13:37 +1000
Message-ID: <CAPM=9twwm59-Aa_7UWiBPWrXZbOV62HZUZJJe3oUwNGPwWAQPw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Add debugfs support
From: Dave Airlie <airlied@gmail.com>
To: sumit.semwal@ti.com
Cc: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=005045015b6e00128604d1401e62
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--005045015b6e00128604d1401e62
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 20, 2012 at 11:26 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Dec 14, 2012 at 7:36 PM,  <sumit.semwal@ti.com> wrote:
>> From: Sumit Semwal <sumit.semwal@linaro.org>
>>
>> Add debugfs support to make it easier to print debug information
>> about the dma-buf buffers.
>>

I've attached two patches that make it work on my system, and fix the warnings,

I've used it to debug some leaks I was seeing, feel free to squash
these patches into the original patch.

Dave.

--005045015b6e00128604d1401e62
Content-Type: application/octet-stream;
	name="0001-dma_buf-fix-debugfs-init.patch"
Content-Disposition: attachment;
	filename="0001-dma_buf-fix-debugfs-init.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_haxbf7dn0

RnJvbSA1YTBiZDExZTZmNWM1NWFjZjhhOGJjYzQxOWI5NDM3Mjc4OTQ3NDg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBUaHUsIDIwIERlYyAyMDEyIDEzOjAwOjU0ICsxMDAwClN1YmplY3Q6IFtQQVRDSCAxLzJdIGRt
YV9idWY6IGZpeCBkZWJ1Z2ZzIGluaXQKClRoZSBpbml0IGZ1bmN0aW9ucyB3YXNuJ3QgYmVlbiBj
YWxsZWQsIHRoaXMgYWRkcyBpdCBhcyBhIHN1YnN5c19pbml0Y2FsbCwKbm90IHN1cmUgaXRzIHRo
ZSBmdWxseSBjb3JyZWN0IHBsYWNlLCBidXQgaXQgc2VlbXMgdG8gd29yayBmaW5lLgoKU2lnbmVk
LW9mZi1ieTogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJzL2Jh
c2UvZG1hLWJ1Zi5jIHwgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9kbWEtYnVmLmMgYi9kcml2
ZXJzL2Jhc2UvZG1hLWJ1Zi5jCmluZGV4IDI1MTA5N2QuLjViOGM5ZGYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvYmFzZS9kbWEtYnVmLmMKKysrIGIvZHJpdmVycy9iYXNlL2RtYS1idWYuYwpAQCAtNTI1
LDEzICs1MjUsMTYgQEAgRVhQT1JUX1NZTUJPTF9HUEwoZG1hX2J1Zl92dW5tYXApOwogc3RhdGlj
IGludCBkbWFfYnVmX2luaXRfZGVidWdmcyh2b2lkKTsKIHN0YXRpYyB2b2lkIGRtYV9idWZfdW5p
bml0X2RlYnVnZnModm9pZCk7CiAKLXN0YXRpYyB2b2lkIF9faW5pdCBkbWFfYnVmX2luaXQodm9p
ZCkKK3N0YXRpYyBpbnQgX19pbml0IGRtYV9idWZfaW5pdCh2b2lkKQogewogCW11dGV4X2luaXQo
JmRiX2xpc3QubG9jayk7CiAJSU5JVF9MSVNUX0hFQUQoJmRiX2xpc3QuaGVhZCk7CiAJZG1hX2J1
Zl9pbml0X2RlYnVnZnMoKTsKKwlyZXR1cm4gMDsKIH0KIAorc3Vic3lzX2luaXRjYWxsKGRtYV9i
dWZfaW5pdCk7CisKIHN0YXRpYyB2b2lkIF9fZXhpdCBkbWFfYnVmX2RlaW5pdCh2b2lkKQogewog
CWRtYV9idWZfdW5pbml0X2RlYnVnZnMoKTsKLS0gCjEuOC4wLjIKCg==
--005045015b6e00128604d1401e62
Content-Type: application/octet-stream;
	name="0002-dma-buf-fix-warning-in-seq_printf.patch"
Content-Disposition: attachment;
	filename="0002-dma-buf-fix-warning-in-seq_printf.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_haxbf7dt1

RnJvbSA2ZmZhZGNiZTU4MmUzYWJiNzNjMTlkNzViMjMyNTEwZGE4MjE5NDlhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBUaHUsIDIwIERlYyAyMDEyIDEzOjA2OjA0ICsxMDAwClN1YmplY3Q6IFtQQVRDSCAyLzJdIGRt
YS1idWY6IGZpeCB3YXJuaW5nIGluIHNlcV9wcmludGYKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVu
dC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rp
bmc6IDhiaXQKCi9ob21lL2FpcmxpZWQvZGV2ZWwva2VybmVsL2RybS0yLjYvZHJpdmVycy9iYXNl
L2RtYS1idWYuYzogSW4gZnVuY3Rpb24g4oCYZG1hX2J1Zl9kZXNjcmliZeKAmToKL2hvbWUvYWly
bGllZC9kZXZlbC9rZXJuZWwvZHJtLTIuNi9kcml2ZXJzL2Jhc2UvZG1hLWJ1Zi5jOjU2Njo1OiB3
YXJuaW5nOiBmb3JtYXQg4oCYJWTigJkgZXhwZWN0cyBhcmd1bWVudCBvZiB0eXBlIOKAmGludOKA
mSwgYnV0IGFyZ3VtZW50IDYgaGFzIHR5cGUg4oCYbG9uZyBpbnTigJkgWy1XZm9ybWF0XQoKU2ln
bmVkLW9mZi1ieTogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJz
L2Jhc2UvZG1hLWJ1Zi5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9iYXNlL2RtYS1idWYuYyBiL2RyaXZl
cnMvYmFzZS9kbWEtYnVmLmMKaW5kZXggNWI4YzlkZi4uMTMyYWFhMyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9iYXNlL2RtYS1idWYuYworKysgYi9kcml2ZXJzL2Jhc2UvZG1hLWJ1Zi5jCkBAIC01NjAs
NyArNTYwLDcgQEAgc3RhdGljIGludCBkbWFfYnVmX2Rlc2NyaWJlKHN0cnVjdCBzZXFfZmlsZSAq
cykKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGJ1Zl9vYmosICZkYl9saXN0LmhlYWQsIGxpc3Rfbm9k
ZSkgewogCQlzZXFfcHJpbnRmKHMsICJcdCIpOwogCi0JCXNlcV9wcmludGYocywgIiUwOHp1XHQl
MDh4XHQlMDh4XHQlMDhkXG4iLAorCQlzZXFfcHJpbnRmKHMsICIlMDh6dVx0JTA4eFx0JTA4eFx0
JTA4bGRcbiIsCiAJCQkJYnVmX29iai0+c2l6ZSwgYnVmX29iai0+ZmlsZS0+Zl9mbGFncywKIAkJ
CQlidWZfb2JqLT5maWxlLT5mX21vZGUsCiAJCQkJYnVmX29iai0+ZmlsZS0+Zl9jb3VudC5jb3Vu
dGVyKTsKLS0gCjEuOC4wLjIKCg==
--005045015b6e00128604d1401e62--
