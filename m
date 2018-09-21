Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35815 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388875AbeIUNct (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 09:32:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id y20-v6so9961817edq.2
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 00:45:09 -0700 (PDT)
Subject: Re: [PATCH] libv4l: Add support for BAYER10P format conversion
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
References: <20180920200406.18066-1-ricardo.ribalda@gmail.com>
 <18939b75-e0b2-5893-f462-90cce035e7f9@redhat.com>
 <CAPybu_3DGBhdKByNiZgu+aQ+r8PGAQgokr7=0DpnYwWdiqJvwA@mail.gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <4152d2d4-efae-d8f5-ceb3-26f93530e5e5@redhat.com>
Date: Fri, 21 Sep 2018 09:45:07 +0200
MIME-Version: 1.0
In-Reply-To: <CAPybu_3DGBhdKByNiZgu+aQ+r8PGAQgokr7=0DpnYwWdiqJvwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21-09-18 09:40, Ricardo Ribalda Delgado wrote:
> Hi Hans
> 
> On Fri, Sep 21, 2018 at 9:38 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi,
>>
>> On 20-09-18 22:04, Ricardo Ribalda Delgado wrote:
>>> Add support for 10 bit packet Bayer formats:
>>> -V4L2_PIX_FMT_SBGGR10P
>>> -V4L2_PIX_FMT_SGBRG10P
>>> -V4L2_PIX_FMT_SGRBG10P
>>> -V4L2_PIX_FMT_SRGGB10P
>>>
>>> These formats pack the 2 LSBs for every 4 pixels in an indeppendent
>>> byte.
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>    lib/libv4lconvert/bayer.c              | 15 +++++++++++
>>>    lib/libv4lconvert/libv4lconvert-priv.h |  4 +++
>>>    lib/libv4lconvert/libv4lconvert.c      | 35 ++++++++++++++++++++++++++
>>>    3 files changed, 54 insertions(+)
>>>
>>> diff --git a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
>>> index 4b70ddd9..d7d488f9 100644
>>> --- a/lib/libv4lconvert/bayer.c
>>> +++ b/lib/libv4lconvert/bayer.c
>>> @@ -631,3 +631,18 @@ void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
>>>        v4lconvert_border_bayer_line_to_y(bayer + stride, bayer, ydst, width,
>>>                        !start_with_green, !blue_line);
>>>    }
>>> +
>>> +void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>>> +             unsigned char *bayer8, int width, int height)
>>> +{
>>> +     long i, len = width * height;
>>> +     uint32_t *src, *dst;
>>> +
>>> +     src = (uint32_t *)bayer10p;
>>> +     dst = (uint32_t *)bayer8;
>>> +     for (i = 0; i < len ; i += 4) {
>>> +             *dst = *src;
>>> +             dst++;
>>> +             src = (uint32_t *)(((uint8_t *)src) + 5);
>>
>> This will lead to unaligned 32 bit integer accesses which will terminate
>> the program with an illegal instruction on pretty much all architectures
>> except for x86.
> 
> I see your point, but I am actually using this code on ARM64 with no issues.

That is weird, this is definitely illegal on armv7 perhaps the compiler
recognizes the problem and fixes it in the generated code?

> I will change it.

Thanks.

>>
>> You will need to copy the 4 components 1 by 1 so that you only
>> use byte accesses.
>>
>> Also you seem to simply be throwing away the extra 2 bits, although
>> that will work I wonder if that is the best we can do?
> 
> Those are the LSB. If the user want the extra resolution has to use
> the bayer mode.

Ok.

Regards,

Hans



> 
>>
>> Regards,
>>
>> Hans
>>
>>
>>
>>> +     }
>>> +}
>>
>>
>>
>>> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
>>> index 9a467e10..3020a39e 100644
>>> --- a/lib/libv4lconvert/libv4lconvert-priv.h
>>> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
>>> @@ -264,6 +264,10 @@ void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
>>>    void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
>>>                int width, int height, const unsigned int stride, unsigned int src_pixfmt, int yvu);
>>>
>>> +
>>> +void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>>> +             unsigned char *bayer8, int width, int height);
>>> +
>>>    void v4lconvert_hm12_to_rgb24(const unsigned char *src,
>>>                unsigned char *dst, int width, int height);
>>>
>>> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
>>> index d666bd97..b3dbf5a0 100644
>>> --- a/lib/libv4lconvert/libv4lconvert.c
>>> +++ b/lib/libv4lconvert/libv4lconvert.c
>>> @@ -133,6 +133,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>>        { V4L2_PIX_FMT_SRGGB8,           8,      8,      8,     0 },
>>>        { V4L2_PIX_FMT_STV0680,          8,      8,      8,     1 },
>>>        { V4L2_PIX_FMT_SGRBG10,         16,      8,      8,     1 },
>>> +     { V4L2_PIX_FMT_SBGGR10P,        10,      8,      8,     1 },
>>> +     { V4L2_PIX_FMT_SGBRG10P,        10,      8,      8,     1 },
>>> +     { V4L2_PIX_FMT_SGRBG10P,        10,      8,      8,     1 },
>>> +     { V4L2_PIX_FMT_SRGGB10P,        10,      8,      8,     1 },
>>>        /* compressed bayer */
>>>        { V4L2_PIX_FMT_SPCA561,          0,      9,      9,     1 },
>>>        { V4L2_PIX_FMT_SN9C10X,          0,      9,      9,     1 },
>>> @@ -687,6 +691,10 @@ static int v4lconvert_processing_needs_double_conversion(
>>>        case V4L2_PIX_FMT_SGBRG8:
>>>        case V4L2_PIX_FMT_SGRBG8:
>>>        case V4L2_PIX_FMT_SRGGB8:
>>> +     case V4L2_PIX_FMT_SBGGR10P:
>>> +     case V4L2_PIX_FMT_SGBRG10P:
>>> +     case V4L2_PIX_FMT_SGRBG10P:
>>> +     case V4L2_PIX_FMT_SRGGB10P:
>>>        case V4L2_PIX_FMT_STV0680:
>>>                return 0;
>>>        }
>>> @@ -979,6 +987,33 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>>>        }
>>>
>>>                /* Raw bayer formats */
>>> +     case V4L2_PIX_FMT_SBGGR10P:
>>> +     case V4L2_PIX_FMT_SGBRG10P:
>>> +     case V4L2_PIX_FMT_SGRBG10P:
>>> +     case V4L2_PIX_FMT_SRGGB10P:
>>> +             if (src_size < ((width * height * 10)/8)) {
>>> +                     V4LCONVERT_ERR("short raw bayer10 data frame\n");
>>> +                     errno = EPIPE;
>>> +                     result = -1;
>>> +             }
>>> +             switch (src_pix_fmt) {
>>> +             case V4L2_PIX_FMT_SBGGR10P:
>>> +                     src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
>>> +                     break;
>>> +             case V4L2_PIX_FMT_SGBRG10P:
>>> +                     src_pix_fmt = V4L2_PIX_FMT_SGBRG8;
>>> +                     break;
>>> +             case V4L2_PIX_FMT_SGRBG10P:
>>> +                     src_pix_fmt = V4L2_PIX_FMT_SGRBG8;
>>> +                     break;
>>> +             case V4L2_PIX_FMT_SRGGB10P:
>>> +                     src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
>>> +                     break;
>>> +             }
>>> +             v4lconvert_bayer10p_to_bayer8(src, src, width, height);
>>> +             bytesperline = width;
>>> +
>>> +     /* Fall-through*/
>>>        case V4L2_PIX_FMT_SBGGR8:
>>>        case V4L2_PIX_FMT_SGBRG8:
>>>        case V4L2_PIX_FMT_SGRBG8:
>>>
> 
> 
> 
