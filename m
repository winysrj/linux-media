Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0J2XCx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 19:02:53 -0400
Received: by bwz11 with SMTP id 11so3022276bwz.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 16:02:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: h.ordiales@gmail.com
In-Reply-To: <4CC25F60.7050106@redhat.com>
References: <4CC25F60.7050106@redhat.com>
From: =?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>
Date: Fri, 29 Oct 2010 20:02:35 -0300
Message-ID: <AANLkTimEQPK-HvM7BPrMt4LH=x2Gq7tCZfq0trzmkAcU@mail.gmail.com>
Subject: Re: V4L/DVB/IR patches pending merge
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Igor M. Liplianin" <liplianin@me.by>,
	LMML <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636c59a953560c40493c9754b
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--001636c59a953560c40493c9754b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2010/10/23 Mauro Carvalho Chehab <mchehab@redhat.com>:
> This is the list of patches that weren't applied yet. I've made a big eff=
ort starting
> last weekend to handle everything I could. All pull requests were address=
ed. There are still
> 43 patches on my queue.
>
> Please help me to clean the list.
>
> This is what we have currently:
[snip]
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=3D Waiting for Patrick Boettcher <pboe=
ttcher@dibcom.fr> review =3D=3D
>
> May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remo=
te control http://patchwork.kernel.org/patch/102314 =A0Hern=E1n Ordiales <h=
.ordiales@gmail.com>
> Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 http://patchwork.kernel.org/patch/1119=
72 =A0Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 http://patchwork.kernel.org/patch/11197=
3 =A0Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
>
> The first patch is probably broken.
>
> Hern=E1n,
> Could you please re-generate it?

Yes, i'm sending it as attachment (regenerated agaisnt trunk, 15168 revisio=
n)

Cheers
--=20
Hern=E1n
http://h.ordia.com.ar

