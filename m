Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpcmd02102.aruba.it ([62.149.158.102]:43855 "EHLO
	smtpcmd02102.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbaLLJPN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 04:15:13 -0500
Message-ID: <548AB21B.8050402@phoenixsoftware.it>
Date: Fri, 12 Dec 2014 10:15:07 +0100
From: Pierluigi Passaro <pierluigi.passaro@phoenixsoftware.it>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: VPU on iMX51 babbage board
References: <5488C10F.1040508@phoenixsoftware.it>	 <CAOMZO5Deesoe61g_MzUKiUpXfjyJjVTBbogSd6bT9WA1GJ9P2Q@mail.gmail.com> <1418306587.3188.13.camel@pengutronix.de>
In-Reply-To: <1418306587.3188.13.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2014 15:03, Philipp Zabel wrote:
> Am Mittwoch, den 10.12.2014, 22:04 -0200 schrieb Fabio Estevam:
>> On Wed, Dec 10, 2014 at 7:54 PM, Pierluigi Passaro
>> <pierluigi.passaro@phoenixsoftware.it> wrote:
>>> Hi all,
>>> I'm trying to use VPU code driver on iMX51 with kernel 3.18, following these
>>> steps:
>>> - disabled DVI interface
>>> - enabled LCD interface
>>> - configured and enabled VPU
>>> - copied iMX51 vpu firmware without header and renamed
>>> v4l-coda7541-imx53.bin in /lib/firmware
>>>
>>> Attached you can find the patch and the defconfig I used.
>>>
>>> The boot process hangs after loading the firmware at the first attempt of
>>> writing in VPU address space in the function coda_write of file
>>> driver/media/platform/coda/coda-common.c
>>>
>>> Is there anything preventing the coda driver to work with iMX51?
>>> Could anyone provide any suggestion on how investigate the problem?
>> I have only tested the coda driver on mx6, but looking at the
>> mx51.dtsi you would need this:
>>
>> --- a/arch/arm/boot/dts/imx51.dtsi
>> +++ b/arch/arm/boot/dts/imx51.dtsi
>> @@ -121,6 +121,7 @@
>>           iram: iram@1ffe0000 {
>>               compatible = "mmio-sram";
>>               reg = <0x1ffe0000 0x20000>;
>> +            clocks = <&clks IMX5_CLK_OCRAM>;
>>           };
>>
>>           ipu: ipu@40000000 {
>> @@ -584,6 +585,18 @@
>>                   clock-names = "ipg", "ahb", "ptp";
>>                   status = "disabled";
>>               };
>> +
>> +            vpu: vpu@83ff4000 {
>> +                compatible = "fsl,imx53-vpu";
> This should be "fsl,imx51-vpu", and add a "cnm,codahx14".
>
> According to the old imx-vpu-lib code and the vpu_fw_imx51.bin firmware
> file, the i.MX51 has a CodaHx14 (0xF00A) as opposed to the i.MX53's
> Coda7541 (0xF012).
>
Thanks for the hint, I'm now going through the old imx-vpu-lib to 
understand the CodaHX14 behaviour.
In old imx-vpu-lib, file vpu_util.c, there is a comment that make me 
doubtful: "i.MX51 has no secondary AXI memory, but use on chip RAM".
As far as I understood, the portion of coda driver affected from this 
comment should be around the function coda_setup_iram in coda-bit.c.
How am I supposed to manage this information?
Have I to avoid to use iram for iMX51 (and return on !dev->iram.vaddr) 
or go through the function without managing any CodaHX14 specific behaviour?
>> +                reg = <0x83ff4000 0x1000>;
>> +                interrupts = <9>;
>> +                clocks = <&clks IMX5_CLK_VPU_REFERENCE_GATE>,
>> +                         <&clks IMX5_CLK_VPU_GATE>;
>> +                clock-names = "per", "ahb";
>> +                resets = <&src 1>;
>> +                iram = <&iram>;
>> +            };
>>           };
>> +
>>       };
>>   };
>>
>> Also, not  sure if all the required coda patches are available in
>> 3.18, so I tried it on linux-next 20141210 on a imx51-babbage (I had
>> to disable USB, otherwise linux-next will hang on this board):
>>
>> [    1.368454] coda 83ff4000.vpu: Initialized CODA7541.
>> [    1.373572] coda 83ff4000.vpu: Firmware version: 1.4.50
>> [    1.396695] coda 83ff4000.vpu: codec registered as /dev/video[0-3]
>>
>> Also, no sure if we need to distinguish mx51 versus mx53 in the coda driver.
>>
>> Adding Philipp in case he can comment.
> Yes, the i.MX51 and i.MX53 firmware files are different. So at least an
> entry for i.MX51 with the correct firmware file name has to be added.
>
> regards
> Philipp
Thanks
Regards
Pierluigi
