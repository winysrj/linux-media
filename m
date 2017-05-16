Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33814 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdEPNzB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 09:55:01 -0400
Received: by mail-qk0-f173.google.com with SMTP id k74so130422134qke.1
        for <linux-media@vger.kernel.org>; Tue, 16 May 2017 06:55:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c1b7a339-7746-76ec-a1f4-e1bcd01fbdd0@xs4all.nl>
References: <1494939383-18937-1-git-send-email-benjamin.gaignard@linaro.org>
 <1494939383-18937-3-git-send-email-benjamin.gaignard@linaro.org> <c1b7a339-7746-76ec-a1f4-e1bcd01fbdd0@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 16 May 2017 15:54:59 +0200
Message-ID: <CA+M3ks6ndVPj9Z5xCkwZ6Ufk3o8OQn-sQAmSpYQmYcJDMT75Qw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] cec: add STM32 cec driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yannick Fertre <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-16 15:09 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Looks good, except for the logical address handling that I think is wrong=
:
>
> On 16/05/17 14:56, Benjamin Gaignard wrote:
>> This patch add cec driver for STM32 platforms.
>> cec hardware block isn't not always used with hdmi so
>> cec notifier is not implemented. That will be done later
>> when STM32 DSI driver will be available.
>>
>> Driver compliance has been tested with cec-ctl and cec-compliance
>> tools.
>>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
>> ---
>>  drivers/media/platform/Kconfig           |  11 +
>>  drivers/media/platform/Makefile          |   2 +
>>  drivers/media/platform/stm32/Makefile    |   1 +
>>  drivers/media/platform/stm32/stm32-cec.c | 384 ++++++++++++++++++++++++=
+++++++
>>  4 files changed, 398 insertions(+)
>>  create mode 100644 drivers/media/platform/stm32/Makefile
>>  create mode 100644 drivers/media/platform/stm32/stm32-cec.c
>>
>
> <snip>
>
>> +static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical=
_addr)
>> +{
>> +     struct stm32_cec *cec =3D adap->priv;
>> +
>> +     regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
>> +
>> +     if (logical_addr =3D=3D CEC_LOG_ADDR_INVALID)
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
>> +     else
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, OAR,
>> +                                (1 << logical_addr) << 16);
>> +
>> +     regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
>> +
>> +     return 0;
>> +}
>> +
>
> If you allocate more than one logical address, then stm32_cec_adap_log_ad=
dr()
> is called once for each LA. But right now the second call would overwrite
> the first LA. Right?
>
> Try 'cec-ctl --audio --playback' to allocate two logical addresses.

I will fix that in v3

>
> <snip>
>
>> +static int stm32_cec_monitor_all(struct cec_adapter *adap, bool enable)
>> +{
>> +     struct stm32_cec *cec =3D adap->priv;
>> +
>> +     regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
>> +
>> +     if (enable) {
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, OAR, OAR)
>
> You shouldn't have to change the OAR mask. This would have the adapter
> Ack all logical addresses.
>
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, LSTN, 0);
>> +     } else {
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
>
> And this would disable all logical addresses.
>
> I would expect that only the LSTN bit was changed.
>
> In monitoring mode it should still Ack any messages directed to us.

This is an impossible mix in my hardware: messages are received if
corresponding OAR
bit is set and acked if LSTN is set to 1.
It can't receive all messages and only ack some of them....

>
>> +             regmap_update_bits(cec->regmap, CEC_CFGR, LSTN, LSTN);
>> +     }
>> +
>> +     regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
>> +
>> +     return 0;
>> +}
>
> <snip>
>
> Regards,
>
>         Hans



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
