Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:56199 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757622Ab0EGSjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 14:39:22 -0400
Message-ID: <4BE45DFB.5040705@arcor.de>
Date: Fri, 07 May 2010 20:37:47 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] tm6000: bugfix image position
References: <1273246144-6876-1-git-send-email-stefan.ringel@arcor.de>	 <4BE435C0.4010909@arcor.de> <o2t6e8e83e21005071117je7bca186pa921e964f49f9350@mail.gmail.com>
In-Reply-To: <o2t6e8e83e21005071117je7bca186pa921e964f49f9350@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.05.2010 20:17, schrieb Bee Hock Goh:
> Stefan,
>
> This fix the ugly green line on the top.
>
> btw, do you notice that there seem to be black gap on the left and
> right of the screen?
>   
Have you seen my picture? I corrected that field inverted is, ergo line
1 field 1 is line 0, line 1 field 0 is line 1, line 2 field 1 is line 2,
line 2 field 0 is line 3 ... . I have not wrote from the black gap -
that is video calibration! And what for ugly green  line, what I have is
a green code and that is normal!
> On Fri, May 7, 2010 at 11:46 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>   
>> Am 07.05.2010 17:29, schrieb stefan.ringel@arcor.de:
>>     
>>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>>
>>> bugfix incorrect image and line position in videobuffer
>>>
>>>
>>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>> ---
>>>  drivers/staging/tm6000/tm6000-video.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>>> index 9554472..f7248f0 100644
>>> --- a/drivers/staging/tm6000/tm6000-video.c
>>> +++ b/drivers/staging/tm6000/tm6000-video.c
>>> @@ -223,8 +223,8 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
>>>                        * It should, instead, check if the user selected
>>>                        * entrelaced or non-entrelaced mode
>>>                        */
>>> -                     pos= ((line<<1)+field)*linewidth +
>>> -                             block*TM6000_URB_MSG_LEN;
>>> +                     pos = ((line << 1) - field - 1) * linewidth +
>>> +                             block * TM6000_URB_MSG_LEN;
>>>
>>>                       /* Don't allow to write out of the buffer */
>>>                       if (pos+TM6000_URB_MSG_LEN > (*buf)->vb.size) {
>>>
>>>       
>>
>> http://www.stefanringel.de/pub/tm6000_image_07_05_2010.jpg
>>
>> --
>> Stefan Ringel <stefan.ringel@arcor.de>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Stefan Ringel <stefan.ringel@arcor.de>

