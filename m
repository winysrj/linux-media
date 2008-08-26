Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp3-g19.free.fr ([212.27.42.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1KY443-0000WF-SN
	for linux-dvb@linuxtv.org; Tue, 26 Aug 2008 21:18:54 +0200
Message-ID: <48B4571C.1040207@free.fr>
Date: Tue, 26 Aug 2008 21:18:52 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>,
	Martin Michlmayr <tbm@cyrius.com>
Content-Type: multipart/mixed; boundary="------------000005090604070703010504"
Subject: [linux-dvb] [PATCH] transform udelay to mdelay
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

This is a multi-part message in MIME format.
--------------000005090604070703010504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,
following the conversation on the v4l-dvb-maitainer ML:
http://www.linuxtv.org/pipermail/v4l-dvb-maintainer/2008-August/007753.ht=
ml
Contents:
Thierry Merle a =E9crit :
> Hi Martin
>
> Martin Michlmayr a =E9crit :
>  =20
>> budget.ko fails to build on ARM with:
>>
>> ERROR: "__bad_udelay" [drivers/media/dvb/ttpci/budget.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>>
>> __bad_udelay is specifically designed on ARM to fail when udelay is
>> called in a bad way.  arch/arm/include/asm/delay.h has this to say
>> about __bad_udelay:
>>
>> /*
>>  * This function intentionally does not exist; if you see references t=
o
>>  * it, it means that you're calling udelay() with an out of range valu=
e.
>>  *
>>  * With currently imposed limits, this means that we support a max del=
ay
>>  * of 2000us. Further limits: HZ<=3D1000 and bogomips<=3D3355
>>  */
>> extern void __bad_udelay(void);
>>
>> Can you check why your driver is calling udelay() with a value > 2000?
>>
>>  =20
>>    =20
> Right, I experienced the same problem with the em28xx (from mcentral.de=
)
> driver compilation on my NSLU2 target.
> I guess you are doing the same thing for this driver.
> The solution was to use mdelay when possible.
> It solves the compilation on these low-power-consuming-but-high-capacit=
ies targets.
> Here are all the udelay with value greater than 2000 in v4l-dvb/:
> linux/drivers/media/dvb/b2c2/flexcop-fe-tuner.c:                      =20
> udelay(12500);
> linux/drivers/media/dvb/bt8xx/dst.c:            udelay(3000);
> linux/drivers/media/dvb/bt8xx/dst.c:            udelay(3000);
> linux/drivers/media/dvb/ttpci/budget-patch.c:                 =20
> udelay(12500);
> linux/drivers/media/dvb/ttpci/budget.c:                 udelay(12500);
> linux/drivers/media/video/bt8xx/bttv-cards.c:   udelay(2500);
> I attached a patch that replaces all these calls to mdelay, and additio=
nal udelay if
> necessary.
> I cannot test it since I do not own any of these devices so this is jus=
t a proposal.
> Cheers,
> Thierry
>  =20
Here is the patch I proposed, this should be harmless but I have no
device to test them.

Cheers,
Thierry

Signed-off-by: Thierry Merle <thierry.merle@free.fr>


--------------000005090604070703010504
Content-Type: text/x-patch;
 name="udelay_to_mdelay.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="udelay_to_mdelay.patch"

ZGlmZiAtciBhNDg0M2UxMzA0ZTYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvYjJjMi9mbGV4
Y29wLWZlLXR1bmVyLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvYjJjMi9mbGV4
Y29wLWZlLXR1bmVyLmMJU3VuIEF1ZyAyNCAxMjoyODoxMSAyMDA4IC0wMzAwCisrKyBiL2xp
bnV4L2RyaXZlcnMvbWVkaWEvZHZiL2IyYzIvZmxleGNvcC1mZS10dW5lci5jCVR1ZSBBdWcg
MjYgMTQ6MTU6MzYgMjAwOCArMDIwMApAQCAtMTM3LDcgKzEzNyw4IEBAIHN0YXRpYyBpbnQg
ZmxleGNvcF9zZW5kX2Rpc2VxY19tc2coc3RydWMKIAkJCWZsZXhjb3BfZGlzZXFjX3NlbmRf
Ynl0ZShmZSwgMHhmZik7CiAJCWVsc2UgewogCQkJZmxleGNvcF9zZXRfdG9uZShmZSwgU0VD
X1RPTkVfT04pOwotCQkJdWRlbGF5KDEyNTAwKTsKKwkJCW1kZWxheSgxMik7CisJCQl1ZGVs
YXkoNTAwKTsKIAkJCWZsZXhjb3Bfc2V0X3RvbmUoZmUsIFNFQ19UT05FX09GRik7CiAJCX0K
IAkJbXNsZWVwKDIwKTsKZGlmZiAtciBhNDg0M2UxMzA0ZTYgbGludXgvZHJpdmVycy9tZWRp
YS9kdmIvYnQ4eHgvZHN0LmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvYnQ4eHgv
ZHN0LmMJU3VuIEF1ZyAyNCAxMjoyODoxMSAyMDA4IC0wMzAwCisrKyBiL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL2J0OHh4L2RzdC5jCVR1ZSBBdWcgMjYgMTQ6MTY6MTYgMjAwOCArMDIw
MApAQCAtMTI0NCw3ICsxMjQ0LDcgQEAgc3RhdGljIGludCBkc3RfY29tbWFuZChzdHJ1Y3Qg
ZHN0X3N0YXRlIAogCQlnb3RvIGVycm9yOwogCX0KIAlpZiAoc3RhdGUtPnR5cGVfZmxhZ3Mg
JiBEU1RfVFlQRV9IQVNfRldfMSkKLQkJdWRlbGF5KDMwMDApOworCQltZGVsYXkoMyk7CiAJ
aWYgKHJlYWRfZHN0KHN0YXRlLCAmcmVwbHksIEdFVF9BQ0spKSB7CiAJCWRwcmludGsodmVy
Ym9zZSwgRFNUX0RFQlVHLCAxLCAiVHJ5aW5nIHRvIHJlY292ZXIuLiAiKTsKIAkJaWYgKChk
c3RfZXJyb3JfcmVjb3Zlcnkoc3RhdGUpKSA8IDApIHsKQEAgLTEyNjAsNyArMTI2MCw3IEBA
IHN0YXRpYyBpbnQgZHN0X2NvbW1hbmQoc3RydWN0IGRzdF9zdGF0ZSAKIAlpZiAobGVuID49
IDIgJiYgZGF0YVswXSA9PSAwICYmIChkYXRhWzFdID09IDEgfHwgZGF0YVsxXSA9PSAzKSkK
IAkJZ290byBlcnJvcjsKIAlpZiAoc3RhdGUtPnR5cGVfZmxhZ3MgJiBEU1RfVFlQRV9IQVNf
RldfMSkKLQkJdWRlbGF5KDMwMDApOworCQltZGVsYXkoMyk7CiAJZWxzZQogCQl1ZGVsYXko
MjAwMCk7CiAJaWYgKCFkc3Rfd2FpdF9kc3RfcmVhZHkoc3RhdGUsIE5PX0RFTEFZKSkKZGlm
ZiAtciBhNDg0M2UxMzA0ZTYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVkZ2V0
LXBhdGNoLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVkZ2V0LXBh
dGNoLmMJU3VuIEF1ZyAyNCAxMjoyODoxMSAyMDA4IC0wMzAwCisrKyBiL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL3R0cGNpL2J1ZGdldC1wYXRjaC5jCVR1ZSBBdWcgMjYgMTQ6MTY6NTQg
MjAwOCArMDIwMApAQCAtMTE2LDcgKzExNiw4IEBAIHN0YXRpYyBpbnQgU2VuZERpU0VxQ01z
ZyAoc3RydWN0IGJ1ZGdldCAKIAkJCURpc2VxY1NlbmRCeXRlKGJ1ZGdldCwgMHhmZik7CiAJ
CWVsc2UgewogCQkJc2FhNzE0Nl9zZXRncGlvKGRldiwgMywgU0FBNzE0Nl9HUElPX09VVEhJ
KTsKLQkJCXVkZWxheSgxMjUwMCk7CisJCQltZGVsYXkoMTIpOworCQkJdWRlbGF5KDUwMCk7
CiAJCQlzYWE3MTQ2X3NldGdwaW8oZGV2LCAzLCBTQUE3MTQ2X0dQSU9fT1VUTE8pOwogCQl9
CiAJCW1zbGVlcCgyMCk7CmRpZmYgLXIgYTQ4NDNlMTMwNGU2IGxpbnV4L2RyaXZlcnMvbWVk
aWEvZHZiL3R0cGNpL2J1ZGdldC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL3R0
cGNpL2J1ZGdldC5jCVN1biBBdWcgMjQgMTI6Mjg6MTEgMjAwOCAtMDMwMAorKysgYi9saW51
eC9kcml2ZXJzL21lZGlhL2R2Yi90dHBjaS9idWRnZXQuYwlUdWUgQXVnIDI2IDE0OjE4OjU2
IDIwMDggKzAyMDAKQEAgLTEwOCw3ICsxMDgsOCBAQCBzdGF0aWMgaW50IFNlbmREaVNFcUNN
c2cgKHN0cnVjdCBidWRnZXQgCiAJCQlEaXNlcWNTZW5kQnl0ZShidWRnZXQsIDB4ZmYpOwog
CQllbHNlIHsKIAkJCXNhYTcxNDZfc2V0Z3BpbyhkZXYsIDMsIFNBQTcxNDZfR1BJT19PVVRI
SSk7Ci0JCQl1ZGVsYXkoMTI1MDApOworCQkJbWRlbGF5KDEyKTsKKwkJCXVkZWxheSg1MDAp
OwogCQkJc2FhNzE0Nl9zZXRncGlvKGRldiwgMywgU0FBNzE0Nl9HUElPX09VVExPKTsKIAkJ
fQogCQltc2xlZXAoMjApOwpkaWZmIC1yIGE0ODQzZTEzMDRlNiBsaW51eC9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2J0OHh4L2J0dHYtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2J0OHh4L2J0dHYtY2FyZHMuYwlTdW4gQXVnIDI0IDEyOjI4OjExIDIwMDggLTAz
MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9idDh4eC9idHR2LWNhcmRzLmMJ
VHVlIEF1ZyAyNiAxNDoxNzo0NSAyMDA4ICswMjAwCkBAIC00MTAzLDcgKzQxMDMsOCBAQCBz
dGF0aWMgdm9pZCBfX2RldmluaXQgYm9vdF9tc3AzNHh4KHN0cnVjCiAKIAlncGlvX2lub3V0
KG1hc2ssbWFzayk7CiAJZ3Bpb19iaXRzKG1hc2ssMCk7Ci0JdWRlbGF5KDI1MDApOworCW1k
ZWxheSgyKTsKKwl1ZGVsYXkoNTAwKTsKIAlncGlvX2JpdHMobWFzayxtYXNrKTsKIAogCWlm
IChidHR2X2dwaW8p
--------------000005090604070703010504
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000005090604070703010504--
