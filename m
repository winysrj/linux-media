Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754354AbdFWKqN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 06:46:13 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
 <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <d14b8c6e-b480-36f0-ed0a-684647617dbe@suse.de>
Date: Fri, 23 Jun 2017 12:46:09 +0200
MIME-Version: 1.0
In-Reply-To: <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am 23.06.2017 um 12:25 schrieb H. Nikolaus Schaller:
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>> new file mode 100644
>> index 0000000..0e0de1f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>> @@ -0,0 +1,37 @@
>> +* Omnivision OV9650/9652/9655 CMOS sensor
>> +
>> +The Omnivision OV965x sensor support multiple resolutions output, such as
>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>> +output format.
>> +
>> +Required Properties:
>> +- compatible: should be one of
>> +	"ovti,ov9650"
>> +	"ovti,ov9652"
>> +	"ovti,ov9655"
>> +- clocks: reference to the mclk input clock.
> 
> I wonder why you have removed the clock-frequency property?
> 
> In some situations the camera driver must be able to tell the clock source
> which frequency it wants to see.

That's what assigned-clock-rates property is for:

https://www.kernel.org/doc/Documentation/devicetree/bindings/clock/clock-bindings.txt

AFAIU clock-frequency on devices is deprecated and equivalent to having
a clocks property pointing to a fixed-clock, which is different from a
clock with varying rate.

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
