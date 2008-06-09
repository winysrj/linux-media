Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1K5WAc-0002wo-OY
	for linux-dvb@linuxtv.org; Mon, 09 Jun 2008 03:27:39 +0200
Received: by ik-out-1112.google.com with SMTP id c21so1538555ika.1
	for <linux-dvb@linuxtv.org>; Sun, 08 Jun 2008 18:27:35 -0700 (PDT)
Message-ID: <412bdbff0806081827x1e919659y7b99d23266ab3bc3@mail.gmail.com>
Date: Sun, 8 Jun 2008 21:27:34 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Sneake <2hteq3r02@sneakemail.com>
In-Reply-To: <20999-51361@sneakemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_5108_1414848.1212974854396"
References: <20999-51361@sneakemail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiple em28xx devices doesn't work (well)
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

------=_Part_5108_1414848.1212974854396
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello there,

On Fri, Jun 6, 2008 at 7:10 PM, Sneake <2hteq3r02@sneakemail.com> wrote:
> I have 2 em28xx USB capture devices - a Hauppauge Win-HVR-950 and a Pinnacle HD stick:
>
> Bus 001 Device 007: ID 2304:0227 Pinnacle Systems, Inc. [hex] Pinnacle TV for Mac, HD Stick
> Bus 001 Device 004: ID 2040:6513 Hauppauge
>
> Both of which are em28xx devices.
> I am running the latest HG pull of the v4l-dvb drivers as of today (6th June 2008).
>
> From a cold start, both devices are seen by the USB probe, however only one gets a /dev/dvb
> /adapter entry. If I remove the one that did not, I get the following warning:

I was able to reproduce the behavior you were seeing (I actually have
the exact same two devices).

Attached is a patch that will address the problem (based off of the
latest hg).  There was a race condition in the module loading process
which caused only the last device to be initialized by the driver.

I will submit the patch to Mauro for inclusion.

Thanks for your help,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_5108_1414848.1212974854396
Content-Type: text/x-diff; name=multiple_em28xx_bootup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh8dunpm0
Content-Disposition: attachment; filename=multiple_em28xx_bootup.patch

