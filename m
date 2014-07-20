Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaGTO2F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jul 2014 10:28:05 -0400
Message-ID: <53CBD1F3.3020907@redhat.com>
Date: Sun, 20 Jul 2014 16:28:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4lconvert: fix RGB32 conversion
References: <53CA1BCB.1020308@xs4all.nl> <53CA668A.8010401@redhat.com> <53CA74B8.2070506@xs4all.nl>
In-Reply-To: <53CA74B8.2070506@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/19/2014 03:38 PM, Hans Verkuil wrote:
> On 07/19/2014 02:37 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 07/19/2014 09:18 AM, Hans Verkuil wrote:
>>> The RGB32 formats start with an alpha byte in memory. So before calling the
>>> v4lconvert_rgb32_to_rgb24 or v4lconvert_rgb24_to_yuv420 function skip that initial
>>> alpha byte so the src pointer is aligned with the first color component, since
>>> that is what those functions expect.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
>>> index cea65aa..e4aa54a 100644
>>> --- a/lib/libv4lconvert/libv4lconvert.c
>>> +++ b/lib/libv4lconvert/libv4lconvert.c
>>> @@ -1132,6 +1132,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>>>   			errno = EPIPE;
>>>   			result = -1;
>>>   		}
>>> +		src++;
>>
>> Hmm what about bgr versus rgb, since those are mirrored, maybe the location of
>> the alpha byte is mirrored to, and we should only do the src++ for one of them ?
> 
> Uh, that's what I do. Only for the RGB32 pixformats does the src have to be
> increased by one. The BGR32 pixformats have the alpha at the end, so there is
> no need to increment src.

Duh, I did not look closely enough, so the original patch is:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Feel free to push it.

Regards,

Hans
