Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57456 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3INFYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Sep 2013 01:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <523395DC.5080009@wwwdotorg.org>
References: <1379073471-7244-1-git-send-email-prabhakar.csengg@gmail.com> <523395DC.5080009@wwwdotorg.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 14 Sep 2013 10:53:53 +0530
Message-ID: <CA+V-a8sVyJ1TrTSiaj8vpaD+f_qJ5Hp287E3HuHJ_pRzzmdAvg@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: adv7343: fix the DT binding properties
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>, LDOC <linux-doc@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephen,

This patch should have been marked as RFC.

Thanks for the review.

On Sat, Sep 14, 2013 at 4:16 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/13/2013 05:57 AM, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch fixes the DT binding properties of adv7343 decoder.
>> The pdata which was being read from the DT property, is removed
>> as this can done internally in the driver using cable detection
>> register.
>>
>> This patch also removes the pdata of ADV7343 which was passed from
>> DA850 machine.
>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>
>>  Required Properties :
>>  - compatible: Must be "adi,adv7343"
>> +- reg: I2C device address.
>> +- vddio-supply: I/O voltage supply.
>> +- vddcore-supply: core voltage supply.
>> +- vaa-supply: Analog power supply.
>> +- pvdd-supply: PLL power supply.
>
> Old DTs won't contain those properties. This breaks the DT ABI if those
> properties are required. Is that acceptable?
>
As of now adv7343 via DT binding is not enabled in any platforms
so this wont break any DT ABI.

> If it is, I think we should document that older versions of the binding
> didn't require those properties, so they may in fact be missing.
>
> I note that this patch doesn't actually update the driver to
> regulator_get() anything. Shouldn't it?
>
As of now the driver isn’t enabling/accepting the regulators,
so should I add those in DT properties or not ?

>>  Optional Properties :
>> -- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
>> -                           micro ampere level. All DACs and the internal PLL
>> -                           circuit are disabled.
>> -- adi,power-mode-pll-ctrl: PLL and oversampling control. This control allows
>> -                        internal PLL 1 circuit to be powered down and the
>> -                        oversampling to be switched off.
>> -- ad,adv7343-power-mode-dac: array configuring the power on/off DAC's 1..6,
>> -                           0 = OFF and 1 = ON, Default value when this
>> -                           property is not specified is <0 0 0 0 0 0>.
>> -- ad,adv7343-sd-config-dac-out: array configure SD DAC Output's 1 and 2, 0 = OFF
>> -                              and 1 = ON, Default value when this property is
>> -                              not specified is <0 0>.
>
> At a very quick glance, it's not really clear why those properties are
> being removed. They seem like HW configuration, so might be fine to put
> into DT. What replaces these?

Yes these were HW configuration but, its now internally handled in
the driver.  The 'ad,adv7343-power-mode-dac' property which enabled the
DAC's 1..6 , so now in the driver by default all the DAC's are enabled by
default and enable unconnected DAC auto power down. Similarly
'ad,adv7343-sd-config-dac-out' property enabled SD DAC's 1..2 but
now is enabled by reading the CABLE DETECT register which tells
the status of DAC1/2.

Regards,
--Prabhakar
