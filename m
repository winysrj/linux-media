Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.246])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jlacvdr@gmail.com>) id 1Jh84C-0005cp-Q7
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 20:52:19 +0200
Received: by an-out-0708.google.com with SMTP id d18so3352846and.125
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 11:52:03 -0700 (PDT)
Message-ID: <ed9fa2110804021152r1014c039ua84fd840c9d8c7a8@mail.gmail.com>
Date: Wed, 2 Apr 2008 20:52:02 +0200
From: jlacvdr <jlacvdr@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47F3902E.6060002@okg-computer.de>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_3322_20762207.1207162322970"
References: <JQH8LK$96D0E7F415C0B19866A44914B01BB54A@libero.it>
	<4720EEC9.7040004@gmail.com> <47F3902E.6060002@okg-computer.de>
Subject: Re: [linux-dvb] Problems compiling hacked szap.c
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_3322_20762207.1207162322970
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

try with the attached patch : szap-multiproto-apiv33.diff
This patch add support of dvb api v3.3 to szap.

Regards,

JLac

2008/4/2, Jens Krehbiel-Gr=E4ther <linux-dvb@okg-computer.de>:
> Hi!
>
>  I have problems compiling szap.c for multiproto. I use kernel 2.6.24
>  I followed the instructions of Manu posted to the list a few months ago:
>
>  > Make sure you have the updated headers (frontend.h, version.h in your =
include path)
>  > (You need the same headers from the multiproto tree)
>  >
>  > wget http://abraham.manu.googlepages.com/szap.c
>  > copy lnb.c and lnb.h from dvb-apps to the same folder where you downlo=
aded szap.c
>  >
>  > cc -c lnb.c
>  > cc -c szap.c
>  > cc -o szap szap.o lnb.o
>  >
>  > That's it
>  >
>  > Manu
>
>  but it won't work.
>
>  I get the following error:
>
>  dev:/usr/src/szap# cc -c szap.c
>  szap.c: In function 'zap_to':
>  szap.c:368: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:372: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:376: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:401: error: 'struct dvbfe_info' has no member named 'delivery'
>  szap.c:412: error: 'struct dvbfe_info' has no member named 'delivery'
>  dev:/usr/src/szap#
>
>  lnb.c compiles without error.
>
>  I have compiled szap under older kernel without error, but when I use
>  this compiled szap now (under 2.6.24) I get the following error:
>
>  dev:~# szap ProSieben
>  reading channels from file '/root/.szap/channels.conf'
>  zapping to 208 'ProSieben':
>  sat 0, frequency =3D 12544 MHz H, symbolrate 22000000, vpid =3D 0x01ff, =
apid
>  =3D 0x0200 sid =3D 0x445d
>  Querying info .. Delivery system=3DDVB-S
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  ioctl DVBFE_GET_INFO failed: Operation not supported
>  dev:~#
>
>  I've successfully compiled multiproto drivers with the compat.h patch
>  f=FCr 2.6.24 kernel. The modules load without errors, but I can not szap
>  to any channel.
>
>  Can you help me??
>
>  Thanks,
>   Jens
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

------=_Part_3322_20762207.1207162322970
Content-Type: text/x-patch; name=szap-multiproto-apiv33.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fek99esg
Content-Disposition: attachment; filename=szap-multiproto-apiv33.diff

