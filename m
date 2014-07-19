Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2733 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaGSNiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jul 2014 09:38:12 -0400
Message-ID: <53CA74B8.2070506@xs4all.nl>
Date: Sat, 19 Jul 2014 15:38:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4lconvert: fix RGB32 conversion
References: <53CA1BCB.1020308@xs4all.nl> <53CA668A.8010401@redhat.com>
In-Reply-To: <53CA668A.8010401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2014 02:37 PM, Hans de Goede wrote:
> Hi,
> 
> On 07/19/2014 09:18 AM, Hans Verkuil wrote:
>> The RGB32 formats start with an alpha byte in memory. So before calling the
>> v4lconvert_rgb32_to_rgb24 or v4lconvert_rgb24_to_yuv420 function skip that initial
>> alpha byte so the src pointer is aligned with the first color component, since
>> that is what those functions expect.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
>> index cea65aa..e4aa54a 100644
>> --- a/lib/libv4lconvert/libv4lconvert.c
>> +++ b/lib/libv4lconvert/libv4lconvert.c
>> @@ -1132,6 +1132,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>>   			errno = EPIPE;
>>   			result = -1;
>>   		}
>> +		src++;
> 
> Hmm what about bgr versus rgb, since those are mirrored, maybe the location of
> the alpha byte is mirrored to, and we should only do the src++ for one of them ?

Uh, that's what I do. Only for the RGB32 pixformats does the src have to be
increased by one. The BGR32 pixformats have the alpha at the end, so there is
no need to increment src.

Regards,

	Hans

> 
>>   		switch (dest_pix_fmt) {
>>   		case V4L2_PIX_FMT_RGB24:
>>   			v4lconvert_rgb32_to_rgb24(src, dest, width, height, 0);
>>
> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

