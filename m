Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56567 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2GZMtA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 08:49:00 -0400
Received: by weyx8 with SMTP id x8so1309590wey.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 05:48:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzF8onCqoxv-xkZY3YUiUjgjokkstB5eSX8YKELYDrjag@mail.gmail.com>
References: <500C5B9B.8000303@iki.fi>
	<CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
	<500F1DC5.1000608@iki.fi>
	<CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
	<CAOcJUbzJjBBMcLmeaOCsJRz44KVPqZ_sGctG8+ai=n1W+9P9xA@mail.gmail.com>
	<500F4140.1000202@iki.fi>
	<CAOcJUbzF8onCqoxv-xkZY3YUiUjgjokkstB5eSX8YKELYDrjag@mail.gmail.com>
Date: Thu, 26 Jul 2012 08:48:58 -0400
Message-ID: <CAOcJUbw4O_rHCN6PgXc7=XU5ZToTB3QqAWLPUPhW-TZZVZ9X5w@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f3bab97ef284b04c5bb0471
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--e89a8f3bab97ef284b04c5bb0471
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 25, 2012 at 11:18 PM, Michael Krufky <mkrufky@linuxtv.org> wrot=
e:
> On Tue, Jul 24, 2012 at 8:43 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 07/25/2012 03:15 AM, Michael Krufky wrote:
>>>
>>> On Tue, Jul 24, 2012 at 6:17 PM, Michael Krufky <mkrufky@linuxtv.org>
>>> wrote:
>>>>
>>>> On Tue, Jul 24, 2012 at 6:12 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>
>>>>> On 07/25/2012 12:55 AM, Michael Krufky wrote:
>>>>>>
>>>>>>
>>>>>> On Sun, Jul 22, 2012 at 3:59 PM, Antti Palosaari <crope@iki.fi> wrot=
e:
>>>>>>>
>>>>>>>
>>>>>>> Moi Michael,
>>>>>>> I just realized tda18271 driver eats 160mA too much current after
>>>>>>> attach.
>>>>>>> This means, there is power management bug.
>>>>>>>
>>>>>>> When I plug my nanoStick it eats total 240mA, after tda18271 sleep =
is
>>>>>>> called
>>>>>>> it eats only 80mA total which is reasonable. If I use Digital Devic=
es
>>>>>>> tda18271c2dd driver it is total 110mA after attach, which is also
>>>>>>> quite
>>>>>>> OK.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Thanks for the report -- I will take a look at it.
>>>>>>
>>>>>> ...patches are welcome, of course :-)
>>>>>
>>>>>
>>>>>
>>>>> I suspect it does some tweaking on attach() and chip leaves powered (=
I
>>>>> saw
>>>>> demod debugs at calls I2C-gate control quite many times thus this
>>>>> suspicion). When chip is powered-up it is usually in some sleep state=
 by
>>>>> default. Also, on attach() there should be no I/O unless very good
>>>>> reason.
>>>>> For example chip ID is allowed to read and download firmware in case =
it
>>>>> is
>>>>> really needed to continue - like for tuner communication.
>>>>>
>>>>>
>>>>> What I found quickly testing few DVB USB sticks there seems to be ver=
y
>>>>> much
>>>>> power management problems... I am now waiting for new multimeter in
>>>>> order to
>>>>> make better measurements and likely return fixing these issues later.
>>>>
>>>>
>>>> The driver does some calibration during attach, some of which is a
>>>> one-time initialization to determine a temperature differential for
>>>> tune calculation later on, which can take some time on slower USB
>>>> buses.  The "fix" for the power usage issue would just be to make sure
>>>> to sleep the device before exiting the attach() function.
>>>>
>>>> I'm not looking to remove the calibration from the attach -- this was
>>>> done on purpose.
>>>>
>>>
>>> Antti,
>>>
>>> After looking again, I realize that we are purposefully not sleeping
>>> the device before we exit the attach() function.
>>>
>>> The tda18271 is commonly found in multi-chip designs that may or may
>>> not include an analog demodulator and / or other tda18271 tuners.  In
>>> such designs, the chips tend to be daisy-chained to each other, using
>>> the xtal output and loop-thru features of the tda18271.  We set the
>>> required features in the attach-time configuration structure.
>>> However, we must keep in mind that this is a hybrid tuner chip, and
>>> the analog side of the bridge driver may actually come up before the
>>> digital side.  Since the actual configuration tends to be done in the
>>> digital bring-up, the analog side is brought up within tuner.ko using
>>> the most generic one-size-fits all configuration, which gets
>>> overridden when the digital side initializes.
>>>
>>> It is absolutely crucial that if we actually need the xtal output
>>> feature enabled, that it must *never* be turned off, otherwise the i2c
>>> bus may get wedged unrecoverably.  So, we make sure to leave this
>>> feature enabled during the attach function, since we don't yet know at
>>> that point whether there is another "instance" of this same tuner yet
>>> to be initialized.  It is not safe to power off that feature until
>>> after we are sure that the bridge has completely initialized.
>>>
>>> In order to rectify this issue from within your driver, you should
>>> call sleep after you complete the attach.  For instance, this is what
>>> we do in the cx23885 driver:
>>>
>>> if (fe0->dvb.frontend->ops.analog_ops.standby)
>>>
>>> fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);
>>>
>>>
>>> ...except you should call into the tuner_ops->sleep() function instead
>>> of analog_demod_ops->standby()
>>>
>>> Does this clear things up for you?
>>
>>
>> Surely this is possible and it will resolve power drain issue. But it is=
 not
