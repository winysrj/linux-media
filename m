Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:42027 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1K3ONY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 09:13:24 -0500
Message-ID: <4ED639FE.7020503@mlbassoc.com>
Date: Wed, 30 Nov 2011 07:13:18 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Using MT9P031 digital sensor
References: <4EB04001.9050803@mlbassoc.com> <201111281207.46625.laurent.pinchart@ideasonboard.com> <4ED381C7.8000007@mlbassoc.com> <201111281349.47411.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111281349.47411.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-11-28 05:49, Laurent Pinchart wrote:
> Hi Gary,
>
> On Monday 28 November 2011 13:42:47 Gary Thomas wrote:
>> On 2011-11-28 04:07, Laurent Pinchart wrote:
>>> On Friday 25 November 2011 12:50:25 Gary Thomas wrote:
>>>> On 2011-11-24 04:28, Laurent Pinchart wrote:
>>>>> On Wednesday 16 November 2011 13:03:11 Gary Thomas wrote:
>>>>>> On 2011-11-15 18:26, Laurent Pinchart wrote:
>>>>>>> On Monday 14 November 2011 12:42:54 Gary Thomas wrote:
>
> [snip]
>
>>>>>>>> Here's my pipeline:
>>>>>>>>        media-ctl -r
>>>>>>>>        media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>>>        media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>>>>>        media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>>>>>>>        media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer
>>>>>>>>        output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12
>>>>>>>>        2592x1944]' media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG10
>>>>>>>>        2592x1944]'
>>>>>>>>        media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
>>>>>>>>        media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
>>>>>>>>        media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
>>>>>>>>        media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 642x483]'
>>>>>>>>
>>>>>>>> The full media-ctl dump is at
>>>>>>>> http://www.mlbassoc.com/misc/pipeline.out
>>>>>>>>
>>>>>>>> When I try to grab from /dev/video6 (output node of resizer), I see
>>>>>>>> only previewer interrupts, no resizer interrrupts.  I added a simple
>>>>>>>> printk at each of the previewer/resizer *_isr functions, and I only
>>>>>>>>
>>>>>>>> ever see this one:
>>>>>>>>        omap3isp_preview_isr_frame_sync.1373
>>>>>>>>
>>>>>>>> Can you give me an overview of what events/interrupts should occur
>>>>>>>> so I can try to trace through the ISP to see where it is failing?
>>>>>>>
>>>>>>> The CCDC generates VD0, VD1 and HS/VS interrupts regardless of
>>>>>>> whether it processes video or not, as long as it receives a video
>>>>>>> stream at its input. The preview engine and resizer will only
>>>>>>> generate an interrupt after writing an image to memory. With your
>>>>>>> above
>>>>>>> configuration VD0, VD1, HS/VS and resizer interrupts should be
>>>>>>> generated.
>>>>>>>
>>>>>>> Your pipeline configuration looks correct, except that the
>>>>>>> downscaling factor is slightly larger than 4. Could you try to setup
>>>>>>> the resizer to output a 2574x1935 image instead of 642x483 ? If that
>>>>>>> works, try to downscale to 660x496. If that works as well, the
>>>>>>> driver should be fixed to disallow resolutions that won't work.
>>>>>>
>>>>>> No change.  I also tried using only the previewer like this:
>>>>>>       media-ctl -r
>>>>>>       media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>       media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>>>       media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP preview
>>>>>>       output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12
>>>>>>       2592x1944]' media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12
>>>>>>       2592x1944]'
>>>>>>       media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
>>>>>>       media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
>>>>>>       media-ctl -f  '"OMAP3 ISP preview":1 [YUYV 2574x1935]'
>>>>>>
>>>>>>       yavta --capture=4 -f YUYV -s 2574x1935 -F /dev/video4
>>>>>>
>>>>>> I still only get the frame sync interrupts in the previewer, no buffer
>>>>>> interrupts, hence no data flowing to my application.  What else can I
>>>>>> look at?
>>>>>
>>>>> Do you get VD0 and VD1 interrupts ?
>>>>
>>>> Yes, the CCDC is working correctly, but nothing moves through the
>>>> previewer. Here's a trace of the interrupt sequence I get, repeated over
>>>> and over.  These are printed as __FUNCTION__.__LINE__
>>>> --- ccdc_vd0_isr.1615
>>>> --- ccdc_hs_vs_isr.1482
>>>> --- ccdc_vd1_isr.1664
>>>> --- omap3isp_preview_isr_frame_sync.1373
>>>>
>>>> What's the best tree to try this against?  3.2-rc2 doesn't have the
>>>> BT656 stuff in it yet, so I've been still using my older tree (3.0.0 +
>>>> drivers/media from your tree)
>>>
>>> I thought you were using an MT9P031 ? That doesn't require BT656 support.
>>
>> True, but I have one board that supports either sensor and I want to stay
>> with one source tree.
>
> Sure, but let's start with a non-BT656 tree to rule out issues caused by BT656
> patches. Could you please try mainline v3.1 ?

This sort of works(*), but I'm still having issues (at least I can move frames!)
When I configure the pipeline like this:
   media-ctl -r
   media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
   media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
   media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
   media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
   media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
   media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
   media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
   media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
   media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
   media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 660x496]'
the resulting frames are 666624 bytes each instead of 654720

When I tried to grab from the previewer, the frames were 9969120 instead of 9961380

Any ideas what resolution is actually being moved through?

(*) to build on v3.1, I had to manually add the mt9p031 driver and fix a compile error
in drivers/media/video/omap/omap_vout.c

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