RnJvbTogRGV2aW4gSGVpdG11ZWxsZXIgPGRldmluLmhlaXRtdWVsbGVyQGdtYWlsLmNvbT4KCmVt
Mjh4eC12aWRlby5jCiAtIFByb3Blcmx5IGhhbmRsZSBsb2FkaW5nIG9mIHRoZSBtb2R1bGUgd2hl
biBtdWx0aXBsZSBkZXZpY2VzIGFyZSBhbHJlYWR5CiAgIGNvbm5lY3RlZCAoc3VjaCBhcyBhdCBi
b290dXApLiAgQmVmb3JlIHdlIHdlcmUgb25seSBjYWxsaW5nIGR2Yl9pbml0KCkgCiAgIGFnYWlu
c3QgdGhlIGxhc3QgZGV2aWNlIGluIHRoZSBsaXN0LCBzbyB3aGlsZSB3ZSB3ZXJlIGhhbmRsaW5n
IHN1YnNlcXVlbnQKICAgYWRkcyBwcm9wZXJseSwgaWYgdGhlcmUgd2VyZSBtdWx0aXBsZSBkZXZp
Y2VzIHByZXNlbnQgb24gZHJpdmVyIGxvYWQsIAogICBldmVyeWJvZHkgZXhjZXB0IHRoZSBsYXN0
IGRldmljZSB3b3VsZCBub3QgZ2V0IGluaXRpYWxpemVkLgoKU2lnbmVkLW9mZi1ieTogRGV2aW4g
SGVpdG11ZWxsZXIgPGRldmluLmhlaXRtdWVsbGVyQGdtYWlsLmNvbT4KCmRpZmYgLXIgM2Y3ZDY2
NGEyODVkIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC12aWRlby5jCi0t
LSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC12aWRlby5jCVN1biBK
dW4gMDggMDc6MjY6MDAgMjAwOCAtMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2VtMjh4eC9lbTI4eHgtdmlkZW8uYwlTdW4gSnVuIDA4IDIxOjE3OjEyIDIwMDggLTA0MDAKQEAg
LTE5MzQsMzIgKzE5MzQsMjggQEAgc3RhdGljIERFRklORV9NVVRFWChlbTI4eHhfZXh0ZW5zaW9u
X2RldgogCiBpbnQgZW0yOHh4X3JlZ2lzdGVyX2V4dGVuc2lvbihzdHJ1Y3QgZW0yOHh4X29wcyAq
b3BzKQogewotCXN0cnVjdCBlbTI4eHggKmgsICpkZXYgPSBOVUxMOwotCi0JbGlzdF9mb3JfZWFj
aF9lbnRyeShoLCAmZW0yOHh4X2Rldmxpc3QsIGRldmxpc3QpCi0JCWRldiA9IGg7CisJc3RydWN0
IGVtMjh4eCAqZGV2ID0gTlVMTDsKIAogCW11dGV4X2xvY2soJmVtMjh4eF9leHRlbnNpb25fZGV2
bGlzdF9sb2NrKTsKIAlsaXN0X2FkZF90YWlsKCZvcHMtPm5leHQsICZlbTI4eHhfZXh0ZW5zaW9u
X2Rldmxpc3QpOwotCWlmIChkZXYpCi0JCW9wcy0+aW5pdChkZXYpOwotCisJbGlzdF9mb3JfZWFj
aF9lbnRyeShkZXYsICZlbTI4eHhfZGV2bGlzdCwgZGV2bGlzdCkgeworCQlpZiAoZGV2KQorCQkJ
b3BzLT5pbml0KGRldik7CisJfQogCXByaW50ayhLRVJOX0lORk8gIkVtMjh4eDogSW5pdGlhbGl6
ZWQgKCVzKSBleHRlbnNpb25cbiIsIG9wcy0+bmFtZSk7CiAJbXV0ZXhfdW5sb2NrKCZlbTI4eHhf
ZXh0ZW5zaW9uX2Rldmxpc3RfbG9jayk7Ci0KIAlyZXR1cm4gMDsKIH0KIEVYUE9SVF9TWU1CT0wo
ZW0yOHh4X3JlZ2lzdGVyX2V4dGVuc2lvbik7CiAKIHZvaWQgZW0yOHh4X3VucmVnaXN0ZXJfZXh0
ZW5zaW9uKHN0cnVjdCBlbTI4eHhfb3BzICpvcHMpCiB7Ci0Jc3RydWN0IGVtMjh4eCAqaCwgKmRl
diA9IE5VTEw7CisJc3RydWN0IGVtMjh4eCAqZGV2ID0gTlVMTDsKIAotCWxpc3RfZm9yX2VhY2hf
ZW50cnkoaCwgJmVtMjh4eF9kZXZsaXN0LCBkZXZsaXN0KQotCQlkZXYgPSBoOwotCi0JaWYgKGRl
dikKLQkJb3BzLT5maW5pKGRldik7CisJbGlzdF9mb3JfZWFjaF9lbnRyeShkZXYsICZlbTI4eHhf
ZGV2bGlzdCwgZGV2bGlzdCkgeworCQlpZiAoZGV2KQorCQkJb3BzLT5maW5pKGRldik7CisJfQog
CiAJbXV0ZXhfbG9jaygmZW0yOHh4X2V4dGVuc2lvbl9kZXZsaXN0X2xvY2spOwogCXByaW50ayhL
RVJOX0lORk8gIkVtMjh4eDogUmVtb3ZlZCAoJXMpIGV4dGVuc2lvblxuIiwgb3BzLT5uYW1lKTsK

------=_Part_5108_1414848.1212974854396
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_5108_1414848.1212974854396--
