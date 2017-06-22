Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:13047 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752669AbdFVPmA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:42:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v1 0/6] Add support of OV9655 camera
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
Date: Thu, 22 Jun 2017 17:41:11 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 22.06.2017 um 17:05 schrieb Hugues Fruchet <hugues.fruchet@st.com>:
>=20
> This patchset enables OV9655 camera support.
>=20
> OV9655 support has been tested using STM32F4DIS-CAM extension board
> plugged on connector P1 of STM32F746G-DISCO board.
> Due to lack of OV9650/52 hardware support, the modified related code
> could not have been checked for non-regression.
>=20
> First patches upgrade current support of OV9650/52 to prepare then
> introduction of OV9655 variant patch.
> Because of OV9655 register set slightly different from OV9650/9652,
> not all of the driver features are supported (controls). Supported
> resolutions are limited to VGA, QVGA, QQVGA.
> Supported format is limited to RGB565.
> Controls are limited to color bar test pattern for test purpose.
>=20
> OV9655 initial support is based on a driver written by H. Nikolaus =
Schaller [1].

Great!

I will test as soon as possible.

> OV9655 registers sequences come from STM32CubeF7 embedded software =
[2].

There is also a preliminary data sheet, e.g. here:

http://electricstuff.co.uk/OV9655-datasheet-annotated.pdf

>=20
> [1] =
http://git.goldelico.com/?p=3Dgta04-kernel.git;a=3Dshortlog;h=3Drefs/heads=
/work/hns/video/ov9655
> [2] =
https://developer.mbed.org/teams/ST/code/BSP_DISCO_F746NG/file/e1d9da7fe85=
6/Drivers/BSP/Components/ov9655/ov9655.c
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D history =3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> version 1:
>  - Initial submission.
>=20
> H. Nikolaus Schaller (1):
>  DT bindings: add bindings for ov965x camera module
>=20
> Hugues Fruchet (5):
>  [media] ov9650: add device tree support
>  [media] ov9650: select the nearest higher resolution
>  [media] ov9650: use write_array() for resolution sequences
>  [media] ov9650: add multiple variant support
>  [media] ov9650: add support of OV9655 variant
>=20
> .../devicetree/bindings/media/i2c/ov965x.txt       |  37 +
> drivers/media/i2c/Kconfig                          |   6 +-
> drivers/media/i2c/ov9650.c                         | 792 =
+++++++++++++++++----
> 3 files changed, 704 insertions(+), 131 deletions(-)
> create mode 100644 =
Documentation/devicetree/bindings/media/i2c/ov965x.txt
>=20
> --=20
> 1.9.1
>=20

BR and thanks,
Nikolaus Schaller
