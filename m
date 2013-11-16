Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38537 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3KPReO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Nov 2013 12:34:14 -0500
Message-ID: <5287AC94.5020401@iki.fi>
Date: Sat, 16 Nov 2013 19:34:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
References: <1384103776-4788-1-git-send-email-crope@iki.fi> <5287AAFC.9050209@redhat.com>
In-Reply-To: <5287AAFC.9050209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!
Actually I has already fixed version according to Andy and Hans V. 
comments, which I was just planning to send for you too, just due to 
that issue format selection issue!



On 16.11.2013 19:27, Hans de Goede wrote:
> Hi,
>> @@ -78,7 +78,8 @@ static void v4lconvert_get_framesizes(struct
>> v4lconvert_data *data,
>>       { V4L2_PIX_FMT_RGB24,        24,     1,     5,    0 }, \
>>       { V4L2_PIX_FMT_BGR24,        24,     1,     5,    0 }, \
>>       { V4L2_PIX_FMT_YUV420,        12,     6,     1,    0 }, \
>> -    { V4L2_PIX_FMT_YVU420,        12,     6,     1,    0 }
>> +    { V4L2_PIX_FMT_YVU420,        12,     6,     1,    0 }, \
>> +    { V4L2_PIX_FMT_FLOAT,         0,     0,     0,    0 }
>>
>
> This looks wrong, here you claim that V4L2_PIX_FMT_FLOAT is a supported
> destination
> format. which suggests there will be conversion code from any of the
> supported_src_pixfmts to it, which you don't add (and I don't think we
> will want
> to add.
>
>>   static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>>       SUPPORTED_DST_PIXFMTS,
>> @@ -131,6 +132,8 @@ static const struct v4lconvert_pixfmt
>> supported_src_pixfmts[] = {
>>       { V4L2_PIX_FMT_Y6,         8,    20,    20,    0 },
>>       { V4L2_PIX_FMT_Y10BPACK,    10,    20,    20,    0 },
>>       { V4L2_PIX_FMT_Y16,        16,    20,    20,    0 },
>> +    /* SDR formats */
>> +    { V4L2_PIX_FMT_U8,        0,    0,    0,    0 },
>>   };
>
> Likewise this will tell libv4lconvert that it can convert from
> V4L2_PIX_FMT_U8 to
> any of the supported destination formats, which again is not true.
>
> I suggest simply adding a hardcoded test for the SDR formats to relevant
> code paths
> which use supported_src_pixfmts and when seeing V4L2_PIX_FMT_U8 as
> source only
> support V4L2_PIX_FMT_FLOAT as dest, and short-circuit a whole bunch of
> other tests
> done.

Sounds reasonable. I will try implement it after I do some more 
conversions tests.

regards
Antti

-- 
http://palosaari.fi/
