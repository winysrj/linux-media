Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:44165 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1KHNkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 08:40:53 -0500
Message-ID: <4EB93163.40703@mlbassoc.com>
Date: Tue, 08 Nov 2011 06:40:51 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Using MT9P031 digital sensor
References: <4EB04001.9050803@mlbassoc.com> <CAAwP0s0joZbNLDzR-WkwFBgOpyZ+=hvbMROQs+LTTyNCpfccTw@mail.gmail.com> <4EB92609.1060703@mlbassoc.com> <201111081406.55967.laurent.pinchart@ideasonboard.com> <4EB930EF.90507@mlbassoc.com>
In-Reply-To: <4EB930EF.90507@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-11-08 06:38, Gary Thomas wrote:
> On 2011-11-08 06:06, Laurent Pinchart wrote:
>> Hi Gary,
>>
>> On Tuesday 08 November 2011 13:52:25 Gary Thomas wrote:
>>> On 2011-11-08 05:30, Javier Martinez Canillas wrote:
>>>> On Tue, Nov 8, 2011 at 1:20 PM, Gary Thomas wrote:
>>>>> On 2011-11-04 04:37, Laurent Pinchart wrote:
>>>>>> On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
>>>>>>> I'm trying to use the MT9P031 digital sensor with the Media Controller
>>>>>>> Framework. media-ctl tells me that the sensor is set to capture using
>>>>>>> SGRBG12 2592x1944
>>>>>>>
>>>>>>> Questions:
>>>>>>> * What pixel format in ffmpeg does this correspond to?
>>>>>>
>>>>>> I don't know if ffmpeg supports Bayer formats. The corresponding fourcc
>>>>>> in V4L2 is BA12.
>>>>>
>>>>> ffmpeg doesn't seem to support these formats
>>>>>
>>>>>> If your sensor is hooked up to the OMAP3 ISP, you can then configure
>>>>>> the pipeline to include the preview engine and the resizer, and
>>>>>> capture YUV data
>>>>>> at the resizer output.
>>>>>
>>>>> I am using the OMAP3 ISP, but it's a bit unclear to me how to set up the
>>>>> pipeline
>>>>
>>>> Hi Gary,
>>>>
>>>> I'm also using another sensor mtv9034 with OMAP3 ISP, so maybe I can help
>>>> you.
>>>>
>>>>> using media-ctl (I looked for documentation on this tool, but came up
>>>>> dry - is there any?)
>>>>>
>>>>> Do you have an example of how to configure this using the OMAP3 ISP?
>>>>
>>>> This is how I configure the pipeline to connect the CCDC with the
>>>> Previewer and Resizer:
>>>>
>>>> ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
>>>> ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>> ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>>> ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
>>>> ./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480]'
>>>> ./media-ctl -f '"OMAP3 ISP CCDC":0 [SGRBG10 752x480]'
>>>> ./media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG10 752x480]'
>>>> ./media-ctl -f '"OMAP3 ISP preview":0 [SGRBG10 752x479]'
>>>> ./media-ctl -f '"OMAP3 ISP resizer":0 [YUYV 734x471]'
>>>> ./media-ctl -f '"OMAP3 ISP resizer":1 [YUYV 640x480]'
>>>>
>>>> Hope it helps,
>>>
>>> Thanks, I'll give this a try.
>>>
>>> I assume that your sensor is probably larger than 752x480 (the mt9p031
>>> is 2592x1944 raw) and that setting the smaller frame size enables some
>>> scaling and/or cropping in the driver?
>>
>> The mt9v034 is a wide VGA 752x480 sensor if I'm not mistaken. You should
>> modify the resolutions in the above commands according to your sensor. Note
>> that the CCDC crops online line when outputting data to the preview engine,
>> and that the preview engine crops 18 columsn and 8 lines. You can then scale
>> the image by modifying the resizer output size.
>
> Thanks. After much trial and error (and some kernel printks to
> understand what parameters were failing), I came up with this sequence:
> media-ctl -r
> media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
> media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
> media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
> media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
> media-ctl -f '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
> media-ctl -f '"OMAP3 ISP CCDC":1 [SGRBG12 2592x1944]'
> media-ctl -f '"OMAP3 ISP preview":0 [SGRBG12 2592x1943]'
> media-ctl -f '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
> media-ctl -f '"OMAP3 ISP resizer":1 [YUYV 642x483]'
>
> When I tried to grab though, I got this:
>
> # yavta --capture=4 -f YUYV -s 642x483 -F /dev/video6
> Device /dev/video6 opened.
> Device `OMAP3 ISP resizer output' on `media' is a video capture device.
> Video format set: YUYV (56595559) 642x483 buffer size 633696
> Video format: YUYV (56595559) 642x483 buffer size 633696
> 8 buffers requested.
> length: 633696 offset: 0
> Buffer 0 mapped at address 0x4028c000.
> length: 633696 offset: 634880
> Buffer 1 mapped at address 0x403d0000.
> length: 633696 offset: 1269760
> Buffer 2 mapped at address 0x404b3000.
> length: 633696 offset: 1904640
> Buffer 3 mapped at address 0x4062b000.
> length: 633696 offset: 2539520
> Buffer 4 mapped at address 0x406d6000.
> length: 633696 offset: 3174400
> Buffer 5 mapped at address 0x40821000.
> length: 633696 offset: 3809280
> Buffer 6 mapped at address 0x4097c000.
> length: 633696 offset: 4444160
> Buffer 7 mapped at address 0x40adf000.
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000018
> pgd = c0004000
> [00000018] *pgd=00000000
> Internal error: Oops: 17 [#1]
> Modules linked in: sdmak lpm_omap3530 dsplinkk cmemk ipv6
> CPU: 0 Not tainted (3.0.0 #3)
> PC is at ccdc_hs_vs_isr+0x28/0x40
> LR is at 0x0
> pc : [<c0251ae0>] lr : [<00000000>] psr: 60000193
> sp : c0433e70 ip : 00000000 fp : 00000001
> r10: 00000001 r9 : c0470524 r8 : 00000001
> r7 : 00000080 r6 : 00000000 r5 : 00000000 r4 : cee45b88
> r3 : 00000004 r2 : 00000000 r1 : 00000000 r0 : cee45c28
> Flags: nZCv IRQs off FIQs on Mode SVC_32 ISA ARM Segment kernel
> Control: 10c5387d Table: 8e4d8019 DAC: 00000015
> Process swapper (pid: 0, stack limit = 0xc04322f0)
> Stack: (0xc0433e70 to 0xc0434000)
> 3e60: 00000004 00000000 00000000 00000000
> 3e80: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 3ea0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 3ec0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 3ee0: 00000000 00000000 00000000 00000000 80000000 cee45b88 80000000 c0252d88
> 3f00: cee40000 80000000 00000000 00000080 00000001 c024a424 cee2ff80 00000018
> 3f20: c04476e8 c0089bd8 c04476e8 ced051c0 00004c00 c04476e8 00000000 c0468d44
> 3f40: c0437154 80004059 413fc082 00000000 00000000 c0089d40 c04476e8 c008b7f4
> 3f60: 00000018 c00896c4 0000019a c0033060 60000013 ffffffff fa200000 c003caf4
> 3f80: 00000001 c0446be0 0039acad 60000013 c0432000 c043715c c0468d44 c0437154
> 3fa0: 80004059 413fc082 00000000 00000000 00000000 c0433fc8 c003dfec c003dff0
> 3fc0: 60000013 ffffffff c043415c c0029e24 c0682980 c0008a04 c0008488 00000a7d
> 3fe0: 80000100 c0029e24 10c53c7d c0434080 c0029e20 8000803c 00000000 00000000
> [<c0251ae0>] (ccdc_hs_vs_isr+0x28/0x40) from [<c0252d88>] (omap3isp_ccdc_isr+0x2c4/0x2d8)
> [<c0252d88>] (omap3isp_ccdc_isr+0x2c4/0x2d8) from [<c024a424>] (isp_isr+0x19c/0x230)
> [<c024a424>] (isp_isr+0x19c/0x230) from [<c0089bd8>] (handle_irq_event_percpu+0x30/0x170)
> [<c0089bd8>] (handle_irq_event_percpu+0x30/0x170) from [<c0089d40>] (handle_irq_event+0x28/0x38)
> [<c0089d40>] (handle_irq_event+0x28/0x38) from [<c008b7f4>] (handle_level_irq+0xac/0xd4)
> [<c008b7f4>] (handle_level_irq+0xac/0xd4) from [<c00896c4>] (generic_handle_irq+0x30/0x44)
> [<c00896c4>] (generic_handle_irq+0x30/0x44) from [<c0033060>] (asm_do_IRQ+0x60/0x84)
> [<c0033060>] (asm_do_IRQ+0x60/0x84) from [<c003caf4>] (__irq_svc+0x34/0x80)
> Exception stack(0xc0433f80 to 0xc0433fc8)
> 3f80: 00000001 c0446be0 0039acad 60000013 c0432000 c043715c c0468d44 c0437154
> 3fa0: 80004059 413fc082 00000000 00000000 00000000 c0433fc8 c003dfec c003dff0
> 3fc0: 60000013 ffffffff
> [<c003caf4>] (__irq_svc+0x34/0x80) from [<c003dff0>] (cpu_idle+0x4c/0x88)
> [<c003dff0>] (cpu_idle+0x4c/0x88) from [<c0008a04>] (start_kernel+0x26c/0x2c0)
> [<c0008a04>] (start_kernel+0x26c/0x2c0) from [<8000803c>] (0x8000803c)
> Code: ebfce5a2 e3a03004 e58d3000 e28400a0 (e5953018)
> ---[ end trace bd263f5099189d04 ]---
>
> Any ideas of where to look?
>

Note: I was able to grab the raw SGRBG12 data using yavta, I only
get the failure when I run it through the CCDC->previewer->resizer

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
