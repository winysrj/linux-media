Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1009.centrum.cz ([90.183.38.139]:35095 "EHLO
	mail1009.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZEaRjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 13:39:21 -0400
Received: by mail1009.centrum.cz id S738354220AbZEaRjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 19:39:15 +0200
Date: Sun, 31 May 2009 19:39:15 +0200
From: "Miroslav =?UTF-8?Q?=20=C5=A0ustek?=" <sustmidown@centrum.cz>
To: <xyzzy@speakeasy.org>
Cc: <linux-media@vger.kernel.org>, <mchehab@infradead.org>
MIME-Version: 1.0
Message-ID: <200905311939.21114@centrum.cz>
References: <200905291638.9584@centrum.cz> <200905291639.30476@centrum.cz> <Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
Content-Type: multipart/mixed; boundary="-------=_54A55242.50D378D"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format

---------=_54A55242.50D378D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Trent Piepho <xyzzy <at> speakeasy.org> writes:

> Instead of raising the reset line here, why not change the gpio settings in
> the card definition to have it high? Change gpio1 for television to 0x7050
> and radio to 0x7010.
Personally, I don't know when these .gpioX members are used (before
firmware loads or after...).
But I assume that adding the high on reset pin shouldn't break anything,
so we can do this.

And shouldn't we put tuner reset pin to 0 when in composite and s-video mode?
These inputs don't use tuner or do they?
If I look in dmesg I can see that firmware is loaded into tuner even
when these modes are used (I'm using MPlayer to select the input).
And due to callbacks issued duting firmware loading, tuner is turned on
(reset pin = 1) no matter if it was turned off by .gpioX setting.

And shouldn't we use the mask bits [24:16] of MO_GPX_IO
in .gpioX members too? I know only few GPIO pins and the other I don't
know either what direction they should be. That means GPIO pins which
I don't know are set as Hi-Z = inputs... Now, when I think of that,
if it works it's safer when the other pins are in Hi-Z mode. Never mind.

>
> Then the reset can be done with:
>
> case XC2028_TUNER_RESET:
> /* GPIO 12 (xc3028 tuner reset) */
> cx_write(MO_GP1_IO, 0x101000);
> mdelay(50);
> cx_write(MO_GP1_IO, 0x101010);
> mdelay(50);
> return 0;
>
Earlier I was told to use 'cx_set' and 'cx_clear' because using 'cx_write'
is risky.
see here: http://www.spinics.net/lists/linux-dvb/msg29777.html
And when you are using 'cx_set' and 'cx_clear' you need 3 calls.
The first to set the direction bit, the second to set 0 on reset pin
and the third to set 1 on reset pin.
If you ask me which I think is nicer I'll tell you: that one with 'cx_write'.
If you ask me which one I want to use, I'll tell: I don't care. :)

> Though I have to wonder why each card needs its own xc2028 reset function.
> Shouldn't they all be the same other than what gpio they change?
My English goes lame here. Do you mean that reset function shouldn't use
GPIO at all?

>
> @@ -2882,6 +2946,16 @@
> cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
> udelay(1000);
> break;
> +
> + case CX88_BOARD_WINFAST_DTV1800H:
> + /* GPIO 12 (xc3028 tuner reset) */
> + cx_set(MO_GP1_IO, 0x1010);
> + mdelay(50);
> + cx_clear(MO_GP1_IO, 0x10);
> + mdelay(50);
> + cx_set(MO_GP1_IO, 0x10);
> + mdelay(50);
> + break;
> }
> }
>
> Couldn't you replace this with:
>
> case CX88_BOARD_WINFAST_DTV1800H:
> cx88_xc3028_winfast1800h_callback(code, XC2028_TUNER_RESET, 0);
> break;
Yes, this will do the same job.
I think that 'cx88_card_setup_pre_i2c' is to be called before any I2C
communication. The 'cx88_xc3028_winfast1800h_callback' (cx88_tuner_callback)
is meant to be used when tuner code (during firmware loading) needs it.
This is probably why others did it this way (these are separated issues
even if they do the same thing) and I only obey existing form.

