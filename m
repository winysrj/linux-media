Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51830 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3HBWn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:43:59 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so2560332oag.29
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51FC2F78.1000902@googlemail.com>
References: <1375362294-30741-1-git-send-email-ricardo.ribalda@gmail.com>
 <1375362294-30741-3-git-send-email-ricardo.ribalda@gmail.com> <51FC2F78.1000902@googlemail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Sat, 3 Aug 2013 00:43:38 +0200
Message-ID: <CAPybu_06ZSv3vugt6KLNravTn1qRX5aYjU85mRHrgFjbT5uv=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] libv4lconvert: Support for RGB32 and BGR32 format
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Gregor

Totally agree,

I have just uploaded a new set.

Thanks!

On Sat, Aug 3, 2013 at 12:15 AM, Gregor Jasny <gjasny@googlemail.com> wrote:
> Hello,
>
>
> On 8/1/13 3:04 PM, Ricardo Ribalda Delgado wrote:
>>
>> --- a/lib/libv4lconvert/libv4lconvert-priv.h
>> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
>> @@ -108,7 +108,7 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
>>   int v4lconvert_oom_error(struct v4lconvert_data *data);
>>
>>   void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char
>> *dest,
>> -               const struct v4l2_format *src_fmt, int bgr, int yvu);
>> +               const struct v4l2_format *src_fmt, int bgr, int yvu, int
>> rgb32);
>>
>>   void v4lconvert_yuv420_to_rgb24(const unsigned char *src, unsigned char
>> *dst,
>>                 int width, int height, int yvu);
>
>
>> @@ -47,9 +47,15 @@ void v4lconvert_rgb24_to_yuv420(const unsigned char
>> *src, unsigned char *dest,
>>                                 RGB2Y(src[2], src[1], src[0], *dest++);
>>                         else
>>                                 RGB2Y(src[0], src[1], src[2], *dest++);
>> -                       src += 3;
>> +                       if (rgb32)
>> +                               src += 4;
>> +                       else
>> +                               src += 3;
>
>
> Instead of passing a 0/1 flag here I would call this variable bits_per_pixel
> or bpp and pass 3 or 4 here. This would reduce the if condition ugliness.
>
> Thanks,
> Gregor
>



-- 
Ricardo Ribalda
