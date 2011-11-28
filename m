Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:44704 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1K1Mmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 07:42:53 -0500
Message-ID: <4ED381C7.8000007@mlbassoc.com>
Date: Mon, 28 Nov 2011 05:42:47 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Using MT9P031 digital sensor
References: <4EB04001.9050803@mlbassoc.com> <201111241228.38082.laurent.pinchart@ideasonboard.com> <4ECF8101.7050603@mlbassoc.com> <201111281207.46625.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111281207.46625.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-11-28 04:07, Laurent Pinchart wrote:
> Hi Gary,
>
> On Friday 25 November 2011 12:50:25 Gary Thomas wrote:
>> On 2011-11-24 04:28, Laurent Pinchart wrote:
>>> On Wednesday 16 November 2011 13:03:11 Gary Thomas wrote:
>>>> On 2011-11-15 18:26, Laurent Pinchart wrote:
>>>>> On Monday 14 November 2011 12:42:54 Gary Thomas wrote:
>>>>>> On 2011-11-11 07:26, Laurent Pinchart wrote:
>>>>>>> On Wednesday 09 November 2011 17:24:26 Gary Thomas wrote:
>>>>>>>> On 2011-11-09 09:18, Laurent Pinchart wrote:
>>>>>>>>> On Wednesday 09 November 2011 12:01:34 Gary Thomas wrote:
>>>>>>>>>> On 2011-11-08 17:54, Laurent Pinchart wrote:
>>>>>>>>>>> On Tuesday 08 November 2011 14:38:55 Gary Thomas wrote:
>>>>>>>>>>>> On 2011-11-08 06:06, Laurent Pinchart wrote:
>>>>>>>>>>>>> On Tuesday 08 November 2011 13:52:25 Gary Thomas wrote:
>>>>>>>>>>>>>> On 2011-11-08 05:30, Javier Martinez Canillas wrote:
>>>>>>>>>>>>>>> On Tue, Nov 8, 2011 at 1:20 PM, Gary Thomas wrote:
>>>>>>>>>>>>>>>> On 2011-11-04 04:37, Laurent Pinchart wrote:
>>>>>>>>>>>>>>>>> On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
>>>>>>>>>>>>>>>>>> I'm trying to use the MT9P031 digital sensor with the
>>>>>>>>>>>>>>>>>> Media Controller Framework.  media-ctl tells me that the
>>>>>>>>>>>>>>>>>> sensor is set to capture using SGRBG12  2592x1944
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Questions:
>>>>>>>>>>>>>>>>>> * What pixel format in ffmpeg does this correspond to?
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I don't know if ffmpeg supports Bayer formats. The
>>>>>>>>>>>>>>>>> corresponding fourcc in V4L2 is BA12.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ffmpeg doesn't seem to support these formats
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> If your sensor is hooked up to the OMAP3 ISP, you can then
>>>>>>>>>>>>>>>>> configure the pipeline to include the preview engine and
>>>>>>>>>>>>>>>>> the resizer, and capture YUV data
>>>>>>>>>>>>>>>>> at the resizer output.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I am using the OMAP3 ISP, but it's a bit unclear to me how
>>>>>>>>>>>>>>>> to set up the pipeline
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Hi Gary,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I'm also using another sensor mtv9034 with OMAP3 ISP, so
>>>>>>>>>>>>>>> maybe I can help you.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> using media-ctl (I looked for documentation on this tool,
>>>>>>>>>>>>>>>> but came up dry - is there any?)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Do you have an example of how to configure this using the
>>>>>>>>>>>>>>>> OMAP3 ISP?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> This is how I configure the pipeline to connect the CCDC with
>>>>>>>>>>>>>>> the Previewer and Resizer:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>>>>>>>>>> ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>>>>>>>>>>>> ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP
>>>>>>>>>>>>>>> resizer":0[1]' ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3
>>>>>>>>>>>>>>> ISP resizer output":0[1]' ./media-ctl -f '"mt9v032
>>>>>>>>>>>>>>> 3-005c":0[SGRBG10 752x480]' ./media-ctl -f  '"OMAP3 ISP
>>>>>>>>>>>>>>> CCDC":0 [SGRBG10 752x480]' ./media-ctl -f  '"OMAP3 ISP
>>>>>>>>>>>>>>> CCDC":1 [SGRBG10 752x480]' ./media-ctl -f  '"OMAP3 ISP
>>>>>>>>>>>>>>> preview":0 [SGRBG10 752x479]' ./media-ctl -f  '"OMAP3 ISP
>>>>>>>>>>>>>>> resizer":0 [YUYV 734x471]' ./media-ctl -f  '"OMAP3 ISP
>>>>>>>>>>>>>>> resizer":1 [YUYV 640x480]'
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Hope it helps,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Thanks, I'll give this a try.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I assume that your sensor is probably larger than 752x480 (the
>>>>>>>>>>>>>> mt9p031 is 2592x1944 raw) and that setting the smaller frame
>>>>>>>>>>>>>> size enables some scaling and/or cropping in the driver?
>>>>>>>>>>>>>
>>>>>>>>>>>>> The mt9v034 is a wide VGA 752x480 sensor if I'm not mistaken.
>>>>>>>>>>>>> You should modify the resolutions in the above commands
>>>>>>>>>>>>> according to your sensor. Note that the CCDC crops online line
>>>>>>>>>>>>> when outputting data to the preview engine, and that the
>>>>>>>>>>>>> preview engine crops 18 columsn and 8 lines. You can then
>>>>>>>>>>>>> scale the image by modifying the resizer output size.
>>>>>>>>>>>>
>>>>>>>>>>>> Thanks.  After much trial and error (and some kernel printks to
>>>>>>>>>>>>
>>>>>>>>>>>> understand what parameters were failing), I came up with this
>>>>>
>>>>> sequence:
>>>>>>>>>>>>          media-ctl -r
>>>>>>>>>>>>          media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>>>>>>>          media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP
>>>>>>>>>>>>          preview":0[1]' media-ctl -l '"OMAP3 ISP
>>>>>>>>>>>>          preview":1->"OMAP3 ISP resizer":0[1]' media-ctl -l
>>>>>>>>>>>>          '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer
>>>>>>>>>>>>          output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12
>>>>>>>>>>>>          2592x1944]' media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12
>>>>>>>>>>>>          2592x1944]'
>>>>>>>>>>>>          media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG12 2592x1944]'
>>>>>>>>>>>>          media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG12
>>>>>>>>>>>>          2592x1943]' media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV
>>>>>>>>>>>>          2574x1935]' media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV
>>>>>>>>>>>>          642x483]'
>>>>>>>>>>>>
>>>>>>>>>>>> When I tried to grab though, I got this:
>>>>>>>>>>>>
>>>>>>>>>>>> # yavta --capture=4 -f YUYV -s 642x483 -F /dev/video6
>>>>>>>>>>>> Device /dev/video6 opened.
>>>>>>>>>>>> Device `OMAP3 ISP resizer output' on `media' is a video capture
>>>>>>>>>>>> device. Video format set: YUYV (56595559) 642x483 buffer size
>>>>>>>>>>>> 633696 Video format: YUYV (56595559) 642x483 buffer size 633696
>>>>>>>>>>>> 8 buffers requested.
>>>>>>>>>>>> length: 633696 offset: 0
>>>>>>>>>>>> Buffer 0 mapped at address 0x4028c000.
>>>>>>>>>>>> length: 633696 offset: 634880
>>>>>>>>>>>> Buffer 1 mapped at address 0x403d0000.
>>>>>>>>>>>> length: 633696 offset: 1269760
>>>>>>>>>>>> Buffer 2 mapped at address 0x404b3000.
>>>>>>>>>>>> length: 633696 offset: 1904640
>>>>>>>>>>>> Buffer 3 mapped at address 0x4062b000.
>>>>>>>>>>>> length: 633696 offset: 2539520
>>>>>>>>>>>> Buffer 4 mapped at address 0x406d6000.
>>>>>>>>>>>> length: 633696 offset: 3174400
>>>>>>>>>>>> Buffer 5 mapped at address 0x40821000.
>>>>>>>>>>>> length: 633696 offset: 3809280
>>>>>>>>>>>> Buffer 6 mapped at address 0x4097c000.
>>>>>>>>>>>> length: 633696 offset: 4444160
>>>>>>>>>>>> Buffer 7 mapped at address 0x40adf000.
>>>>>>>>>>>>
>>>>>>>>>>>> Unable to handle kernel NULL pointer dereference at virtual
>>>>>>>>>>>> address 00000018
>>>>>>>>>>>
>>>>>>>>>>> Ouch :-(
>>>>>>>>>>>
>>>>>>>>>>> Could you please verify that arch/arm/mach-omap2/board-overo.c
>>>>>>>>>>> includes the following code, and that CONFIG_OMAP_MUX is enabled
>>>>>>>>>>> ?
>>>>>>>>>>
>>>>>>>>>> I'm not using an Overo board - rather one of our own internal
>>>>>>>>>> designs.
>>>>>>>>>
>>>>>>>>> My bad, sorry.
>>>>>>>>>
>>>>>>>>>> I have verified that the pull up/down on those pins is disabled.
>>>>>>>>>>
>>>>>>>>>> The failure is coming from this code in ispccdc.c
>>>>>>>>>>
>>>>>>>>>>         static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
>>>>>>>>>>         {
>>>>>>>>>> 	
>>>>>>>>>> 	  struct isp_pipeline *pipe =
>>>>>>>>>> 		
>>>>>>>>>> 		to_isp_pipeline(&ccdc->video_out.video.entity);
>>>>>>>>>>
>>>>>>>>>> The value of pipe is NULL which leads to the failure.
>>>>>>>>>>
>>>>>>>>>> Questions:
>>>>>>>>>> * I assume that getting HS/VS interrupts is correct in this mode?
>>>>>>>>>> * Why is the statement not written (as all others are)
>>>>>>>>>>
>>>>>>>>>> 	struct isp_pipeline *pipe =
>>>>>>>>>> 	to_isp_pipeline(&ccdc->subdev.entity);
>>>>>>>>>> 	
>>>>>>>>>>         I tried this change and the kernel doesn't crash.
>>>>>>>>>>
>>>>>>>>>> I've found that I can get raw frames out of CCDC, but I don't get
>>>>>>>>>> anything at all when the output continues through the preview
>>>>>>>>>> and/or resize nodes.
>>>>>>>>>>
>>>>>>>>>> Ideas?
>>>>>>>>>
>>>>>>>>> I'm really puzzled, this should have been caught much earlier :-)
>>>>>>>>>
>>>>>>>>> Your analysis makes sense. Would you like to submit a patch
>>>>>>>>> yourself ? If not I can do it.
>>>>>>>>
>>>>>>>> Sure, I can submit a patch. I would like to figure out why it's not
>>>>>>>> working first.
>>>>>>>
>>>>>>> Oops, I've overlooked that, sorry.
>>>>>>>
>>>>>>>> Any ideas how I can debug this? I can't seem to get anything past
>>>>>>>> the CCDC, e.g. into the preview or resize units. Is there some way
>>>>>>>> to trace packets/data through the various stages? Any ideas what
>>>>>>>> might cause it to stall?
>>>>>>>
>>>>>>> How have you configured your pipeline ? Can you try tracing the
>>>>>>> preview engine and/or resizer interrupts ?
>>>>>>
>>>>>> Here's my pipeline:
>>>>>>       media-ctl -r
>>>>>>       media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>>>       media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>>>       media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>>>>>       media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer
>>>>>>       output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12
>>>>>>       2592x1944]' media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG10
>>>>>>       2592x1944]'
>>>>>>       media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
>>>>>>       media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
>>>>>>       media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
>>>>>>       media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 642x483]'
>>>>>>
>>>>>> The full media-ctl dump is at
>>>>>> http://www.mlbassoc.com/misc/pipeline.out
>>>>>>
>>>>>> When I try to grab from /dev/video6 (output node of resizer), I see
>>>>>> only previewer interrupts, no resizer interrrupts.  I added a simple
>>>>>> printk at each of the previewer/resizer *_isr functions, and I only
>>>>>>
>>>>>> ever see this one:
>>>>>>       omap3isp_preview_isr_frame_sync.1373
>>>>>>
>>>>>> Can you give me an overview of what events/interrupts should occur so
>>>>>> I can try to trace through the ISP to see where it is failing?
>>>>>
>>>>> The CCDC generates VD0, VD1 and HS/VS interrupts regardless of whether
>>>>> it processes video or not, as long as it receives a video stream at
>>>>> its input. The preview engine and resizer will only generate an
>>>>> interrupt after writing an image to memory. With your above
>>>>> configuration VD0, VD1, HS/VS and resizer interrupts should be
>>>>> generated.
>>>>>
>>>>> Your pipeline configuration looks correct, except that the downscaling
>>>>> factor is slightly larger than 4. Could you try to setup the resizer to
>>>>> output a 2574x1935 image instead of 642x483 ? If that works, try to
>>>>> downscale to 660x496. If that works as well, the driver should be fixed
>>>>> to disallow resolutions that won't work.
>>>>
>>>> No change.  I also tried using only the previewer like this:
>>>>      media-ctl -r
>>>>      media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>>>      media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>      media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP preview
>>>>      output":0[1]' media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
>>>>      media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
>>>>      media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1944]'
>>>>      media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 2592x1943]'
>>>>      media-ctl -f  '"OMAP3 ISP preview":1 [YUYV 2574x1935]'
>>>>
>>>>      yavta --capture=4 -f YUYV -s 2574x1935 -F /dev/video4
>>>>
>>>> I still only get the frame sync interrupts in the previewer, no buffer
>>>> interrupts, hence no data flowing to my application.  What else can I
>>>> look at?
>>>
>>> Do you get VD0 and VD1 interrupts ?
>>
>> Yes, the CCDC is working correctly, but nothing moves through the
>> previewer. Here's a trace of the interrupt sequence I get, repeated over
>> and over.  These are printed as __FUNCTION__.__LINE__
>> --- ccdc_vd0_isr.1615
>> --- ccdc_hs_vs_isr.1482
>> --- ccdc_vd1_isr.1664
>> --- omap3isp_preview_isr_frame_sync.1373
>>
>> What's the best tree to try this against?  3.2-rc2 doesn't have the BT656
>> stuff in it yet, so I've been still using my older tree (3.0.0 +
>> drivers/media from your tree)
>
> I thought you were using an MT9P031 ? That doesn't require BT656 support.
>

True, but I have one board that supports either sensor and I want to stay
with one source tree.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