>> nice looking and causes more deviation compared to others.
>>
>> Could you add configuration option "bool do_not_powerdown_on_attach" ?
>>
>> I have quite many tda18271 devices here and all those are DVB only=CC=A3=
 (OK,
>> PCTV 520e is DVB + analog, but analog is not supported). Having
>> configuration parameter sounds like better plan.
>
> Come to think of it, since the generic "one-size-fits-all"
> configuration leaves the loop thru and xtal output enabled, it should
> be safe to go to the lowest power level allowed (based on the
> configuration) at the end of the attach() function.  I'll put up a
> patch within the next few days...  Thanks for noticing this, Antti.
> :-)
>
> We wont need to add any new configuration option :-)
>
> -Mike

Antti,

This small patch should do the trick -- can you test it?


The following changes since commit 0c7d5a6da75caecc677be1fda207b7578936770d=
:

  Linux 3.5-rc5 (2012-07-03 22:57:41 +0300)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/tuners tda18271

for you to fetch changes up to 782b28e20d3b253d317cc71879639bf3c108b200:

  tda18271: enter low-power standby mode at the end of
tda18271_attach() (2012-07-26 08:34:37 -0400)

----------------------------------------------------------------
Michael Krufky (1):
      tda18271: enter low-power standby mode at the end of tda18271_attach(=
)

 drivers/media/common/tuners/tda18271-fe.c |    3 +++
 1 file changed, 3 insertions(+)





Cheers,

Mike

--e89a8f3bab97ef284b04c5bb0471
Content-Type: application/octet-stream;
	name="0001-tda18271-enter-low-power-standby-mode-at-the-end-of-.patch"
Content-Disposition: attachment;
	filename="0001-tda18271-enter-low-power-standby-mode-at-the-end-of-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h53u8lg10

RnJvbSA3ODJiMjhlMjBkM2IyNTNkMzE3Y2M3MTg3OTYzOWJmM2MxMDhiMjAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIEtydWZreSA8bWtydWZreUBsaW51eHR2Lm9yZz4K
RGF0ZTogVGh1LCAyNiBKdWwgMjAxMiAwODozNDozNyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIHRk
YTE4MjcxOiBlbnRlciBsb3ctcG93ZXIgc3RhbmRieSBtb2RlIGF0IHRoZSBlbmQgb2YKIHRkYTE4
MjcxX2F0dGFjaCgpCgpFbnN1cmUgdGhhdCB1bm5lY2Vzc2FyeSBmZWF0dXJlcyBhcmUgcG93ZXJl
ZCBkb3duIGF0IHRoZSBlbmQgb2YgdGhlCmF0dGFjaCgpIGZ1bmN0aW9uLiAgSWYgdGhlIGNvbmZp
Z3VyYXRpb24gcmVxdWlyZXMgdGhlIGxvb3AgdGhydSBvcgp4dG91dCBmZWF0dXJlcywgdGhleSB3
aWxsIHJlbWFpbiBlbmFibGVkLgoKVGhhbmtzIHRvIEFudHRpIFBhbG9zYWFyaSBmb3Igbm90aWNp
bmcgdGhlIGFkZGl0aW9uYWwgcG93ZXIgY29uc3VtcHRpb24uCgpDYzogQW50dGkgUGFsb3NhYXJp
IDxjcm9wZUBpa2kuZmk+ClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgS3J1Zmt5IDxta3J1Zmt5QGxp
bnV4dHYub3JnPgotLS0KIGRyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90ZGExODI3MS1mZS5j
IHwgICAgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMvdGRhMTgyNzEtZmUuYyBiL2RyaXZlcnMvbWVk
aWEvY29tbW9uL3R1bmVycy90ZGExODI3MS1mZS5jCmluZGV4IDJlNjdmNDQuLjVmNWQ4NjYgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90ZGExODI3MS1mZS5jCisrKyBi
L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90ZGExODI3MS1mZS5jCkBAIC0xMzIzLDYgKzEz
MjMsOSBAQCBzdHJ1Y3QgZHZiX2Zyb250ZW5kICp0ZGExODI3MV9hdHRhY2goc3RydWN0IGR2Yl9m
cm9udGVuZCAqZmUsIHU4IGFkZHIsCiAJaWYgKHRkYTE4MjcxX2RlYnVnICYgKERCR19NQVAgfCBE
QkdfQURWKSkKIAkJdGRhMTgyNzFfZHVtcF9zdGRfbWFwKGZlKTsKIAorCXJldCA9IHRkYTE4Mjcx
X3NsZWVwKGZlKTsKKwl0ZGFfZmFpbChyZXQpOworCiAJcmV0dXJuIGZlOwogZmFpbDoKIAltdXRl
eF91bmxvY2soJnRkYTE4MjcxX2xpc3RfbXV0ZXgpOwotLSAKMS43LjkuNQoK
--e89a8f3bab97ef284b04c5bb0471--
