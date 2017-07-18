Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:20976 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRMSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 08:18:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 0/7] [PATCH v2 0/7] Add support of OV9655 camera
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <956f17e6-36dd-6733-0d35-9b801ed4244d@xs4all.nl>
Date: Tue, 18 Jul 2017 14:17:36 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCD1BD18-96E3-4638-8935-B5C832D8EE52@goldelico.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com> <8157da84-1484-8375-1f2b-9831973915b4@kernel.org> <956f17e6-36dd-6733-0d35-9b801ed4244d@xs4all.nl>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Am 18.07.2017 um 13:59 schrieb Hans Verkuil <hverkuil@xs4all.nl>:
>=20
> On 12/07/17 22:01, Sylwester Nawrocki wrote:
>> Hi Hugues,
>>=20
>> On 07/03/2017 11:16 AM, Hugues Fruchet wrote:
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
>>=20
>> I appreciate your efforts towards making a common driver but IMO it =
would be=20
>> better to create a separate driver for the OV9655 sensor.  The =
original driver=20
>> is 1576 lines of code, your patch set adds half of that (816).  There =
are
>> significant differences in the feature set of both sensors, there are=20=

>> differences in the register layout.  I would go for a separate =
driver, we =20
>> would then have code easier to follow and wouldn't need to worry =
about possible
>> regressions.  I'm afraid I have lost the camera module and won't be =
able=20
>> to test the patch set against regressions.
>>=20
>> IMHO from maintenance POV it's better to make a separate driver. In =
the end=20
>> of the day we wouldn't be adding much more code than it is being done =
now.
>=20
> I agree. We do not have great experiences in the past with trying to =
support
> multiple variants in a single driver (unless the diffs are truly =
small).

Well,
IMHO the diffs in ov965x are smaller (but untestable because nobody =
seems
to have an ov9650/52 board) than within the bq27xxx chips, but I can dig =
out
an old pdata based separate ov9655 driver and extend that to become DT =
compatible.

I had abandoned that separate approach in favour of extending the ov965x =
driver.

Have to discuss with Hugues how to proceed.

BR and thanks,
Nikolaus
