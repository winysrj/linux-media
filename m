Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35757 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbbIALzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 07:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=nM7MBK2EcD1-YK5y0J1hBtxV+6Wu812C23pNkAzigu7g@mail.gmail.com>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
 <1440784362-31217-5-git-send-email-peter.griffin@linaro.org> <CABxcv=nM7MBK2EcD1-YK5y0J1hBtxV+6Wu812C23pNkAzigu7g@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 1 Sep 2015 06:54:41 -0500
Message-ID: <CAL_JsqLccRKCnASOK-tAUn=ifZpQ3hCEJ1eg1hmrei=3vEpzFA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
To: Javier Martinez Canillas <javier@dowhile0.org>
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
	hugues.fruchet@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 1, 2015 at 3:32 AM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Peter,
>
> On Fri, Aug 28, 2015 at 7:52 PM, Peter Griffin <peter.griffin@linaro.org> wrote:
>> gpio.txt documents that GPIO properties should be named
>> "[<name>-]gpios", with <name> being the purpose of this
>> GPIO for the device.
>>
>> This change has been done as one atomic commit.
>>
>> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
>>  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
>>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>> index d4def76..e70d840 100644
>> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
>> @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
>>
>>  - tsin-num     : tsin id of the InputBlock (must be between 0 to 6)
>>  - i2c-bus      : phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
>> -- rst-gpio     : reset gpio for this tsin channel.
>> +- reset-gpios  : reset gpio for this tsin channel.
>
> The documentation is a bit outdated, the GPIO subsystem supports both
> -gpio and -gpios, see commit:
>
> dd34c37aa3e8 ("gpio: of: Allow -gpio suffix for property names")

Yes, because we have lots of them.

> So it makes sense to me to use -gpio instead of -gpios in this case
> since is a single GPIO. Also rst is already a descriptive name since
> that's how many datasheets name a reset pin. I'm not saying I'm
> against this patch, just pointing out since the commit message is a
> bit misleading.

I believe that this has been discussed at length and it was decided
that new bindings should use "-gpios" even for 1. Just like "clocks"
is always plural.

Rob
