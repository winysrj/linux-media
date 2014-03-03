Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55540 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbaCCMhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 07:37:00 -0500
Message-ID: <53147746.6010804@ti.com>
Date: Mon, 3 Mar 2014 18:06:22 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 7/7] v4l: ti-vpe: Add crop support in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393832008-22174-8-git-send-email-archit@ti.com> <53143439.5030007@xs4all.nl> <53143CAB.4020202@ti.com> <16d801cf36db$23696080$6a3c2180$%debski@samsung.com>
In-Reply-To: <16d801cf36db$23696080$6a3c2180$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 03 March 2014 05:51 PM, Kamil Debski wrote:
> Hi Archit,
>
>> From: Archit Taneja [mailto:archit@ti.com]
>> Sent: Monday, March 03, 2014 9:26 AM
>>
>> Hi,
>>
>> On Monday 03 March 2014 01:20 PM, Hans Verkuil wrote:
>>> Hi Archit!
>>>
>>> On 03/03/2014 08:33 AM, Archit Taneja wrote:
>>>> Add crop ioctl ops. For VPE, cropping only makes sense with the
>> input
>>>> to VPE, or the V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type.
>>>>
>>>> For the CAPTURE type, a S_CROP ioctl results in setting the crop
>>>> region as the whole image itself, hence making crop dimensions same
>> as the pix dimensions.
>>>>
>>>> Setting the crop successfully should result in re-configuration of
>>>> those registers which are affected when either source or destination
>>>> dimensions change, set_srcdst_params() is called for this purpose.
>>>>
>>>> Some standard crop parameter checks are done in __vpe_try_crop().
>>>
>>> Please use the selection ops instead: if you implement cropping with
>>> those then you'll support both the selection API and the old cropping
>>> API will be implemented by the v4l2 core using the selection ops. Two
>> for the price of one...
>>
>> <snip>
>>
>> Thanks for the feedback. I'll use selection ops here.
>
>  From your reply I understand that you will send a v2 of these patches,
> right?
> If so, please correct the typos I mentioned in the patch 5/7.
>
> Also, it is quite late for v3.15. I did already send a pull request to
> Mauro,
> However I have one patch pending. Could you tell me when are you planning to
> post v2 of these patches? I want to decide whether should I wait for your
> patchset or should I send the second pull request with the pending patch
> as soon as possible.

I'll post a v2 of this set by tomorrow(India time). I have worked on a 
patch which converts it to selection ioctls, but I need to test it, and 
get some comments on whether I have implemented the selection ops 
correctly.

Thanks,
Archit


