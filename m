Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdFZUE7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 16:04:59 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
 <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
 <64e3005d-31df-71f2-762b-2c1b1152fc2d@st.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <5cd25a47-f3be-8c40-3940-29f26a245076@kernel.org>
Date: Mon, 26 Jun 2017 22:04:53 +0200
MIME-Version: 1.0
In-Reply-To: <64e3005d-31df-71f2-762b-2c1b1152fc2d@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/26/2017 12:35 PM, Hugues FRUCHET wrote:
>> What I am missing to support the GTA04 camera is the control of the optional "vana-supply".
>> So the driver does not power up the camera module when needed and therefore probing fails.
>>
>>     - vana-supply: a regulator to power up the camera module.
>>
>> Driver code is not complex to add:

> Yes, I saw it in your code, but as I don't have any programmable power
> supply on my setup, I have not pushed this commit.

Since you are about to add voltage supplies to the DT binding I'd suggest
to include all three voltage supplies of the sensor chip. Looking at the OV9650
and the OV9655 datasheet there are following names used for the voltage supply
pins:

AVDD - Analog power supply,
DVDD - Power supply for digital core logic,
DOVDD - Digital power supply for I/O.

I doubt the sensor can work without any of these voltage supplies, thus
regulator_get_optional() should not be used. I would just use the regulator
bulk API to handle all three power supplies.

--
Regards,
Sylwester
