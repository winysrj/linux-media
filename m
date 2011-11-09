Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:53931 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab1KILBg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 06:01:36 -0500
Message-ID: <4EBA5D8E.30609@mlbassoc.com>
Date: Wed, 09 Nov 2011 04:01:34 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Using MT9P031 digital sensor
References: <4EB04001.9050803@mlbassoc.com> <201111081406.55967.laurent.pinchart@ideasonboard.com> <4EB930EF.90507@mlbassoc.com> <201111090154.03796.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111090154.03796.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-11-08 17:54, Laurent Pinchart wrote:
> Hi Gary,
>
> On Tuesday 08 November 2011 14:38:55 Gary Thomas wrote:
>> On 2011-11-08 06:06, Laurent Pinchart wrote:
>>> On Tuesday 08 November 2011 13:52:25 Gary Thomas wrote:
>>>> On 2011-11-08 05:30, Javier Martinez Canillas wrote:
>>>>> On Tue, Nov 8, 2011 at 1:20 PM, Gary Thomas wrote:
>>>>>> On 2011-11-04 04:37, Laurent Pinchart wrote:
>>>>>>> On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
>>>>>>>> I'm trying to use the MT9P031 digital sensor with the Media
>>>>>>>> Controller Framework.  media-ctl tells me that the sensor is set to
>>>>>>>> capture using SGRBG12  2592x1944
>>>>>>>>
>>>>>>>> Questions:
>>>>>>>> * What pixel format in ffmpeg does this correspond to?
>>>>>>>
>>>>>>> I don't know if ffmpeg supports Bayer formats. The corresponding
>>>>>>> fourcc in V4L2 is BA12.
>>>>>>
>>>>>> ffmpeg doesn't seem to support these formats
>>>>>>
>>>>>>> If your sensor is hooked up to the OMAP3 ISP, you can then configure
>>>>>>> the pipeline to include the preview engine and the resizer, and
>>>>>>> capture YUV data
>>>>>>> at the resizer output.
>>>>>>
>>>>>> I am using the OMAP3 ISP, but it's a bit unclear to me how to set up
>>>>>> the pipeline
>>>>>
>>>>> Hi Gary,
>>>>>
>>>>> I'm also using another sensor mtv9034 with OMAP3 ISP, so maybe I can
>>>>> help you.
>>>>>
>>>>>> using media-ctl (I looked for documentation on this tool, but came up
>>>>>> dry - is there any?)
>>>>>>
>>>>>> Do you have an example of how to configure this using the OMAP3 ISP?
>>>>>
>>>>> This is how I configure the pipeline to connect the CCDC with the
>>>>> Previewer and Resizer:
>>>>>
>>>>> ./media-ctl -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1]'
>>>>> ./media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>>>> ./media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>>>> ./media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
>>>>> ./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480]'
>>>>> ./media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG10 752x480]'
>>>>> ./media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG10 752x480]'
>>>>> ./media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG10 752x479]'
>>>>> ./media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 734x471]'
>>>>> ./media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 640x480]'
>>>>>
>>>>> Hope it helps,
>>>>
>>>> Thanks, I'll give this a try.
>>>>
>>>> I assume that your sensor is probably larger than 752x480 (the mt9p031
>>>> is 2592x1944 raw) and that setting the smaller frame size enables some
>>>> scaling and/or cropping in the driver?
>>>
>>> The mt9v034 is a wide VGA 752x480 sensor if I'm not mistaken. You should
>>> modify the resolutions in the above commands according to your sensor.
>>> Note that the CCDC crops online line when outputting data to the preview
>>> engine, and that the preview engine crops 18 columsn and 8 lines. You
>>> can then scale the image by modifying the resizer output size.
>>
>> Thanks.  After much trial and error (and some kernel printks to
>> understand what parameters were failing), I came up with this sequence:
>>     media-ctl -r
>>     media-ctl -l '"mt9p031 3-005d":0->"OMAP3 ISP CCDC":0[1]'
>>     media-ctl -l '"OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1]'
>>     media-ctl -l '"OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1]'
>>     media-ctl -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
>>     media-ctl -f '"mt9p031 3-005d":0[SGRBG12 2592x1944]'
>>     media-ctl -f  '"OMAP3 ISP CCDC":0 [SGRBG12 2592x1944]'
>>     media-ctl -f  '"OMAP3 ISP CCDC":1 [SGRBG12 2592x1944]'
>>     media-ctl -f  '"OMAP3 ISP preview":0 [SGRBG12 2592x1943]'
>>     media-ctl -f  '"OMAP3 ISP resizer":0 [YUYV 2574x1935]'
>>     media-ctl -f  '"OMAP3 ISP resizer":1 [YUYV 642x483]'
>>
>> When I tried to grab though, I got this:
>>
>> # yavta --capture=4 -f YUYV -s 642x483 -F /dev/video6
>> Device /dev/video6 opened.
>> Device `OMAP3 ISP resizer output' on `media' is a video capture device.
>> Video format set: YUYV (56595559) 642x483 buffer size 633696
>> Video format: YUYV (56595559) 642x483 buffer size 633696
>> 8 buffers requested.
>> length: 633696 offset: 0
>> Buffer 0 mapped at address 0x4028c000.
>> length: 633696 offset: 634880
>> Buffer 1 mapped at address 0x403d0000.
>> length: 633696 offset: 1269760
>> Buffer 2 mapped at address 0x404b3000.
>> length: 633696 offset: 1904640
>> Buffer 3 mapped at address 0x4062b000.
>> length: 633696 offset: 2539520
>> Buffer 4 mapped at address 0x406d6000.
>> length: 633696 offset: 3174400
>> Buffer 5 mapped at address 0x40821000.
>> length: 633696 offset: 3809280
>> Buffer 6 mapped at address 0x4097c000.
>> length: 633696 offset: 4444160
>> Buffer 7 mapped at address 0x40adf000.
>>
>> Unable to handle kernel NULL pointer dereference at virtual address
>> 00000018
>
> Ouch :-(
>
> Could you please verify that arch/arm/mach-omap2/board-overo.c includes the
> following code, and that CONFIG_OMAP_MUX is enabled ?

I'm not using an Overo board - rather one of our own internal designs.
I have verified that the pull up/down on those pins is disabled.

The failure is coming from this code in ispccdc.c
   static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
   {
	  struct isp_pipeline *pipe =
		to_isp_pipeline(&ccdc->video_out.video.entity);
The value of pipe is NULL which leads to the failure.

Questions:
* I assume that getting HS/VS interrupts is correct in this mode?
* Why is the statement not written (as all others are)
	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
   I tried this change and the kernel doesn't crash.

I've found that I can get raw frames out of CCDC, but I don't get anything at
all when the output continues through the preview and/or resize nodes.

Ideas?

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
