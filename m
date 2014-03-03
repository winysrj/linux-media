Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaCCI05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 03:26:57 -0500
Message-ID: <53143CAB.4020202@ti.com>
Date: Mon, 3 Mar 2014 13:56:19 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 7/7] v4l: ti-vpe: Add crop support in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393832008-22174-8-git-send-email-archit@ti.com> <53143439.5030007@xs4all.nl>
In-Reply-To: <53143439.5030007@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 03 March 2014 01:20 PM, Hans Verkuil wrote:
> Hi Archit!
>
> On 03/03/2014 08:33 AM, Archit Taneja wrote:
>> Add crop ioctl ops. For VPE, cropping only makes sense with the input to VPE, or
>> the V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type.
>>
>> For the CAPTURE type, a S_CROP ioctl results in setting the crop region as the
>> whole image itself, hence making crop dimensions same as the pix dimensions.
>>
>> Setting the crop successfully should result in re-configuration of those
>> registers which are affected when either source or destination dimensions
>> change, set_srcdst_params() is called for this purpose.
>>
>> Some standard crop parameter checks are done in __vpe_try_crop().
>
> Please use the selection ops instead: if you implement cropping with those then you'll
> support both the selection API and the old cropping API will be implemented by the v4l2
> core using the selection ops. Two for the price of one...

<snip>

Thanks for the feedback. I'll use selection ops here.

Archit


