Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([63.128.21.107]:50792 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdIUNcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 09:32:07 -0400
Subject: Re: [PATCH v2] media: rc: Add driver for tango IR decoder
To: Sean Young <sean@mess.org>, Mans Rullgard <mans@mansr.com>
CC: Rob Herring <robh+dt@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
References: <38397d63-f0db-6d8e-60cf-e8535447de63@free.fr>
 <20170921112540.vgsaj7lfz7q66alb@gofer.mess.org>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <408143ff-9ea4-6cd4-8f17-4e67e359a97c@sigmadesigns.com>
Date: Thu, 21 Sep 2017 15:32:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170921112540.vgsaj7lfz7q66alb@gofer.mess.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/09/2017 13:25, Sean Young wrote:

> On Wed, Sep 20, 2017 at 10:39:11AM +0200, Marc Gonzalez wrote:
> 
>> From: Mans Rullgard <mans@mansr.com>
>>
>> The tango IR decoder supports NEC, RC-5, RC-6 protocols.
>>
>> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> 
> This needs a signed-off-by from all the authors.

Mans, the ball is in your court :-)

In the mean time, I might work on the universal IR receiver,
or the IR blaster.

>>  .../devicetree/bindings/media/tango-ir.txt         |  21 ++
>>  drivers/media/rc/Kconfig                           |   5 +
>>  drivers/media/rc/Makefile                          |   1 +
>>  drivers/media/rc/tango-ir.c                        | 265 +++++++++++++++++++++
>>  4 files changed, 292 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt
>>  create mode 100644 drivers/media/rc/tango-ir.c
> 
> You should add an entry to the MAINTAINERS file.

It's already taken care of, with a file regex pattern for
ARM/TANGO ARCHITECTURE (N: tango)

>> diff --git a/Documentation/devicetree/bindings/media/tango-ir.txt b/Documentation/devicetree/bindings/media/tango-ir.txt
>> new file mode 100644
>> index 000000000000..a9f00c2bf897
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/tango-ir.txt
>> @@ -0,0 +1,21 @@
>> +Sigma Designs Tango IR NEC/RC-5/RC-6 decoder (SMP86xx and SMP87xx)
>> +
>> +Required properties:
>> +
>> +- compatible: "sigma,smp8642-ir"
>> +- reg: address/size of NEC+RC5 area, address/size of RC6 area
>> +- interrupts: spec for IR IRQ
>> +- clocks: spec for IR clock (typically the crystal oscillator)
>> +
>> +Optional properties:
>> +
>> +- linux,rc-map-name: see Documentation/devicetree/bindings/media/rc.txt
>> +
>> +Example:
>> +
>> +	ir@10518 {
>> +		compatible = "sigma,smp8642-ir";
>> +		reg = <0x10518 0x18>, <0x105e0 0x1c>;
>> +		interrupts = <21 IRQ_TYPE_EDGE_RISING>;
>> +		clocks = <&xtal>;
>> +	};
> 
> This needs to be a separate commit/patch.

OK, I will send a v3 series. Could you explain the rationale behind
having separate patches? (I don't think Rob minds having a binding
description pushed through a different tree.)

>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> index d9ce8ff55d0c..f84923289964 100644
>> --- a/drivers/media/rc/Kconfig
>> +++ b/drivers/media/rc/Kconfig
>> @@ -469,6 +469,11 @@ config IR_SIR
>>  	   To compile this driver as a module, choose M here: the module will
>>  	   be called sir-ir.
>>  
>> +config IR_TANGO
>> +	tristate "Sigma Designs SMP86xx IR decoder"
>> +	depends on RC_CORE
>> +	depends on ARCH_TANGO || COMPILE_TEST
> 
> This needs --help-- a section, even if it is mostly boilerplate.
> 
> This will be catched by ./scripts/checkpatch.pl, please run this script
> on your patches.

OK.

Regards.
