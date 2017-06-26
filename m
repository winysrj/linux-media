Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:32006 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFZGDS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 02:03:18 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v1 0/6] Add support of OV9655 camera
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
Date: Mon, 26 Jun 2017 08:02:31 +0200
Cc: Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA7BA0B2-F16F-4BEE-B2ED-7C452D7C4A6F@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com> <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

> Am 23.06.2017 um 12:25 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>=20
> Hi Hugues,
>=20
>> Am 22.06.2017 um 17:41 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>>=20
>>=20
>>> Am 22.06.2017 um 17:05 schrieb Hugues Fruchet =
<hugues.fruchet@st.com>:
>>>=20
>>> This patchset enables OV9655 camera support.
>>>=20
>>> OV9655 support has been tested using STM32F4DIS-CAM extension board
>>> plugged on connector P1 of STM32F746G-DISCO board.
>>> Due to lack of OV9650/52 hardware support, the modified related code
>>> could not have been checked for non-regression.
>>>=20
>>> First patches upgrade current support of OV9650/52 to prepare then
>>> introduction of OV9655 variant patch.
>>> Because of OV9655 register set slightly different from OV9650/9652,
>>> not all of the driver features are supported (controls). Supported
>>> resolutions are limited to VGA, QVGA, QQVGA.
>>> Supported format is limited to RGB565.
>>> Controls are limited to color bar test pattern for test purpose.
>>>=20
>>> OV9655 initial support is based on a driver written by H. Nikolaus =
Schaller [1].
>>=20
>> Great!
>=20
> Thanks again for picking up or work and trying to get it upstream.
>=20
>>=20
>> I will test as soon as possible.

Here are some more test results and fixes:

>=20
> I have tried and had to fix some issues first:
> * gpio properties have a different name than in our approach (but that =
is something maintainers have to decide and is easy to follow this or =
that way)
> * there is no clock-frequency property which makes the driver request =
a clock frequency (something our camera interface expects this way)

This can indeed be replaced by assigned-clock-rates and no additional
driver code. So there is no need to implement anything new here.

> * there is no vana-supply regulator and we need that to power on/off =
the camera on demand (reset and pwdn isn't enough in our hardware)

this is something we still need to have added by patch

=
<http://git.goldelico.com/?p=3Dgta04-kernel.git;a=3Dblobdiff;f=3Ddrivers/m=
edia/i2c/ov9650.c;h=3Ded5d0a53a9c72036d6e017094b68111b5eb7f00d;hp=3Dc0819a=
fdcefcb19da351741d51dad00aaf909254;hb=3Dda8ae2b038a448c8f822b3a4f20ed378db=
6d2934;hpb=3D6db55fc472eea2ec6db03833df027aecf6649f88>

> * for some unknown reason the driver does not load automatically from =
DT compatibility string and needs to be explicitly modprobed

This turned out to be because the i2c device ids are upper case while =
compatible-strings
are lower-case. See comment for patch 6/6.

BR and looking forward to v2,
Nikolaus=
