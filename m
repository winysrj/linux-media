Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66156C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 02:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CC55208E3
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 02:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfABCdG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 1 Jan 2019 21:33:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:56752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbfABCdG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Jan 2019 21:33:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jan 2019 18:33:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,429,1539673200"; 
   d="scan'208";a="123329706"
Received: from ipu5-build.bj.intel.com (HELO [10.238.232.171]) ([10.238.232.171])
  by orsmga001.jf.intel.com with ESMTP; 01 Jan 2019 18:33:02 -0800
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1609628.n3aCoxV5Mp@avalon>
 <b7380656-13bd-884d-366f-87d690090be8@linux.intel.com>
 <4147983.Vfm2iTi9Nh@avalon>
From:   Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <c7578347-c1ac-664c-4407-40b968daf377@linux.intel.com>
Date:   Wed, 2 Jan 2019 10:38:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <4147983.Vfm2iTi9Nh@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/26/2018 07:03 PM, Laurent Pinchart wrote:
> Hello Bingbu,
>
> On Monday, 17 December 2018 05:14:44 EET Bingbu Cao wrote:
>> On 12/14/2018 06:24 AM, Laurent Pinchart wrote:
>>> On Wednesday, 12 December 2018 06:55:53 EET Bingbu Cao wrote:
>>>> On 12/11/2018 09:43 PM, Laurent Pinchart wrote:
>>>>> On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
>>>>>> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
>>>>>>
>>>>>> [snip]
>>>>>>
>>>>>>> I can see a couple of steps missing in the script below.
>>>>>>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/0
>>>>>>> 00040.html)
>>>>>>>
>>>>>>>    From patch 02 of this v7 series "doc-rst: Add Intel IPU3
>>>>>>>    documentation", under section "Configuring ImgU V4L2 subdev for
>>>>>>>    image processing"...
>>>>>>>
>>>>>>> 1. The pipe mode needs to be configured for the V4L2 subdev.
>>>>>>>
>>>>>>> Also the pipe mode of the corresponding V4L2 subdev should be set as
>>>>>>> desired (e.g 0 for video mode or 1 for still mode) through the control
>>>>>>> id 0x009819a1 as below.
>>>>>>>
>>>>>>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
>>>>>> I assume the control takes a valid default value ? It's better to set
>>>>>> it explicitly anyway, so I'll do so.
>>>> The video mode is set by default. If you want to set to still mode or
>>>> change mode, you need set the subdev control.
>>>>
>>>>>>> 2. ImgU pipeline needs to be configured for image processing as below.
>>>>>>>
>>>>>>> RAW bayer frames go through the following ISP pipeline HW blocks to
>>>>>>> have the processed image output to the DDR memory.
>>>>>>>
>>>>>>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
>>>>>>> Geometric Distortion Correction (GDC) -> DDR
>>>>>>>
>>>>>>> The ImgU V4L2 subdev has to be configured with the supported
>>>>>>> resolutions in all the above HW blocks, for a given input resolution.
>>>>>>>
>>>>>>> For a given supported resolution for an input frame, the Input Feeder,
>>>>>>> Bayer Down Scaling and GDC blocks should be configured with the
>>>>>>> supported resolutions. This information can be obtained by looking at
>>>>>>> the following IPU3 ISP configuration table for ov5670 sensor.
>>>>>>>
>>>>>>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+
>>>>>>> /master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/
>>>>>>> files/gcss/graph_settings_ov5670.xml
>>>>>>>
>>>>>>> For the ov5670 example, for an input frame with a resolution of
>>>>>>> 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
>>>>>>> resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
>>>>>>> 2560x1920 respectively.
>>>>>> How is the GDC output resolution computed from the input resolution ?
>>>>>> Does the GDC always consume 32 columns and 22 lines ?
>>>> All the intermediate resolutions in the pipeline are determined by the
>>>> actual use case, in other word determined by the IMGU input
>>>> resolution(sensor output) and the final output and viewfinder resolution.
>>>> BDS mainly do Bayer downscaling, it has limitation that the downscaling
>>>> factor must be a value a integer multiple of 1/32.
>>>> GDC output depends on the input and width should be x8 and height x4
>>>> alignment.
>>> Thank you for the information. This will need to be captured in the
>>> documentation, along with information related to how each block in the
>>> hardware pipeline interacts with the image size. It should be possible for
>>> a developer to compute the output and viewfinder resolutions based on the
>>> parameters of the image processing algorithms just with the information
>>> contained in the driver documentation.
>>>
>>>>>>> The following steps prepare the ImgU ISP pipeline for the image
>>>>>>> processing.
>>>>>>>
>>>>>>> 1. The ImgU V4L2 subdev data format should be set by using the
>>>>>>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
>>>>>>> above.
>>>>>> If I understand things correctly, the GDC resolution is the pipeline
>>>>>> output resolution. Why is it configured on pad 0 ?
>>>> We see the GDC output resolution as the input of output system, the sink
>>>> pad format is used for output and viewfinder resolutions.
>>> The ImgU subdev is supposed to represent the ImgU. Pad 0 should thus be
>>> the ImgU input, the format configured there should correspond to the
>>> format on the connected video node, and should thus be the sensor format.
>>> You can then use the crop and compose rectangles on pad 0, along with the
>>> format, crop and compose rectangles on the output and viewfinder pads, to
>>> configure the device. This should be fixed in the driver, and the
>>> documentation should then be updated accordingly.
>> Hi, Laurent,
>>
>> Thanks for your review.
>>
>> I think it make sense for me that using Pad 0 as the ImgU input(IF).
>> However, I prefer using the 2 source pads for output and viewfinder.
>> It makes more sense because the output and viewfinder are independent
>> output.
>>
>> The whole pipeline in ImgU looks like:
>> IF --> BDS --> GDC ---> OUTPUT
>>                   |
>>                   |-----> VF
>>
>> The BDS is used to do Bayer downscaling and GDC can do cropping.
> Does this mean that the main output and the viewfinder output share the same
> scaler, and that the only difference in size between the two outputs is solely
> due to cropping ?
Laurent,
No, output only can do crop and viewfinder support crop and scaling, they share
same input.
>
>> My understanding is that scaled size is configured on the CROP rectangle
>> by COMPOSE selection target, the order seems like not aligned with the
>> actual processing in ImgU if we set the crop/compose on sink pad.
>>
>> Is there some rules for the order of the configuration in the subdev API?
>> Could I use crop selection based on the scaled size?
> Please see figure 4.6 in https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/
> dev-subdev.html. Scaling is configured on the sink pad through the crop and
> compose rectangles, while the source crop rectangle is used to perform
> cropping on the output. If you have a single scaler in the hardware pipeline
> you can thus configure it on the sink pad, with output and viewfinder separate
> cropping configure on the source pad.
>
>>>>>>> 2. The ImgU V4L2 subdev cropping should be set by using the
>>>>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the
>>>>>>> target, using the input feeder height and width.
>>>>>>>
>>>>>>> 3. The ImgU V4L2 subdev composing should be set by using the
>>>>>>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
>>>>>>> target, using the BDS height and width.
>>>>>>>
>>>>>>> Once these 2 steps are done, the raw bayer frames can be input to the
>>>>>>> ImgU V4L2 subdev for processing.
>>>>>> Do I need to capture from both the output and viewfinder nodes ? How
>>>>>> are they related to the IF -> BDS -> GDC pipeline, are they both fed
>>>>>> from the GDC output ? If so, how does the viewfinder scaler fit in that
>>>>>> picture ?
>>>> The output capture should be set, the viewfinder can be disabled.
>>>> The IF and BDS are seen as crop and compose of the imgu input video
>>>> device. The GDC is seen as the subdev sink pad and OUTPUT/VF are source
>>>> pads.
>>> The GDC is the last block in the pipeline according to the information
>>> provided above. How can it be seen as the subdev sink pad ? That doesn't
>>> make sense to me. I'm not asking for the MC graph to expose all internal
>>> blocks of the ImgU, but if you want to retain a single subdev model, the
>>> format on the sink pad needs to correspond to what is provided to the
>>> ImgU. Please see figure 4.6 of
>>> https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-subdev.html for
>>> more information regarding how you can use the sink crop, sink compose
>>> and source crop rectangles.
> [snip]
>