LS0tIG9yZy9zemFwLmMJMjAwOC0wNC0wMiAyMDo0NzowNS4wMDAwMDAwMDAgKzAyMDAKKysrIG5l
dy9zemFwLmMJMjAwOC0wNC0wMiAyMDo0NjozMC4wMDAwMDAwMDAgKzAyMDAKQEAgLTM1MSw2ICsz
NTEsNyBAQAogCXVpbnQzMl90IGlmcmVxOwogCWludCBoaWJhbmQsIHJlc3VsdDsKIAlzdHJ1Y3Qg
ZHZiZmVfaW5mbyBmZV9pbmZvOworCWVudW0gZHZiZmVfZGVsc3lzIGRlbGl2ZXJ5OwogCiAJLy8g
YSB0ZW1wb3JhcnkgaGFjaywgbmVlZCB0byBjbGVhbgogCW1lbXNldCgmZmVfaW5mbywgMCwgc2l6
ZW9mICgmZmVfaW5mbykpOwpAQCAtMzY1LDE1ICszNjYsMTUgQEAKIAlzd2l0Y2ggKGRlbHN5cykg
ewogCWNhc2UgRFZCUzoKIAkJcHJpbnRmKCJRdWVyeWluZyBpbmZvIC4uIERlbGl2ZXJ5IHN5c3Rl
bT1EVkItU1xuIik7Ci0JCWZlX2luZm8uZGVsaXZlcnkgPSBEVkJGRV9ERUxTWVNfRFZCUzsJCisJ
CWRlbGl2ZXJ5ID0gRFZCRkVfREVMU1lTX0RWQlM7CiAJCWJyZWFrOwogCWNhc2UgRFNTOgogCQlw
cmludGYoIlF1ZXJ5aW5nIGluZm8gLi4gRGVsaXZlcnkgc3lzdGVtPURTU1xuIik7Ci0JCWZlX2lu
Zm8uZGVsaXZlcnkgPSBEVkJGRV9ERUxTWVNfRFNTOworCQlkZWxpdmVyeSA9IERWQkZFX0RFTFNZ
U19EU1M7CiAJCWJyZWFrOwogCWNhc2UgRFZCUzI6CiAJCXByaW50ZigiUXVlcnlpbmcgaW5mbyAu
LiBEZWxpdmVyeSBzeXN0ZW09RFZCLVMyXG4iKTsKLQkJZmVfaW5mby5kZWxpdmVyeSA9IERWQkZF
X0RFTFNZU19EVkJTMjsKKwkJZGVsaXZlcnkgPSBEVkJGRV9ERUxTWVNfRFZCUzI7CiAJCWJyZWFr
OwogCWRlZmF1bHQ6CiAJCXByaW50ZigiVW5zdXBwb3J0ZWQgZGVsaXZlcnkgc3lzdGVtXG4iKTsK
QEAgLTM5MSw2ICszOTIsOCBAQAogCQkJcmV0dXJuIEZBTFNFOwogCQl9CiAKKwkJaW9jdGwoZmVm
ZCwgRFZCRkVfU0VUX0RFTFNZUywgJmRlbGl2ZXJ5KTsgLy9zd2l0Y2ggc3lzdGVtCisKIAkJcmVz
dWx0ID0gaW9jdGwoZmVmZCwgRFZCRkVfR0VUX0lORk8sICZmZV9pbmZvKTsKIAkJaWYgKHJlc3Vs
dCA8IDApIHsKIAkJCXBlcnJvcigiaW9jdGwgRFZCRkVfR0VUX0lORk8gZmFpbGVkIik7CkBAIC0z
OTgsNyArNDAxLDcgQEAKIAkJCXJldHVybiBGQUxTRTsKIAkJfQogCQkKLQkJc3dpdGNoIChmZV9p
bmZvLmRlbGl2ZXJ5KSB7CisJCXN3aXRjaCAoZGVsaXZlcnkpIHsKIAkJY2FzZSBEVkJGRV9ERUxT
WVNfRFZCUzoKIAkJCXByaW50ZigiLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLT4g
VXNpbmcgJyVzJyBEVkItUyIsIGZlX2luZm8ubmFtZSk7CiAJCQlicmVhazsKQEAgLTQwOSw3ICs0
MTIsNyBAQAogCQkJcHJpbnRmKCItLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPiBV
c2luZyAnJXMnIERWQi1TMiIsIGZlX2luZm8ubmFtZSk7CiAJCQlicmVhazsKIAkJZGVmYXVsdDoK
LQkJCXByaW50ZigiVW5zdXBwb3J0ZWQgRGVsaXZlcnkgc3lzdGVtICglZCkhXG4iLCBmZV9pbmZv
LmRlbGl2ZXJ5KTsKKwkJCXByaW50ZigiVW5zdXBwb3J0ZWQgRGVsaXZlcnkgc3lzdGVtICglZCkh
XG4iLCBkZWxpdmVyeSk7CiAJCQljbG9zZShmZWZkKTsKIAkJCXJldHVybiBGQUxTRTsKIAkJfQo=

------=_Part_3322_20762207.1207162322970
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_3322_20762207.1207162322970--
