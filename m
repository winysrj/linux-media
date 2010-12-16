Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:50282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0LPHju (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 02:39:50 -0500
Message-ID: <4D09C36F.2060003@redhat.com>
Date: Thu, 16 Dec 2010 08:44:47 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org
Subject: Re: Question about libv4lconvert.
References: <20101215171139.b6c1f03a.ospite@studenti.unina.it>	<4D0920CC.7060004@redhat.com> <20101216004927.48944e00.ospite@studenti.unina.it>
In-Reply-To: <20101216004927.48944e00.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/16/2010 12:49 AM, Antonio Ospite wrote:
> On Wed, 15 Dec 2010 21:10:52 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> Hi,
>>
>
> Hi Hans, thanks for the quick reply.
>
>> On 12/15/2010 05:11 PM, Antonio Ospite wrote:
>>> Hi,
>>>
>>> I am taking a look at libv4lconvert, and I have a question about the
>>> logic in v4lconvert_convert_pixfmt(), in some conversion switches there
>>> is code like this:
>>>
>>> 	case V4L2_PIX_FMT_GREY:
>>> 		switch (dest_pix_fmt) {
>>> 		case V4L2_PIX_FMT_RGB24:
>>> 	        case V4L2_PIX_FMT_BGR24:
>>> 			v4lconvert_grey_to_rgb24(src, dest, width, height);
>>> 			break;
>>> 		case V4L2_PIX_FMT_YUV420:
>>> 		case V4L2_PIX_FMT_YVU420:
>>> 			v4lconvert_grey_to_yuv420(src, dest, fmt);
>>> 			break;
>>> 		}
>>> 		if (src_size<   (width * height)) {
>>> 			V4LCONVERT_ERR("short grey data frame\n");
>>> 			errno = EPIPE;
>>> 			result = -1;
>>> 		}
>>> 		break;
>>>
>>> However the conversion routines which are going to be called seem to
>>> assume that the buffers, in particular the source buffer, are of the
>>> correct full frame size when looping over them.
>>>
>>
>> Correct, because they trust that the kernel drivers have allocated large
>> enough buffers to hold a valid frame which is a safe assumption.
>>
>
> Maybe this was the piece I was missing: even a partial (useful) frame
> comes in a full size buffer, right?

Right.

> If so then the current logic is sane
> indeed; and if the current assumption in conversion routines is
> contradicted then it must be due to a defect related to the kernel
> driver.
>

Correct, if the kernel allocates (and thus we mmap) too small buffers for
the current video fmt + dimensions then that is a kernel bug.

<snip>

Regards,

Hans
