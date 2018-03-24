Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:45493 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbeCXOZ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Mar 2018 10:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <3F857A55-296E-4AFF-8375-3165D0B3DAB4@baylibre.com>
References: <20180323125915.13986-1-hverkuil@xs4all.nl> <CAFBinCA-x=4J_a_+oJX7fxhXO0qP=apEPFesATP=UNsH91qiCw@mail.gmail.com>
 <3F857A55-296E-4AFF-8375-3165D0B3DAB4@baylibre.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 24 Mar 2018 15:25:04 +0100
Message-ID: <CAFBinCBANX8migKfktPS3iC3KMrpWRkHmPwdZCXVGEsNh4BgPA@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] dw-hdmi: add property to disable CEC
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

On Sat, Mar 24, 2018 at 2:41 PM, Neil Armstrong <narmstrong@baylibre.com> w=
rote:
> Hi Martin,
>
>> Le 24 mars 2018 =C3=A0 12:00, Martin Blumenstingl <martin.blumenstingl@g=
ooglemail.com> a =C3=A9crit :
>>
>> Hello Hans, Hi Neil,
>>
>> (apologies in advance if any of this is wrong, I don't have any CEC
>> capable TV so I can't test it)
>>
>> On Fri, Mar 23, 2018 at 1:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Some boards (amlogic) have two CEC controllers: the DesignWare controll=
er
>>> and their own CEC controller (meson ao-cec).
>> as far as I understand the Amlogic Meson SoCs have two domains:
>> - AO (always-on, powered even in suspend mode) where meson-ao-cec can
>> wake up the system from suspend
>> - EE (everything else, not powered during suspend) where dw-hdmi-cec liv=
es
>>
>
> Exact, except =E2=80=A6 the EE CEC is not hooked to the DW-HDMI TX but th=
e RX, and thus cannot be used on GXBB/GXL/GXM.
I see, thank you for the explanation

>> this far everything is OK
>>
>>> Since the CEC line is not hooked up to the DW controller we need a way
>>> to disable that controller. This patch series adds the cec-disable
>>> property for that purpose.
>> drivers/pinctrl/meson/pinctrl-meson-gxbb.c has ao_cec_pins and
>> ee_cec_pins, both use GPIOAO_12
>> drivers/pinctrl/meson/pinctrl-meson-gxl.c has ao_cec_pins and
>> ee_cec_pins, both use GPIOAO_8
>>
>> @Neil: do you know if the CEC signal routing is:
>> ao_cec_pins -> meson-ao-cec
>> ee_cec_pins -> dw-hdmi-cec
>
> It=E2=80=99s hooked to the DW-HDMI RX IP used in the TV SoCs.
>
>>
>> I'm curious because if both CEC controllers can be used then it might
>> be worth mentioning this in the cover-letter and patch description
>>
>
> Initially I thought it was hooked to the DW-HDMI TX, but no, I guess I sh=
ould remove the ee_cec pinmux=E2=80=A6
right, or rename it to ee_cec_rx (or something similar)


Regards
Martin
