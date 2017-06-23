Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:11073 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753397AbdFWOy1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 10:54:27 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <13144955.Kq5qljPvgI@avalon>
Date: Fri, 23 Jun 2017 16:53:43 +0200
Cc: Suman Anna <s-anna@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>,
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
        linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <24C976BF-52FD-4509-BCE4-9AE41B335482@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <d14b8c6e-b480-36f0-ed0a-684647617dbe@suse.de> <3E7B1344-ECE6-4CCC-9E9D-7521BB566CDE@goldelico.com> <13144955.Kq5qljPvgI@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?iso-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Hugues Fruchet <hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> Am 23.06.2017 um 13:58 schrieb Laurent Pinchart =
<laurent.pinchart@ideasonboard.com>:
>=20
> Hi Nikolaus,
>=20
> On Friday 23 Jun 2017 12:59:24 H. Nikolaus Schaller wrote:
>> Am 23.06.2017 um 12:46 schrieb Andreas F=E4rber <afaerber@suse.de>:
>>> Am 23.06.2017 um 12:25 schrieb H. Nikolaus Schaller:
>>>>> diff --git =
a/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>> b/Documentation/devicetree/bindings/media/i2c/ov965x.txt new file =
mode
>>>>> 100644
>>>>> index 0000000..0e0de1f
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>> @@ -0,0 +1,37 @@
>>>>> +* Omnivision OV9650/9652/9655 CMOS sensor
>>>>> +
>>>>> +The Omnivision OV965x sensor support multiple resolutions output, =
such
>>>>> as
>>>>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or =
raw RGB
>>>>> +output format.
>>>>> +
>>>>> +Required Properties:
>>>>> +- compatible: should be one of
>>>>> +	"ovti,ov9650"
>>>>> +	"ovti,ov9652"
>>>>> +	"ovti,ov9655"
>>>>> +- clocks: reference to the mclk input clock.
>>>>=20
>>>> I wonder why you have removed the clock-frequency property?
>>>>=20
>>>> In some situations the camera driver must be able to tell the clock
>>>> source which frequency it wants to see.
>>>=20
>>> That's what assigned-clock-rates property is for:
>>>=20
>>> =
https://www.kernel.org/doc/Documentation/devicetree/bindings/clock/clock-b=

>>> indings.txt
>>>=20
>>> AFAIU clock-frequency on devices is deprecated and equivalent to =
having
>>> a clocks property pointing to a fixed-clock, which is different from =
a
>>> clock with varying rate.
>>=20
>> I am not sure if that helps here. The OMAP3-ISP does not have a fixed =
clock
>> rate so we can only have the driver define what it wants to see.
>>=20
>> And common practise for OMAP3-ISP based camera modules (e.g. N900, =
N9) is
>> that they do it in the driver.
>>=20
>> Maybe ISP developers can comment?
>=20
> The OMAP3 ISP is a variable-frequency clock provider. The clock =
frequency is=20
> controlled by the clock consumer. As such, it's up to the consumer to =
decide=20
> whether to compute and request the clock rate dynamically at runtime, =
or use=20
> the assigned-clock-rates property in DT.
>=20
> Some ISPs include a clock generator, others don't. It should make no=20=

> difference whether the clock is provided by the ISP, by a dedicated =
clock=20
> source in the SoC or by a discrete on-board adjustable clock source.

Thanks for explaining the background.

Do you have an hint or example how to use the assigned-clock-rates =
property in
a DT for a camera module connected to the omap3isp?

Or does it just mean that it defines the property name?

BR,
Nikolaus