--001636c59a953560c40493c9754b
Content-Type: text/x-patch; charset=US-ASCII; name="GeniatechMyGicaS870.patch"
Content-Disposition: attachment; filename="GeniatechMyGicaS870.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfvo3hj00

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gKIyBVc2VyIGhvcmRpYQojIERhdGUgMTI4ODM4OTkzNiAxMDgw
MAojIE5vZGUgSUQgMjQ4ZjUxM2NmNWI4YThlY2FjMDhkMTNjOTBkZGVlYWYzMjZjMDhlYQojIFBh
cmVudCAgYWJkM2FhYzY2NDRlMWEzMTAyMGY0Y2RmZGVlODRiZGU3Y2ExZTFiNApBZGRpbmcgc3Vw
cG9ydCB0byB0aGUgR2VuaWF0ZWNoL015R2ljYSBTQlRWRCBTdGljayBTODcwIHJlbW90ZSBjb250
cm9sICh1cGRhdGVkKQoKZGlmZiAtciBhYmQzYWFjNjY0NGUgLXIgMjQ4ZjUxM2NmNWI4IGxpbnV4
L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9jb3JlLmMKLS0tIGEvbGludXgvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2NvcmUuYwlGcmkgSnVsIDAyIDAwOjM4OjU0
IDIwMTAgLTAzMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAw
X2NvcmUuYwlGcmkgT2N0IDI5IDE5OjA1OjM2IDIwMTAgLTAzMDAKQEAgLTU1NSw2ICs1NTUsMTQg
QEAKIAkJCWJyZWFrOwogCQl9CiAJCWJyZWFrOworCWNhc2UgMToKKwkJLyogR2VuaWF0ZWNoL015
R2ljYSByZW1vdGUgcHJvdG9jb2wgKi8KKwkJcG9sbF9yZXBseS5yZXBvcnRfaWQgID0gYnVmWzBd
OworCQlwb2xsX3JlcGx5LmRhdGFfc3RhdGUgPSBidWZbMV07CisJCXBvbGxfcmVwbHkuc3lzdGVt
ICAgICA9IChidWZbNF0gPDwgOCkgfCBidWZbNF07CisJCXBvbGxfcmVwbHkuZGF0YSAgICAgICA9
IGJ1Zls1XTsKKwkJcG9sbF9yZXBseS5ub3RfZGF0YSAgID0gYnVmWzRdOyAvKiBpbnRlZ3JpdHkg
Y2hlY2sgKi8KKyAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCS8qIFJDNSBQcm90b2NvbCAqLwogCQlw
b2xsX3JlcGx5LnJlcG9ydF9pZCAgPSBidWZbMF07CmRpZmYgLXIgYWJkM2FhYzY2NDRlIC1yIDI0
OGY1MTNjZjViOCBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNl
cy5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2Vz
LmMJRnJpIEp1bCAwMiAwMDozODo1NCAyMDEwIC0wMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVk
aWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMJRnJpIE9jdCAyOSAxOTowNTozNiAyMDEw
IC0wMzAwCkBAIC04MzEsNiArODMxLDQ0IEBACiAJeyAweDQ1NDAsIEtFWV9SRUNPUkQgfSwgLyog
Rm9udCAnU2l6ZScgZm9yIFRlbGV0ZXh0ICovCiAJeyAweDQ1NDEsIEtFWV9TQ1JFRU4gfSwgLyog
IEZ1bGwgc2NyZWVuIHRvZ2dsZSwgJ0hvbGQnIGZvciBUZWxldGV4dCAqLwogCXsgMHg0NTQyLCBL
RVlfU0VMRUNUIH0sIC8qIFNlbGVjdCB2aWRlbyBpbnB1dCwgJ1NlbGVjdCcgZm9yIFRlbGV0ZXh0
ICovCisKKwkvKiBLZXkgY29kZXMgZm9yIHRoZSBHZW5pYXRlY2gvTXlHaWNhIFNCVFZEIFN0aWNr
IFM4NzAgcmVtb3RlCisJICAgc2V0IGR2Yl91c2JfZGliMDcwMF9pcl9wcm90bz0xICovCisJeyAw
eDM4YzcsIEtFWV9UViB9LCAvKiBUVi9BViAqLworCXsgMHgwY2YzLCBLRVlfUE9XRVIgfSwKKwl7
IDB4MGFmNSwgS0VZX01VVEUgfSwKKwl7IDB4MmJkNCwgS0VZX1ZPTFVNRVVQIH0sCisJeyAweDJj
ZDMsIEtFWV9WT0xVTUVET1dOIH0sCisJeyAweDEyZWQsIEtFWV9DSEFOTkVMVVAgfSwKKwl7IDB4
MTNlYywgS0VZX0NIQU5ORUxET1dOIH0sCisJeyAweDAxZmUsIEtFWV8xIH0sCisJeyAweDAyZmQs
IEtFWV8yIH0sCisJeyAweDAzZmMsIEtFWV8zIH0sCisJeyAweDA0ZmIsIEtFWV80IH0sCisJeyAw
eDA1ZmEsIEtFWV81IH0sCisJeyAweDA2ZjksIEtFWV82IH0sCisJeyAweDA3ZjgsIEtFWV83IH0s
CisJeyAweDA4ZjcsIEtFWV84IH0sCisJeyAweDA5ZjYsIEtFWV85IH0sCisJeyAweDAwZmYsIEtF
WV8wIH0sCisJeyAweDE2ZTksIEtFWV9QQVVTRSB9LAorCXsgMHgxN2U4LCBLRVlfUExBWSB9LAor
CXsgMHgwYmY0LCBLRVlfU1RPUCB9LAorCXsgMHgyNmQ5LCBLRVlfUkVXSU5EIH0sCisJeyAweDI3
ZDgsIEtFWV9GQVNURk9SV0FSRCB9LAorCXsgMHgyOWQ2LCBLRVlfRVNDIH0sCisJeyAweDFmZTAs
IEtFWV9SRUNPUkQgfSwKKwl7IDB4MjBkZiwgS0VZX1VQIH0sCisJeyAweDIxZGUsIEtFWV9ET1dO
IH0sCisJeyAweDExZWUsIEtFWV9MRUZUIH0sCisJeyAweDEwZWYsIEtFWV9SSUdIVCB9LAorCXsg
MHgwZGYyLCBLRVlfT0sgfSwKKwl7IDB4MWVlMSwgS0VZX1BMQVlQQVVTRSB9LCAvKiBUaW1lc2hp
ZnQgKi8KKwl7IDB4MGVmMSwgS0VZX0NBTUVSQSB9LCAvKiBTbmFwc2hvdCAqLworCXsgMHgyNWRh
LCBLRVlfRVBHIH0sIC8qIEluZm8gS0VZX0lORk8gKi8KKwl7IDB4MmRkMiwgS0VZX01FTlUgfSwg
LyogRFZEIE1lbnUgKi8KKwl7IDB4MGZmMCwgS0VZX1NDUkVFTiB9LCAvKiBGdWxsIHNjcmVlbiB0
b2dnbGUgKi8KKwl7IDB4MTRlYiwgS0VZX1NIVUZGTEUgfSwKIH07CiAKIC8qIFNUSzc3MDBQOiBI
YXVwcGF1Z2UgTm92YS1UIFN0aWNrLCBBVmVyTWVkaWEgVm9sYXIgKi8K
--001636c59a953560c40493c9754b--
