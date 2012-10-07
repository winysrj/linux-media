Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63595 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2JGNzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:55:48 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1619317bkc.19
        for <linux-media@vger.kernel.org>; Sun, 07 Oct 2012 06:55:47 -0700 (PDT)
Message-ID: <507189F1.1080306@googlemail.com>
Date: Sun, 07 Oct 2012 15:56:01 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] libv4lconvert: clarify the behavior and resulting restrictions
 of v4lconvert_convert()
References: <1349282919-15332-1-git-send-email-fschaefer.oss@googlemail.com> <50717DFF.8000004@redhat.com>
In-Reply-To: <50717DFF.8000004@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am 07.10.2012 15:05, schrieb Hans de Goede:
> Hi Frank,
>
> Thanks for all your work on this. I'm afraid that atm I'm very busy
> with work, so I don't have time to review your patches. I hope to
> find some time for this next weekend...

No problem, I will send you a reminder in 2 weeks. ;)
I didn't have much time yet to work on further libv4lconvert patches, too.

Regards,
Frank

>
> Regards,
>
> Hans
>
>
> On 10/03/2012 06:48 PM, Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>   lib/include/libv4lconvert.h |   20 ++++++++++++++++++--
>>   1 Datei geändert, 18 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
>>
>> diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
>> index 167b57d..509655e 100644
>> --- a/lib/include/libv4lconvert.h
>> +++ b/lib/include/libv4lconvert.h
>> @@ -89,8 +89,24 @@ LIBV4L_PUBLIC int
>> v4lconvert_needs_conversion(struct v4lconvert_data *data,
>>           const struct v4l2_format *src_fmt,   /* in */
>>           const struct v4l2_format *dest_fmt); /* in */
>>
>> -/* return value of -1 on error, otherwise the amount of bytes
>> written to
>> -   dest */
>> +/* This function does the following conversions:
>> +    - format conversion
>> +    - cropping
>> +   if enabled:
>> +    - processing (auto whitebalance, auto gain, gamma correction)
>> +    - horizontal/vertical flipping
>> +    - 90 degree (clockwise) rotation
>> +
>> +   NOTE: the last 3 steps are enabled/disabled depending on
>> +    - the internal device list
>> +    - the state of the (software emulated) image controls
>> +
>> +   Therefore this function should
>> +    - not be used when getting the frames from libv4l
>> +    - be called only once per frame
>> +   Otherwise this may result in unintended double conversions !
>> +
>> +   Returns the amount of bytes written to dest an -1 on error */
>>   LIBV4L_PUBLIC int v4lconvert_convert(struct v4lconvert_data *data,
>>           const struct v4l2_format *src_fmt,  /* in */
>>           const struct v4l2_format *dest_fmt, /* in */
>>

