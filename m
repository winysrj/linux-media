Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51868 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbaCDI12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 03:27:28 -0500
Message-ID: <53158E48.80904@ti.com>
Date: Tue, 4 Mar 2014 13:56:48 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 7/7] v4l: ti-vpe: Add crop support in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393832008-22174-8-git-send-email-archit@ti.com> <53143439.5030007@xs4all.nl> <531582E8.7020800@ti.com> <53158437.6070200@xs4all.nl>
In-Reply-To: <53158437.6070200@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 04 March 2014 01:13 PM, Hans Verkuil wrote:
> On 03/04/2014 08:38 AM, Archit Taneja wrote:
>> Hi Hans,
>>
>> On Monday 03 March 2014 01:20 PM, Hans Verkuil wrote:
>>> Hi Archit!
>>>
>>> On 03/03/2014 08:33 AM, Archit Taneja wrote:
>>>> Add crop ioctl ops. For VPE, cropping only makes sense with the input to VPE, or
>>>> the V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type.
>>>>
>>>> For the CAPTURE type, a S_CROP ioctl results in setting the crop region as the
>>>> whole image itself, hence making crop dimensions same as the pix dimensions.
>>>>
>>>> Setting the crop successfully should result in re-configuration of those
>>>> registers which are affected when either source or destination dimensions
>>>> change, set_srcdst_params() is called for this purpose.
>>>>
>>>> Some standard crop parameter checks are done in __vpe_try_crop().
>>>
>>> Please use the selection ops instead: if you implement cropping with those then you'll
>>> support both the selection API and the old cropping API will be implemented by the v4l2
>>> core using the selection ops. Two for the price of one...
>>
>>
>> When using selection API, I was finding issues using the older cropping
>> API. The v4l_s_crop() ioctl func assumes that "crop means compose for
>> output devices". However, for a m2m device. It probably makes sense to
>> provide the following configuration:
>>
>> for V4L2_BUF_TYPE_VIDEO_OUTPUT (input to the mem to mem HW), use CROP
>> target(to crop the input buffer)
>>
>> and, for V4L2_BUF_TYPE_VIDEO_CAPTURE(output of the mem to mem HW), use
>> COMPOSE target(to place the HW output into a larger region)
>>
>> Don't you think forcing OUTPUT devices to 'COMPOSE' for older cropping
>> API is a bit limiting?
>
> Yes, and that's why the selection API was created to work around that
> limitation :-)
>
> The old cropping API was insufficiently flexible for modern devices, so
> we came up with this replacement.
>
> Another reason why you have to implement the selection API: it's the only
> way to implement your functionality.

Okay, I'll go ahead with the selection API then :)

Archit

