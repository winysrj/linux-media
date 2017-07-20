Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:34289 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933179AbdGTIir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 04:38:47 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 0/7] Add support of OV9655 camera
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20170718195223.zrqfrefxxzqfsojd@valkosipuli.retiisi.org.uk>
Date: Thu, 20 Jul 2017 10:37:58 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB91B71D-E34B-4645-BD70-A87226BA34C5@goldelico.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com> <8157da84-1484-8375-1f2b-9831973915b4@kernel.org> <956f17e6-36dd-6733-0d35-9b801ed4244d@xs4all.nl> <BCD1BD18-96E3-4638-8935-B5C832D8EE52@goldelico.com> <2dd3402e-55b0-231d-878f-5ba95ee8cb36@st.com> <20170718195223.zrqfrefxxzqfsojd@valkosipuli.retiisi.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Am 18.07.2017 um 21:52 schrieb Sakari Ailus <sakari.ailus@iki.fi>:
>=20
> On Tue, Jul 18, 2017 at 12:53:12PM +0000, Hugues FRUCHET wrote:
>>=20
>>=20
>> On 07/18/2017 02:17 PM, H. Nikolaus Schaller wrote:
>>> Hi,
>>>=20
>>>> Am 18.07.2017 um 13:59 schrieb Hans Verkuil <hverkuil@xs4all.nl>:
>>>>=20
>>>> On 12/07/17 22:01, Sylwester Nawrocki wrote:
>>>>> Hi Hugues,
>>>>>=20
>>>>> On 07/03/2017 11:16 AM, Hugues Fruchet wrote:
>>>>>> This patchset enables OV9655 camera support.
>>>>>>=20
>>>>>> OV9655 support has been tested using STM32F4DIS-CAM extension =
board
>>>>>> plugged on connector P1 of STM32F746G-DISCO board.
>>>>>> Due to lack of OV9650/52 hardware support, the modified related =
code
>>>>>> could not have been checked for non-regression.
>>>>>>=20
>>>>>> First patches upgrade current support of OV9650/52 to prepare =
then
>>>>>> introduction of OV9655 variant patch.
>>>>>> Because of OV9655 register set slightly different from =
OV9650/9652,
>>>>>> not all of the driver features are supported (controls). =
Supported
>>>>>> resolutions are limited to VGA, QVGA, QQVGA.
>>>>>> Supported format is limited to RGB565.
>>>>>> Controls are limited to color bar test pattern for test purpose.
>>>>>=20
>>>>> I appreciate your efforts towards making a common driver but IMO =
it would be
>>>>> better to create a separate driver for the OV9655 sensor.  The =
original driver
>>>>> is 1576 lines of code, your patch set adds half of that (816).  =
There are
>>>>> significant differences in the feature set of both sensors, there =
are
>>>>> differences in the register layout.  I would go for a separate =
driver, we
>>>>> would then have code easier to follow and wouldn't need to worry =
about possible
>>>>> regressions.  I'm afraid I have lost the camera module and won't =
be able
>>>>> to test the patch set against regressions.
>>>>>=20
>>>>> IMHO from maintenance POV it's better to make a separate driver. =
In the end
>>>>> of the day we wouldn't be adding much more code than it is being =
done now.
>>>>=20
>>>> I agree. We do not have great experiences in the past with trying =
to support
>>>> multiple variants in a single driver (unless the diffs are truly =
small).
>>>=20
>>> Well,
>>> IMHO the diffs in ov965x are smaller (but untestable because nobody =
seems
>>> to have an ov9650/52 board) than within the bq27xxx chips, but I can =
dig out
>>> an old pdata based separate ov9655 driver and extend that to become =
DT compatible.
>>>=20
>>> I had abandoned that separate approach in favour of extending the =
ov965x driver.
>>>=20
>>> Have to discuss with Hugues how to proceed.
>>>=20
>>> BR and thanks,
>>> Nikolaus
>>>=20
>>=20
>> As Sylwester and Hans, I'm also in flavour of a separate driver, the=20=

>> fact that register set seems similar but in fact is not and that we=20=

>> cannot test for non-regression of 9650/52 are killer for me to =
continue=20
>> on a single driver.
>> We can now restart from a new fresh state of the art sensor driver=20
>> getting rid of legacy (pdata, old gpio, etc...).
>=20
> Agreed. I bet the result will look cleaner indeed although this wasn't =
one
> of the complex drivers.

I finally managed to find the bug why mplayer did select-timeout on the =
GTA04.
Was a bug in pinmux setup of the GTA04 for the omap3isp.

And I have resurrected our years old 3.12 camera driver, which was based =
on the
MT9P031 code. It was already separate from ov9650/52.

I have extended it to support DT by including some parts of Hugues' =
work.

It still needs some cleanup and discussion but will be a simple patch =
(one
for ov9655.c + Kconfig + Makefile) and one for bindings (I hope it =
includes
all your comments).

I will post v1 in the next days.

BR,
Nikolaus
