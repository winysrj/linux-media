Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17.bullet.mail.ird.yahoo.com ([77.238.189.70]:26413 "EHLO
	nm17.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2KDIhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Nov 2012 03:37:06 -0500
Message-ID: <1352018224.61772.YahooMailClassic@web29405.mail.ird.yahoo.com>
Date: Sun, 4 Nov 2012 08:37:04 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: small regression in mediatree/for_v3.7-3 - media_build
To: Antti Palosaari <crope@iki.fi>, VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1426553645-299488963-1352018224=:61772"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--1426553645-299488963-1352018224=:61772
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

--- On Sat, 3/11/12, VDR User <user.vdr@gmail.com> wrote:=0A=0A> On Tue, Au=
g 14, 2012 at 4:51 PM,=0A> Antti Palosaari <crope@iki.fi>=0A> wrote:=0A> >>=
 There seems to be a small regression on=0A> mediatree/for_v3.7-3=0A> >> - =
dmesg/klog get flooded with these:=0A> >>=0A> >> [201145.140260] dvb_fronte=
nd_poll: 15 callbacks=0A> suppressed=0A> >> [201145.586405] usb_urb_complet=
e: 88 callbacks=0A> suppressed=0A> >> [201150.587308] usb_urb_complete: 345=
6 callbacks=0A> suppressed=0A> >>=0A> >> [201468.630197] usb_urb_complete: =
3315 callbacks=0A> suppressed=0A> >> [201473.632978] usb_urb_complete: 3529=
 callbacks=0A> suppressed=0A> >> [201478.635400] usb_urb_complete: 3574 cal=
lbacks=0A> suppressed=0A> >>=0A> >> It seems to be every 5 seconds, but I t=
hink that's=0A> just klog skipping=0A> >> repeats and collapsing duplicate =
entries. This does=0A> not happen the last time=0A> >> I tried playing with=
 the TV stick :-).=0A> >=0A> > That's because you has dynamic debugs enable=
d!=0A> > modprobe dvb_core; echo -n 'module dvb_core +p' >=0A> > /sys/kerne=
l/debug/dynamic_debug/control=0A> > modprobe dvb_usbv2; echo -n 'module dvb=
_usbv2 +p' >=0A> > /sys/kernel/debug/dynamic_debug/control=0A> >=0A> > If y=
ou don't add dvb_core and dvb_usbv2 modules to=0A> > /sys/kernel/debug/dyna=
mic_debug/control you will not=0A> see those.=0A> =0A> I'm getting massive =
amounts of "dvb_frontend_poll: 20=0A> callbacks=0A> suppressed" messages in=
 dmesg also and I definitely did not=0A> put=0A> dvb_core or anything else =
in=0A> /sys/kernel/debug/dynamic_debug/control.=0A> For that matter I don't=
 even have a=0A> /sys/kernel/debug/dynamic_debug/control file.=0A> =0A> > I=
 have added ratelimited version for those few debugs=0A> that are flooded=
=0A> > normally. This suppressed is coming from ratelimit - it=0A> does not=
 print all=0A> > those similar debugs.=0A> =0A> I'm using kernel 3.6.3 with=
 media_build from Oct. 21, 2012.=0A> How I can=0A> disable those messages? =
I'd rather not see hundreds,=0A> possibly=0A> thousands or millions of thos=
e messages. :)=0A=0Aokay, if you had followed the threads further down, you=
 would probably see that I patched the host side copy of device.h, i.e:=0A=
=0A/lib/modules/`uname -r `/build/include/linux/device.h=0A=0Ato get around=
 this, since media_build does not use a full dev kernel tree, but uses the =
host-side copy of the kernel headers.=0A=0ASo you need to apply the patch (=
attached) to that. i.e.=0A  cd /lib/modules/`uname -r `/build/include/linux=
/=0A  patch -p3 < /tmp/patch=0A=0AMind you this messes up your kernel-dev h=
eaders. In my case, because that file is part of the fedora distro kernel-d=
evel package, and as soon as I get a new kernel the whole thing is thrown a=
way, so I don't care. But if you compile your own kernel (and hence have yo=
ur own kernel-devel headers which you want to keep in clean state), you mig=
ht want to take note about this.=0A=0AHope this helps.
--1426553645-299488963-1352018224=:61772
Content-Type: application/octet-stream; name=patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=patch

