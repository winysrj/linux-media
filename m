Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:51422 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbeCXNlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Mar 2018 09:41:42 -0400
Received: by mail-wm0-f52.google.com with SMTP id v21so8113813wmc.1
        for <linux-media@vger.kernel.org>; Sat, 24 Mar 2018 06:41:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCHv2 0/3] dw-hdmi: add property to disable CEC
From: Neil Armstrong <narmstrong@baylibre.com>
In-Reply-To: <CAFBinCA-x=4J_a_+oJX7fxhXO0qP=apEPFesATP=UNsH91qiCw@mail.gmail.com>
Date: Sat, 24 Mar 2018 14:41:38 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F857A55-296E-4AFF-8375-3165D0B3DAB4@baylibre.com>
References: <20180323125915.13986-1-hverkuil@xs4all.nl>
 <CAFBinCA-x=4J_a_+oJX7fxhXO0qP=apEPFesATP=UNsH91qiCw@mail.gmail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

> Le 24 mars 2018 =C3=A0 12:00, Martin Blumenstingl =
<martin.blumenstingl@googlemail.com> a =C3=A9crit :
>=20
> Hello Hans, Hi Neil,
>=20
> (apologies in advance if any of this is wrong, I don't have any CEC
> capable TV so I can't test it)
>=20
> On Fri, Mar 23, 2018 at 1:59 PM, Hans Verkuil <hverkuil@xs4all.nl> =
wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>=20
>> Some boards (amlogic) have two CEC controllers: the DesignWare =
controller
>> and their own CEC controller (meson ao-cec).
> as far as I understand the Amlogic Meson SoCs have two domains:
> - AO (always-on, powered even in suspend mode) where meson-ao-cec can
> wake up the system from suspend
> - EE (everything else, not powered during suspend) where dw-hdmi-cec =
lives
>=20

Exact, except =E2=80=A6 the EE CEC is not hooked to the DW-HDMI TX but =
the RX, and thus cannot be used on GXBB/GXL/GXM.

> this far everything is OK
>=20
>> Since the CEC line is not hooked up to the DW controller we need a =
way
>> to disable that controller. This patch series adds the cec-disable
>> property for that purpose.
> drivers/pinctrl/meson/pinctrl-meson-gxbb.c has ao_cec_pins and
> ee_cec_pins, both use GPIOAO_12
> drivers/pinctrl/meson/pinctrl-meson-gxl.c has ao_cec_pins and
> ee_cec_pins, both use GPIOAO_8
>=20
> @Neil: do you know if the CEC signal routing is:
> ao_cec_pins -> meson-ao-cec
> ee_cec_pins -> dw-hdmi-cec

It=E2=80=99s hooked to the DW-HDMI RX IP used in the TV SoCs.

>=20
> I'm curious because if both CEC controllers can be used then it might
> be worth mentioning this in the cover-letter and patch description
>=20

Initially I thought it was hooked to the DW-HDMI TX, but no, I guess I =
should remove the ee_cec pinmux=E2=80=A6

Neil

>=20
> Regards
> Martin
