Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59577 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2EGVsH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 17:48:07 -0400
Message-ID: <4FA84313.3000104@iki.fi>
Date: Tue, 08 May 2012 00:48:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Modified RTL28xxU driver to work with RTL2832
References: <CAKZ=SG9U48d=eE3avccR-Auao5UMo0OANw8KKb=MP1XPtkHwmg@mail.gmail.com> <4FA8168E.3040807@googlemail.com> <4FA82244.9020804@iki.fi> <201205072328.34261.hfvogt@gmx.net>
In-Reply-To: <201205072328.34261.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.05.2012 00:28, Hans-Frieder Vogt wrote:
> Am Montag, 7. Mai 2012 schrieb Antti Palosaari:
>> On 07.05.2012 21:38, Thomas Mair wrote:
>>> On 07.05.2012 09:59, Antti Palosaari wrote:
>>>>> @@ -330,12 +335,12 @@ static int rtl2831u_frontend_attach(struct
>>>>> dvb_usb_adapter *adap)
>>>>>
>>>>>         /* check QT1010 ID(?) register; reg=0f val=2c */
>>>>>         ret = rtl28xxu_ctrl_msg(adap->dev,&req_qt1010);
>>>>>         if (ret == 0&&    buf[0] == 0x2c) {
>>>>>
>>>>> -        priv->tuner = TUNER_RTL2830_QT1010;
>>>>> +        priv->tuner = TUNER_RTL28XX_QT1010;
>>>>
>>>> The idea why I named it as a TUNER_RTL2830_QT1010 was to map RTL2830 and
>>>> given tuner. It could be nice to identify used demod/tuner combination
>>>> in some cases if there will even be such combination same tuner used
>>>> for multiple RTL28XXU chips.
>>>
>>> Ok. Should we use the TUNER_RTL2830/TUNER_RTL2832 approach or the
>>> RUNER_RTL28XX?
>>
>> I vote for style example; RTL2830_QT1010 versus RTL2832_QT1010, just in
>> case same tuner could be used for multiple configurations.
>>
>> But it is not big issue for RTL2830 as it supports only 3 tuners
>> currently - and there will not be likely any new. But there is some
>> other RTL28XXU chips, like DVB-C model and etc.
>>
>
> Antti, Thomas,
>
> I don't understand why it should be benefitial to distinguish between e.g. the
> qt1010 connected to the RTL2830 or connected to the RTL2832. After all, the
> demodulator knows which type it is, so there is no need to keep the
> combination demodulator_tuner. And I find it rather confusing to have the same
> tuner defined for either demod.

For my it sounds better to save it as a DEMOD+TUNER combination. You 
will not likely see any same tuner used with RTL2830 and RTL2832 but 
instead those other newer demods like RTL2832, RTL2840, RTL2836B, etc.

It is not big issue, almost no mean at all...

>>>>> +#define RTL28XXU_TUNERS_H
>>>>> +
>>>>> +enum rtl28xxu_tuner {
>>>>> +       TUNER_NONE,
>>>>> +       TUNER_RTL28XX_QT1010,
>>>>> +       TUNER_RTL28XX_MT2060,
>>>>> +       TUNER_RTL28XX_MT2266,
>>>>> +       TUNER_RTL28XX_MT2063,
>>>>> +       TUNER_RTL28XX_MAX3543,
>>>>> +       TUNER_RTL28XX_TUA9001,
>>>>> +       TUNER_RTL28XX_MXL5005S,
>>>>> +       TUNER_RTL28XX_MXL5007T,
>>>>> +       TUNER_RTL28XX_FC2580,
>>>>> +       TUNER_RTL28XX_FC0012,
>>>>> +       TUNER_RTL28XX_FC0013,
>>>>> +       TUNER_RTL28XX_E4000,
>>>>> +       TUNER_RTL28XX_TDA18272,
>>>>> +};
>>>>> +
>>>>> +#endif
>>>>
>>>> I don't see it good idea to export tuners from the DVB-USB-driver to the
>>>> demodulator. Demod drivers should be independent. For the other
>>>> direction it is OK, I mean you can add tuners for demod config
>>>> (rtl2832.h).
>>>
>>> Ok. So the definitions of the tuners would go into the rtl2830.h and
>>> rtl2832.h.
>>
>> Put those to the demod as a af9013 and af9033 for example has. rtl2830.h
>> does not need to know tuner at all, not need to add.
>>
>
> what about renaming the header file to rtl283x_tuners.h, then it would be
> clearer that the tuners are not defined in the USB driver, but rather as part
> of all demod drivers available (ignore for a moment the rtl2840, which doesn't
> fit into the proposed naming scheme)?

Common tuners file between all Realtek demods sounds better. If you end 
up that then frontends/rtl28xx_tuners.h (or even 
frontends/rtl28xx_common.h so you can add some other common stuff here 
too) could be suitable name as it likely will fit better Realtek future 
chips naming scheme.

You can include header file from frontends/ to dvb-usb but for the other 
direction it is not so good idea as we want keep demodulators totally 
disconnected from the dvb-usb/ drivers. Demods are sold separately and 
it is up to time when there is new device using demod as a standalone 
without Realtek own USB-interface.

So after all I recommend to make rtl28xx common file for Realtek demods 
and put all tuners there. No need to pair demod+tuner, just commonly 
RTL28XX_QT1010, RTL28XX_FC0012, etc...

regards
Antti
-- 
http://palosaari.fi/