Y29tbWl0IGQ1NzJmMjk1ODM1MmRiZTdiNjU1MjUxMWM5ZTgwZDE1OTI5YmZl
YTYKQXV0aG9yOiBIaXJvc2hpIERveXUgPGhkb3l1QG52aWRpYS5jb20+CkRh
dGU6ICAgVHVlIEF1ZyAyMSAwNjowMjowNCAyMDEyICswMDAwCgogICAgZHJp
dmVyLWNvcmU6IFNodXQgdXAgZGV2X2RiZ19yZWF0ZWxpbWl0ZWQoKSB3aXRo
b3V0IERFQlVHCiAgICAKICAgIGRldl9kYmdfcmVhdGVsaW1pdGVkKCkgd2l0
aG91dCBERUJVRyBwcmludGVkICIyMTcwNzggY2FsbGJhY2tzCiAgICBzdXBw
cmVzc2VkIi4gVGhpcyBzaG91bGRuJ3QgcHJpbnQgYW55dGhpbmcgd2l0aG91
dCBERUJVRy4KICAgIAogICAgV2l0aCBDT05GSUdfRFlOQU1JQ19ERUJVRywg
dGhlIHByaW50IHNob3VsZCBiZSBjb25maWd1cmVkIGFzIGV4cGVjdGVkLgog
ICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBIaXJvc2hpIERveXUgPGhkb3l1QG52
aWRpYS5jb20+CiAgICBSZXBvcnRlZC1ieTogQW50dGkgUGFsb3NhYXJpIDxj
cm9wZUBpa2kuZmk+CiAgICBTaWduZWQtb2ZmLWJ5OiBBbnR0aSBQYWxvc2Fh
cmkgPGNyb3BlQGlraS5maT4KCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L2RldmljZS5oIGIvaW5jbHVkZS9saW51eC9kZXZpY2UuaAppbmRleCA1MmE1
ZjE1Li40ZDkxMjY1IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2Rldmlj
ZS5oCisrKyBiL2luY2x1ZGUvbGludXgvZGV2aWNlLmgKQEAgLTk0Niw2ICs5
NDYsMzIgQEAgaW50IF9kZXZfaW5mbyhjb25zdCBzdHJ1Y3QgZGV2aWNlICpk
ZXYsIGNvbnN0IGNoYXIgKmZtdCwgLi4uKQogCiAjZW5kaWYKIAorLyoKKyAq
IFN0dXBpZCBoYWNrYXJvdW5kIGZvciBleGlzdGluZyB1c2VzIG9mIG5vbi1w
cmludGsgdXNlcyBkZXZfaW5mbworICoKKyAqIE5vdGUgdGhhdCB0aGUgZGVm
aW5pdGlvbiBvZiBkZXZfaW5mbyBiZWxvdyBpcyBhY3R1YWxseSBfZGV2X2lu
Zm8KKyAqIGFuZCBhIG1hY3JvIGlzIHVzZWQgdG8gYXZvaWQgcmVkZWZpbmlu
ZyBkZXZfaW5mbworICovCisKKyNkZWZpbmUgZGV2X2luZm8oZGV2LCBmbXQs
IGFyZy4uLikgX2Rldl9pbmZvKGRldiwgZm10LCAjI2FyZykKKworI2lmIGRl
ZmluZWQoQ09ORklHX0RZTkFNSUNfREVCVUcpCisjZGVmaW5lIGRldl9kYmco
ZGV2LCBmb3JtYXQsIC4uLikJCSAgICAgXAorZG8gewkJCQkJCSAgICAgXAor
CWR5bmFtaWNfZGV2X2RiZyhkZXYsIGZvcm1hdCwgIyNfX1ZBX0FSR1NfXyk7
IFwKK30gd2hpbGUgKDApCisjZWxpZiBkZWZpbmVkKERFQlVHKQorI2RlZmlu
ZSBkZXZfZGJnKGRldiwgZm9ybWF0LCBhcmcuLi4pCQlcCisJZGV2X3ByaW50
ayhLRVJOX0RFQlVHLCBkZXYsIGZvcm1hdCwgIyNhcmcpCisjZWxzZQorI2Rl
ZmluZSBkZXZfZGJnKGRldiwgZm9ybWF0LCBhcmcuLi4pCQkJCVwKKyh7CQkJ
CQkJCQlcCisJaWYgKDApCQkJCQkJCVwKKwkJZGV2X3ByaW50ayhLRVJOX0RF
QlVHLCBkZXYsIGZvcm1hdCwgIyNhcmcpOwlcCisJMDsJCQkJCQkJXAorfSkK
KyNlbmRpZgorCiAjZGVmaW5lIGRldl9sZXZlbF9yYXRlbGltaXRlZChkZXZf
bGV2ZWwsIGRldiwgZm10LCAuLi4pCQkJXAogZG8gewkJCQkJCQkJCVwKIAlz
dGF0aWMgREVGSU5FX1JBVEVMSU1JVF9TVEFURShfcnMsCQkJCVwKQEAgLTk2
OSwzMyArOTk1LDIxIEBAIGRvIHsJCQkJCQkJCQlcCiAJZGV2X2xldmVsX3Jh
dGVsaW1pdGVkKGRldl9ub3RpY2UsIGRldiwgZm10LCAjI19fVkFfQVJHU19f
KQogI2RlZmluZSBkZXZfaW5mb19yYXRlbGltaXRlZChkZXYsIGZtdCwgLi4u
KQkJCQlcCiAJZGV2X2xldmVsX3JhdGVsaW1pdGVkKGRldl9pbmZvLCBkZXYs
IGZtdCwgIyNfX1ZBX0FSR1NfXykKKyNpZiBkZWZpbmVkKENPTkZJR19EWU5B
TUlDX0RFQlVHKSB8fCBkZWZpbmVkKERFQlVHKQogI2RlZmluZSBkZXZfZGJn
X3JhdGVsaW1pdGVkKGRldiwgZm10LCAuLi4pCQkJCVwKLQlkZXZfbGV2ZWxf
cmF0ZWxpbWl0ZWQoZGV2X2RiZywgZGV2LCBmbXQsICMjX19WQV9BUkdTX18p
Ci0KLS8qCi0gKiBTdHVwaWQgaGFja2Fyb3VuZCBmb3IgZXhpc3RpbmcgdXNl
cyBvZiBub24tcHJpbnRrIHVzZXMgZGV2X2luZm8KLSAqCi0gKiBOb3RlIHRo
YXQgdGhlIGRlZmluaXRpb24gb2YgZGV2X2luZm8gYmVsb3cgaXMgYWN0dWFs
bHkgX2Rldl9pbmZvCi0gKiBhbmQgYSBtYWNybyBpcyB1c2VkIHRvIGF2b2lk
IHJlZGVmaW5pbmcgZGV2X2luZm8KLSAqLwotCi0jZGVmaW5lIGRldl9pbmZv
KGRldiwgZm10LCBhcmcuLi4pIF9kZXZfaW5mbyhkZXYsIGZtdCwgIyNhcmcp
Ci0KLSNpZiBkZWZpbmVkKENPTkZJR19EWU5BTUlDX0RFQlVHKQotI2RlZmlu
ZSBkZXZfZGJnKGRldiwgZm9ybWF0LCAuLi4pCQkgICAgIFwKLWRvIHsJCQkJ
CQkgICAgIFwKLQlkeW5hbWljX2Rldl9kYmcoZGV2LCBmb3JtYXQsICMjX19W
QV9BUkdTX18pOyBcCitkbyB7CQkJCQkJCQkJXAorCXN0YXRpYyBERUZJTkVf
UkFURUxJTUlUX1NUQVRFKF9ycywJCQkJXAorCQkJCSAgICAgIERFRkFVTFRf
UkFURUxJTUlUX0lOVEVSVkFMLAlcCisJCQkJICAgICAgREVGQVVMVF9SQVRF
TElNSVRfQlVSU1QpOwkJXAorCURFRklORV9EWU5BTUlDX0RFQlVHX01FVEFE
QVRBKGRlc2NyaXB0b3IsIGZtdCk7CQkJXAorCWlmICh1bmxpa2VseShkZXNj
cmlwdG9yLmZsYWdzICYgX0RQUklOVEtfRkxBR1NfUFJJTlQpICYmCVwKKwkg
ICAgX19yYXRlbGltaXQoJl9ycykpCQkJCQkJXAorCQlfX2R5bmFtaWNfcHJf
ZGVidWcoJmRlc2NyaXB0b3IsIHByX2ZtdChmbXQpLAkJXAorCQkJCSAgICMj
X19WQV9BUkdTX18pOwkJCVwKIH0gd2hpbGUgKDApCi0jZWxpZiBkZWZpbmVk
KERFQlVHKQotI2RlZmluZSBkZXZfZGJnKGRldiwgZm9ybWF0LCBhcmcuLi4p
CQlcCi0JZGV2X3ByaW50ayhLRVJOX0RFQlVHLCBkZXYsIGZvcm1hdCwgIyNh
cmcpCiAjZWxzZQotI2RlZmluZSBkZXZfZGJnKGRldiwgZm9ybWF0LCBhcmcu
Li4pCQkJCVwKLSh7CQkJCQkJCQlcCi0JaWYgKDApCQkJCQkJCVwKLQkJZGV2
X3ByaW50ayhLRVJOX0RFQlVHLCBkZXYsIGZvcm1hdCwgIyNhcmcpOwlcCi0J
MDsJCQkJCQkJXAotfSkKKyNkZWZpbmUgZGV2X2RiZ19yYXRlbGltaXRlZChk
ZXYsIGZtdCwgLi4uKQkJCVwKKwlub19wcmludGsoS0VSTl9ERUJVRyBwcl9m
bXQoZm10KSwgIyNfX1ZBX0FSR1NfXykKICNlbmRpZgogCiAjaWZkZWYgVkVS
Qk9TRV9ERUJVRwo=

--1426553645-299488963-1352018224=:61772--
