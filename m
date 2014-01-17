Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54261 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751092AbaAQHN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 02:13:56 -0500
Message-ID: <52D8D889.2030604@iki.fi>
Date: Fri, 17 Jan 2014 09:15:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	florian.vaussard@epfl.ch
CC: linux-media@vger.kernel.org
Subject: Re: Regression inside omap3isp/resizer
References: <52B02A7A.4010901@epfl.ch> <5578156.0MrbcJaUWJ@avalon> <52CEE5EC.3050704@epfl.ch> <1530474.IjFu1Njy3V@avalon>
In-Reply-To: <1530474.IjFu1Njy3V@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Florian,

Laurent Pinchart wrote:
> Hi Florian,
> 
> On Thursday 09 January 2014 19:09:48 Florian Vaussard wrote:
>> On 12/31/2013 09:51 AM, Laurent Pinchart wrote:
>>> Hi Florian,
>>>
>>> Sorry for the late reply.
>>
>> Now it is my turn to be late.
>>
>>> On Monday 23 December 2013 22:47:45 Florian Vaussard wrote:
>>>> On 12/17/2013 11:42 AM, Florian Vaussard wrote:
>>>>> Hello Laurent,
>>>>>
>>>>> I was working on having a functional IOMMU/ISP for 3.14, and had an
>>>>> issue with an image completely distorted. Comparing with another kernel,
>>>>> I saw that PRV_HORZ_INFO and PRV_VERT_INFO differed. On the newer
>>>>> kernel, sph, eph, svl, and slv were all off-by 2, causing my final image
>>>>> to miss 4 pixels on each line, thus distorting the result.
>>>>>
>>>>> Your commit 3fdfedaaa7f243f3347084231c64f6c1be0ba131 '[media] omap3isp:
>>>>> preview: Lower the crop margins' indeed changes PRV_HORZ_INFO and
>>>>> PRV_VERT_INFO by removing the if() condition. Reverting it made my image
>>>>> to be valid again.
>>>>>
>>>>> FYI, my pipeline is:
>>>>>
>>>>> MT9V032 (SGRBG10 752x480) -> CCDC -> PREVIEW (UYVY 752x480) -> RESIZER
>>>>> -> out
>>>>
>>>> Just an XMAS ping on this :-) Do you have any idea how to solve this
>>>> without reverting the patch?
>>>
>>> The patch indeed changed the preview engine margins, but the change is
>>> supposed to be handled by applications. As a base for this discussion
>>> could you please provide the media-ctl -p output before and after applying
>>> the patch ? You can strip the unrelated media entities out of the output.
>>
>> Ok, so I understand the rationale behind this patch, but I am a bit
>> concerned. If this patch requires a change in userspace, this is somehow
>> breaking the userspace, isn't? For example in my case, I will have to
>> change my initialization scripts in order to pass the correct resolution
>> to the pipeline. Most people have probably hard-coded the resolution
>> into their script / application.
> 
> But they shouldn't have. This has never been considered as an ABI. Userspace 
> needs to computes and propagates resolutions through the pipeline dynamically, 
> no hardcode them.
> 
> If your initialization script read the kernel version and aborted for any 
> version other than v3.6, an upgrade to a newer kernel would break the system 
> but you wouldn't call it a kernel regression :-)
> 
> Problems with pipeline configuration shouldn't result in distorted images 
> though. The driver is supposed to refuse to start streaming when the pipeline 
> is misconfigured by making sure that resolutions on connected source and sink 
> pads are identical. A valid pipeline should not distort the image.
> 
> After a quick look at the code the problem we're dealing with seems to be 
> different and shouldn't affect userspace scripts if solved properly. I haven't 
> touched the preview engine crop configuration code for some time now, so I'll 
> need to refresh my memory, but it seems that the removal of
> 
> -       if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
> -           format->code != V4L2_MBUS_FMT_Y10_1X10) {
> -               sph -= 2;
> -               eph += 2;
> -               slv -= 2;
> -               elv += 2;
> -       }
> 
> was wrong. The change to the margins and to preview_try_crop() seem correct, 
> but the preview_config_input_size() function should probably have been kept 
> unmodified. Could you please test reverting that part of the patch only ?
> 
> Sakari, if you have time, could you please have a look at the code and give me 
> your opinion ?

I reviewed the code mostly raw bayer -> yuv in mind; that appeared
correct to me. Now, reading the code again, I agree with you --- the
four above variables are how much additional cropping is performed on
hardware, and if the CFA is enabled, the cropping is implicit rather
than explicit.

It might have been cleaner to add cropping when pixels or lines need to
be dropped rather than the other way around, but just adding the above
lines back is probably the best way forward right now.

The patch itself (excluding the bug) seems fine. Cropping extra pixels
when it wasn't needed for a reason was worth fixing IMO.

-- 
Kind regards,

Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