I only want to finally add the support for this card.
You know many people (not developers) don't care "if this function is used
or that function is used twice, instead". They just want to install they distro
and watch the tv.
I classify myself as an programmer rather than ordinary user, so I care how
the code looks like. I'm open to the discussion about these things, but
this can take long time and I just want the card to be supported asap.
There are more cards which has code like this so if linuxtv developers realize
eg. to not use callbacks or use only cx_set and cx_clear (instead of cx_write)
they'll do it all at once (not every card separately).

I attached modified patch:
- .gpioX members of inputs which use tuner have reset pin 1 (tuner enabled)
- .gpioX members of inputs which don't use tuner have reset pin 0 (tuner disabled)
- resets (in callback and the one in pre_i2c) use only two 'cx_write' calls

I'm keeping the "tested-by" lines even if this modified version of patch wasn't
tested by those people (the previous version was). I trust this changes can't
break the functionality.
If you think it's too audacious then drop them.

It's on linuxtv developers which of these two patches will be chosen.

- Miroslav Šustek


---------=_54A55242.50D378D
Content-Type: application/octet-stream; name="leadtek_winfast_dtv1800h_v2.patch"
Content-Transfer-Encoding: base64

QWRkcyBzdXBwb3J0IGZvciBMZWFkdGVrIFdpbkZhc3QgRFRWLTE4MDBICgpGcm9tOiBNaXJv
c2xhdiBTdXN0ZWsgPHN1c3RtaWRvd25AY2VudHJ1bS5jej4KCkVuYWJsZXMgYW5hbG9nL2Rp
Z2l0YWwgdHYsIHJhZGlvIGFuZCByZW1vdGUgY29udHJvbCAoZ3BpbykuCgpTaWduZWQtb2Zm
LWJ5OiBNaXJvc2xhdiBTdXN0ZWsgPHN1c3RtaWRvd25AY2VudHJ1bS5jej4KVGVzdGVkLWJ5
OiBNYXJjaW4gV29qY2lrb3dza2kgPGVtdGVlcy5tdHNAZ21haWwuY29tPgpUZXN0ZWQtYnk6
IEthcmVsIEp1aGFuYWsgPGthcmVsLmp1aGFuYWtAd2FybmV0LmN6PgpUZXN0ZWQtYnk6IEFu
ZHJldyBHb2ZmIDxnb2ZmYTcyQGdtYWlsLmNvbT4KVGVzdGVkLWJ5OiBKYW4gTm92YWsgPG5v
dmFrLWpAc2V6bmFtLmN6PgoKZGlmZiAtciAyNWJjMDU4MDM1OWEgbGludXgvRG9jdW1lbnRh
dGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5jeDg4Ci0tLSBhL2xpbnV4L0RvY3VtZW50YXRp
b24vdmlkZW80bGludXgvQ0FSRExJU1QuY3g4OAlGcmkgTWF5IDI5IDE3OjAzOjMxIDIwMDkg
LTAzMDAKKysrIGIvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5j
eDg4CVN1biBNYXkgMzEgMTg6NDQ6MDUgMjAwOSArMDIwMApAQCAtNzksMyArNzksNCBAQAog
IDc4IC0+IFByb2YgNjIwMCBEVkItUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBbYjAyMjozMDIyXQogIDc5IC0+IFRlcnJhdGVjIENpbmVyZ3kgSFQgUENJIE1LSUkg
ICAgICAgICAgICAgICAgICAgICAgICBbMTUzYjoxMTc3XQogIDgwIC0+IEhhdXBwYXVnZSBX
aW5UVi1JUiBPbmx5ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBbMDA3MDo5MjkwXQor
IDgxIC0+IExlYWR0ZWsgV2luRmFzdCBEVFYxODAwIEh5YnJpZCAgICAgICAgICAgICAgICAg
ICAgICBbMTA3ZDo2NjU0XQpkaWZmIC1yIDI1YmMwNTgwMzU5YSBsaW51eC9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2N4ODgvY3g4OC1jYXJkcy5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3g4OC9jeDg4LWNhcmRzLmMJRnJpIE1heSAyOSAxNzowMzozMSAyMDA5IC0wMzAw
CisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWNhcmRzLmMJU3Vu
IE1heSAzMSAxODo0NDowNSAyMDA5ICswMjAwCkBAIC0yMDA5LDYgKzIwMDksNDcgQEAKIAkJ
LnR1bmVyX2FkZHIJPSBBRERSX1VOU0VULAogCQkucmFkaW9fYWRkcgk9IEFERFJfVU5TRVQs
CiAJfSwKKwlbQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjE4MDBIXSA9IHsKKwkJLm5hbWUgICAg
ICAgICAgID0gIkxlYWR0ZWsgV2luRmFzdCBEVFYxODAwIEh5YnJpZCIsCisJCS50dW5lcl90
eXBlICAgICA9IFRVTkVSX1hDMjAyOCwKKwkJLnJhZGlvX3R5cGUgICAgID0gVFVORVJfWEMy
MDI4LAorCQkudHVuZXJfYWRkciAgICAgPSAweDYxLAorCQkucmFkaW9fYWRkciAgICAgPSAw
eDYxLAorCQkvKgorCQkgKiBHUElPIHNldHRpbmcKKwkJICoKKwkJICogIDI6IG11dGUgKDA9
b2ZmLDE9b24pCisJCSAqIDEyOiB0dW5lciByZXNldCBwaW4KKwkJICogMTM6IGF1ZGlvIHNv
dXJjZSAoMD10dW5lciBhdWRpbywxPWxpbmUgaW4pCisJCSAqIDE0OiBGTSAoMD1vbiwxPW9m
ZiA/Pz8pCisJCSAqLworCQkuaW5wdXQgICAgICAgICAgPSB7eworCQkJLnR5cGUgICA9IENY
ODhfVk1VWF9URUxFVklTSU9OLAorCQkJLnZtdXggICA9IDAsCisJCQkuZ3BpbzAgID0gMHgw
NDAwLCAgICAgICAvKiBwaW4gMiA9IDAgKi8KKwkJCS5ncGlvMSAgPSAweDcwNTAsICAgICAg
IC8qIHAxMiA9IDEsIHAxMyA9IDAsIHAxNCA9IDEgKi8KKwkJCS5ncGlvMiAgPSAweDAwMDAs
CisJCX0sIHsKKwkJCS50eXBlICAgPSBDWDg4X1ZNVVhfQ09NUE9TSVRFMSwKKwkJCS52bXV4
ICAgPSAxLAorCQkJLmdwaW8wICA9IDB4MDQwMCwgICAgICAgLyogcGluIDIgPSAwICovCisJ
CQkuZ3BpbzEgID0gMHg3MDYwLCAgICAgICAvKiBwMTIgPSAwLCBwMTMgPSAxLCBwMTQgPSAx
ICovCisJCQkuZ3BpbzIgID0gMHgwMDAwLAorCQl9LCB7CisJCQkudHlwZSAgID0gQ1g4OF9W
TVVYX1NWSURFTywKKwkJCS52bXV4ICAgPSAyLAorCQkJLmdwaW8wICA9IDB4MDQwMCwgICAg
ICAgLyogcGluIDIgPSAwICovCisJCQkuZ3BpbzEgID0gMHg3MDYwLCAgICAgICAvKiBwMTIg
PSAwLCBwMTMgPSAxLCBwMTQgPSAxICovCisJCQkuZ3BpbzIgID0gMHgwMDAwLAorCQl9IH0s
CisJCS5yYWRpbyA9IHsKKwkJCS50eXBlICAgPSBDWDg4X1JBRElPLAorCQkJLmdwaW8wICA9
IDB4MDQwMCwgICAgICAgLyogcGluIDIgPSAwICovCisJCQkuZ3BpbzEgID0gMHg3MDEwLCAg
ICAgICAvKiBwMTIgPSAxLCBwMTMgPSAwLCBwMTQgPSAwICovCisJCQkuZ3BpbzIgID0gMHgw
MDAwLAorCQl9LAorCQkubXBlZyAgICAgICAgICAgPSBDWDg4X01QRUdfRFZCLAorCX0sCiB9
OwogCiAvKiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8KQEAgLTI0MjYsNiArMjQ2NywxMCBAQAogCQkuc3Vi
dmVuZG9yID0gMHgwMDcwLAogCQkuc3ViZGV2aWNlID0gMHg5MjkwLAogCQkuY2FyZCAgICAg
ID0gQ1g4OF9CT0FSRF9IQVVQUEFVR0VfSVJPTkxZLAorCX0sIHsKKwkJLnN1YnZlbmRvciA9
IDB4MTA3ZCwKKwkJLnN1YmRldmljZSA9IDB4NjY1NCwKKwkJLmNhcmQgICAgICA9IENYODhf
Qk9BUkRfV0lORkFTVF9EVFYxODAwSCwKIAl9LAogfTsKIApAQCAtMjYyNCw2ICsyNjY5LDIx
IEBACiAJcmV0dXJuIC1FSU5WQUw7CiB9CiAKK3N0YXRpYyBpbnQgY3g4OF94YzMwMjhfd2lu
ZmFzdDE4MDBoX2NhbGxiYWNrKHN0cnVjdCBjeDg4X2NvcmUgKmNvcmUsCisJCQkJCSAgICAg
aW50IGNvbW1hbmQsIGludCBhcmcpCit7CisJc3dpdGNoIChjb21tYW5kKSB7CisJY2FzZSBY
QzIwMjhfVFVORVJfUkVTRVQ6CisJCS8qIEdQSU8gMTIgKHhjMzAyOCB0dW5lciByZXNldCkg
Ki8KKwkJY3hfd3JpdGUoTU9fR1AxX0lPLCAweDEwMTAwMCk7CisJCW1kZWxheSg1MCk7CisJ
CWN4X3dyaXRlKE1PX0dQMV9JTywgMHgxMDEwMTApOworCQltZGVsYXkoNTApOworCQlyZXR1
cm4gMDsKKwl9CisJcmV0dXJuIC1FSU5WQUw7Cit9CisKIC8qIC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8K
IC8qIHNvbWUgRGl2Y28gc3BlY2lmaWMgc3R1ZmYgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKi8KIHN0YXRpYyBpbnQgY3g4OF9wdl84MDAwZ3RfY2FsbGJh
Y2soc3RydWN0IGN4ODhfY29yZSAqY29yZSwKQEAgLTI2OTYsNiArMjc1Niw4IEBACiAJY2Fz
ZSBDWDg4X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfUFJPOgogCWNhc2UgQ1g4OF9C
T0FSRF9EVklDT19GVVNJT05IRFRWXzVfUENJX05BTk86CiAJCXJldHVybiBjeDg4X2R2aWNv
X3hjMjAyOF9jYWxsYmFjayhjb3JlLCBjb21tYW5kLCBhcmcpOworCWNhc2UgQ1g4OF9CT0FS
RF9XSU5GQVNUX0RUVjE4MDBIOgorCQlyZXR1cm4gY3g4OF94YzMwMjhfd2luZmFzdDE4MDBo
X2NhbGxiYWNrKGNvcmUsIGNvbW1hbmQsIGFyZyk7CiAJfQogCiAJc3dpdGNoIChjb21tYW5k
KSB7CkBAIC0yODgyLDYgKzI5NDQsMTQgQEAKIAkJY3hfc2V0KE1PX0dQMF9JTywgMHgwMDAw
MDA4MCk7IC8qIDcwMiBvdXQgb2YgcmVzZXQgKi8KIAkJdWRlbGF5KDEwMDApOwogCQlicmVh
azsKKworCWNhc2UgQ1g4OF9CT0FSRF9XSU5GQVNUX0RUVjE4MDBIOgorCQkvKiBHUElPIDEy
ICh4YzMwMjggdHVuZXIgcmVzZXQpICovCisJCWN4X3dyaXRlKE1PX0dQMV9JTywgMHgxMDEw
MDApOworCQltZGVsYXkoNTApOworCQljeF93cml0ZShNT19HUDFfSU8sIDB4MTAxMDEwKTsK
KwkJbWRlbGF5KDUwKTsKKwkJYnJlYWs7CiAJfQogfQogCkBAIC0yOTAyLDYgKzI5NzIsNyBA
QAogCQkJY29yZS0+aTJjX2FsZ28udWRlbGF5ID0gMTY7CiAJCWJyZWFrOwogCWNhc2UgQ1g4
OF9CT0FSRF9EVklDT19GVVNJT05IRFRWX0RWQl9UX1BSTzoKKwljYXNlIENYODhfQk9BUkRf
V0lORkFTVF9EVFYxODAwSDoKIAkJY3RsLT5kZW1vZCA9IFhDMzAyOF9GRV9aQVJMSU5LNDU2
OwogCQlicmVhazsKIAljYXNlIENYODhfQk9BUkRfS1dPUkxEX0FUU0NfMTIwOgpkaWZmIC1y
IDI1YmMwNTgwMzU5YSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1kdmIu
YwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1kdmIuYwlGcmkg
TWF5IDI5IDE3OjAzOjMxIDIwMDkgLTAzMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92
aWRlby9jeDg4L2N4ODgtZHZiLmMJU3VuIE1heSAzMSAxODo0NDowNSAyMDA5ICswMjAwCkBA
IC0xMDIxLDYgKzEwMjEsNyBAQAogCQl9CiAJCWJyZWFrOwogCSBjYXNlIENYODhfQk9BUkRf
UElOTkFDTEVfSFlCUklEX1BDVFY6CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgw
MEg6CiAJCWZlMC0+ZHZiLmZyb250ZW5kID0gZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwK
IAkJCQkJICAgICAgICZjeDg4X3Bpbm5hY2xlX2h5YnJpZF9wY3R2LAogCQkJCQkgICAgICAg
JmNvcmUtPmkyY19hZGFwKTsKZGlmZiAtciAyNWJjMDU4MDM1OWEgbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9jeDg4L2N4ODgtaW5wdXQuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlh
L3ZpZGVvL2N4ODgvY3g4OC1pbnB1dC5jCUZyaSBNYXkgMjkgMTc6MDM6MzEgMjAwOSAtMDMw
MAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1pbnB1dC5jCVN1
biBNYXkgMzEgMTg6NDQ6MDUgMjAwOSArMDIwMApAQCAtOTIsNiArOTIsNyBAQAogCQlncGlv
PShncGlvICYgMHg3ZmQpICsgKGF1eGdwaW8gJiAweGVmKTsKIAkJYnJlYWs7CiAJY2FzZSBD
WDg4X0JPQVJEX1dJTkZBU1RfRFRWMTAwMDoKKwljYXNlIENYODhfQk9BUkRfV0lORkFTVF9E
VFYxODAwSDoKIAljYXNlIENYODhfQk9BUkRfV0lORkFTVF9UVjIwMDBfWFBfR0xPQkFMOgog
CQlncGlvID0gKGdwaW8gJiAweDZmZikgfCAoKGN4X3JlYWQoTU9fR1AxX0lPKSA8PCA4KSAm
IDB4OTAwKTsKIAkJYXV4Z3BpbyA9IGdwaW87CkBAIC0yMzcsNiArMjM4LDcgQEAKIAkJaXIt
PnNhbXBsaW5nID0gMTsKIAkJYnJlYWs7CiAJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRW
MjAwMEg6CisJY2FzZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRWMTgwMEg6CiAJCWlyX2NvZGVz
ID0gaXJfY29kZXNfd2luZmFzdDsKIAkJaXItPmdwaW9fYWRkciA9IE1PX0dQMF9JTzsKIAkJ
aXItPm1hc2tfa2V5Y29kZSA9IDB4OGY4OwpkaWZmIC1yIDI1YmMwNTgwMzU5YSBsaW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3g4OC9jeDg4LmgJRnJpIE1heSAyOSAxNzowMzozMSAyMDA5IC0wMzAwCisr
KyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LmgJU3VuIE1heSAzMSAx
ODo0NDowNSAyMDA5ICswMjAwCkBAIC0yMzcsNiArMjM3LDcgQEAKICNkZWZpbmUgQ1g4OF9C
T0FSRF9QUk9GXzYyMDAgICAgICAgICAgICAgICA3OAogI2RlZmluZSBDWDg4X0JPQVJEX1RF
UlJBVEVDX0NJTkVSR1lfSFRfUENJX01LSUkgNzkKICNkZWZpbmUgQ1g4OF9CT0FSRF9IQVVQ
UEFVR0VfSVJPTkxZICAgICAgICA4MAorI2RlZmluZSBDWDg4X0JPQVJEX1dJTkZBU1RfRFRW
MTgwMEggICAgICAgIDgxCiAKIGVudW0gY3g4OF9pdHlwZSB7CiAJQ1g4OF9WTVVYX0NPTVBP
U0lURTEgPSAxLAp=

---------=_54A55242.50D378D--
