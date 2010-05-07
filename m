Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:63483 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EGSRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 14:17:38 -0400
Received: by pzk42 with SMTP id 42so630981pzk.4
        for <linux-media@vger.kernel.org>; Fri, 07 May 2010 11:17:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE435C0.4010909@arcor.de>
References: <1273246144-6876-1-git-send-email-stefan.ringel@arcor.de>
	 <4BE435C0.4010909@arcor.de>
Date: Sat, 8 May 2010 02:17:34 +0800
Message-ID: <o2t6e8e83e21005071117je7bca186pa921e964f49f9350@mail.gmail.com>
Subject: Re: [PATCH] tm6000: bugfix image position
From: Bee Hock Goh <beehock@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan,

This fix the ugly green line on the top.

btw, do you notice that there seem to be black gap on the left and
right of the screen?

On Fri, May 7, 2010 at 11:46 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
> Am 07.05.2010 17:29, schrieb stefan.ringel@arcor.de:
>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>
>> bugfix incorrect image and line position in videobuffer
>>
>>
>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>> ---
>>  drivers/staging/tm6000/tm6000-video.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>> index 9554472..f7248f0 100644
>> --- a/drivers/staging/tm6000/tm6000-video.c
>> +++ b/drivers/staging/tm6000/tm6000-video.c
>> @@ -223,8 +223,8 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
>>                        * It should, instead, check if the user selected
>>                        * entrelaced or non-entrelaced mode
>>                        */
>> -                     pos= ((line<<1)+field)*linewidth +
>> -                             block*TM6000_URB_MSG_LEN;
>> +                     pos = ((line << 1) - field - 1) * linewidth +
>> +                             block * TM6000_URB_MSG_LEN;
>>
>>                       /* Don't allow to write out of the buffer */
>>                       if (pos+TM6000_URB_MSG_LEN > (*buf)->vb.size) {
>>
>
>
> http://www.stefanringel.de/pub/tm6000_image_07_05_2010.jpg
>
> --
> Stefan Ringel <stefan.ringel@arcor.de>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
