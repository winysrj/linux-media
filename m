Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34027 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbbIAMab (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 08:30:31 -0400
Received: by qkct7 with SMTP id t7so35865631qkc.1
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2015 05:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLccRKCnASOK-tAUn=ifZpQ3hCEJ1eg1hmrei=3vEpzFA@mail.gmail.com>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
	<1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
	<CABxcv=nM7MBK2EcD1-YK5y0J1hBtxV+6Wu812C23pNkAzigu7g@mail.gmail.com>
	<CAL_JsqLccRKCnASOK-tAUn=ifZpQ3hCEJ1eg1hmrei=3vEpzFA@mail.gmail.com>
Date: Tue, 1 Sep 2015 14:30:30 +0200
Message-ID: <CABxcv==BDJw60Nb2pPSJkM0Ea7PKuMkDeKT1Awu+=WBTXrcAgw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Valentin Rothberg <valentinrothberg@gmail.com>,
	hugues.fruchet@st.com, Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[adding GPIO maintainers to cc list]

Hello Rob,

On Tue, Sep 1, 2015 at 1:54 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Sep 1, 2015 at 3:32 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>> Hello Peter,
>>
>> On Fri, Aug 28, 2015 at 7:52 PM, Peter Griffin <peter.griffin@linaro.org> wrote:
>>> gpio.txt documents that GPIO properties should be named
>>> "[<name>-]gpios", with <name> being the purpose of this
>>> GPIO for the device.
>>>
>>> This change has been done as one atomic commit.
>>>
>>> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
>>> Acked-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
>>>  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
>>>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
>>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>>> index d4def76..e70d840 100644
>>> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>>> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>>> @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
>>>
>>>  - tsin-num     : tsin id of the InputBlock (must be between 0 to 6)
>>>  - i2c-bus      : phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
>>> -- rst-gpio     : reset gpio for this tsin channel.
>>> +- reset-gpios  : reset gpio for this tsin channel.
>>
>> The documentation is a bit outdated, the GPIO subsystem supports both
>> -gpio and -gpios, see commit:
>>
>> dd34c37aa3e8 ("gpio: of: Allow -gpio suffix for property names")
>
> Yes, because we have lots of them.
>

Yes, I know that was the motivation for that change.

>> So it makes sense to me to use -gpio instead of -gpios in this case
>> since is a single GPIO. Also rst is already a descriptive name since
>> that's how many datasheets name a reset pin. I'm not saying I'm
>> against this patch, just pointing out since the commit message is a
>> bit misleading.
>
> I believe that this has been discussed at length and it was decided
> that new bindings should use "-gpios" even for 1. Just like "clocks"
> is always plural.
>

The documentation doesn't reflect that decision though. If new
bindings are supposed to be using -gpios rather than -gpio even when a
single GPIO is used, then
Documentation/devicetree/bindings/gpio/gpio.txt and
Documentation/gpio/board.txt should say that <function>-gpio is also
supported for backward compatibility but that is deprecated and should
not be used.

Otherwise when looking the code it seems that is just that the
documentation is outdated and that both -gpio or -gpios can be used.

> Rob

Best regards,
Javier
