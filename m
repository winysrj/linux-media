Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44575 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbeIMTpG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:45:06 -0400
Subject: Re: [PATCH 1/5] media: replace ADOBERGB by OPRGB
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hansverk@cisco.com>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
 <20180913114731.16500-2-hverkuil@xs4all.nl>
 <20180913112903.7275b126@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b5a52531-4d1e-b9ec-1a7a-84d8b73fcfd6@xs4all.nl>
Date: Thu, 13 Sep 2018 16:35:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180913112903.7275b126@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/18 16:29, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Sep 2018 13:47:27 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> The CTA-861 standards have been updated to refer to opRGB instead
>> of AdobeRGB. The official standard is in fact named opRGB, so
>> switch to that.
>>
>> The two old defines referring to ADOBERGB in the public API are
>> put under #ifndef __KERNEL__ and a comment mentions that they are
>> deprecated.
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> 
> 
>> index 184e4dbe8f9c..c1e14a3b476e 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -225,8 +225,12 @@ enum v4l2_colorspace {
>>  	/* For RGB colorspaces such as produces by most webcams. */
>>  	V4L2_COLORSPACE_SRGB          = 8,
>>  
>> -	/* AdobeRGB colorspace */
>> +	/* opRGB colorspace */
>> +	V4L2_COLORSPACE_OPRGB         = 9,
>> +#ifndef __KERNEL__
>> +	/* Deprecated alias for V4L2_COLORSPACE_OPRGB */
>>  	V4L2_COLORSPACE_ADOBERGB      = 9,
>> +#endif
>>  
>>  	/* BT.2020 colorspace, used for UHDTV. */
>>  	V4L2_COLORSPACE_BT2020        = 10,
>> @@ -258,7 +262,7 @@ enum v4l2_xfer_func {
>>  	 *
>>  	 * V4L2_COLORSPACE_SRGB, V4L2_COLORSPACE_JPEG: V4L2_XFER_FUNC_SRGB
>>  	 *
>> -	 * V4L2_COLORSPACE_ADOBERGB: V4L2_XFER_FUNC_ADOBERGB
>> +	 * V4L2_COLORSPACE_OPRGB: V4L2_XFER_FUNC_OPRGB
>>  	 *
>>  	 * V4L2_COLORSPACE_SMPTE240M: V4L2_XFER_FUNC_SMPTE240M
>>  	 *
>> @@ -269,7 +273,11 @@ enum v4l2_xfer_func {
>>  	V4L2_XFER_FUNC_DEFAULT     = 0,
>>  	V4L2_XFER_FUNC_709         = 1,
>>  	V4L2_XFER_FUNC_SRGB        = 2,
>> +	V4L2_XFER_FUNC_OPRGB       = 3,
>> +#ifndef __KERNEL__
>> +	/* Deprecated alias for V4L2_XFER_FUNC_OPRGB */
>>  	V4L2_XFER_FUNC_ADOBERGB    = 3,
>> +#endif
>>  	V4L2_XFER_FUNC_SMPTE240M   = 4,
>>  	V4L2_XFER_FUNC_NONE        = 5,
>>  	V4L2_XFER_FUNC_DCI_P3      = 6,
> 
> Nitpick: instead of having #ifndef inside the enum, I would instead
> place both V4L2_COLORSPACE_ADOBERGB and V4L2_XFER_FUNC_ADOBERGB on
> a separate #define, e. g:
> 
> /*
>  * Deprecated names for Optional RGB colorspace (IEC 61966-2)
>  *
>  * WARNING: Please don't use it on your code, as those can be removed
>  * from Kernelspace in the future.
>  */
> #ifndef __KERNEL__
> # define V4L2_COLORSPACE_ADOBERGB V4L2_COLORSPACE_OPRGB
> # define V4L2_XFER_FUNC_ADOBERGB  V4L2_XFER_FUNC_OPRGB
> #endif
> 
> There are two reasons for that:
> 
> 1) by adding them inside enums and not documenting, you may
>    end by having warnings;
> 
> 2) as you mentioned on patch 0/5, one of the goals is to
>    "avoid possible future trademark complaints."
> 
> So, better to add a clear warning at the Kernel that we may need
> to remove it in the future.

Will do, makes sense.

	Hans
