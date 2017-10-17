Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:22668 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755515AbdJQJRN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 05:17:13 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9H9DFVS020910
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 10:17:11 +0100
Received: from mail-pf0-f199.google.com (mail-pf0-f199.google.com [209.85.192.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2dk8001dag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 10:17:11 +0100
Received: by mail-pf0-f199.google.com with SMTP id n14so924548pfh.15
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 02:17:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013210937.pzgmozz7elsb3yo5@valkosipuli.retiisi.org.uk>
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
 <e6dfbe4afd3f1db4c3f8a81c0813dc418896f5e1.1505916622.git.dave.stevenson@raspberrypi.org>
 <20171013210937.pzgmozz7elsb3yo5@valkosipuli.retiisi.org.uk>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Tue, 17 Oct 2017 10:17:07 +0100
Message-ID: <CAAoAYcN441pVUqCu00hbKmEQWyNaK4jdwkufpJ2P8iXkcQG5KA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] [media] v4l2-common: Add helper function for
 fourcc to string
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari.

On 13 October 2017 at 22:09, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Dave,
>
> On Wed, Sep 20, 2017 at 05:07:54PM +0100, Dave Stevenson wrote:
>> New helper function char *v4l2_fourcc2s(u32 fourcc, char *buf)
>> that converts a fourcc into a nice printable version.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>> ---
>>
>> No changes from v2 to v3
>>
>>  drivers/media/v4l2-core/v4l2-common.c | 18 ++++++++++++++++++
>>  include/media/v4l2-common.h           |  3 +++
>>  2 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>> index a5ea1f5..0219895 100644
>> --- a/drivers/media/v4l2-core/v4l2-common.c
>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>> @@ -405,3 +405,21 @@ void v4l2_get_timestamp(struct timeval *tv)
>>       tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
>> +
>> +char *v4l2_fourcc2s(u32 fourcc, char *buf)
>> +{
>> +     buf[0] = fourcc & 0x7f;
>> +     buf[1] = (fourcc >> 8) & 0x7f;
>> +     buf[2] = (fourcc >> 16) & 0x7f;
>> +     buf[3] = (fourcc >> 24) & 0x7f;
>> +     if (fourcc & (1 << 31)) {
>> +             buf[4] = '-';
>> +             buf[5] = 'B';
>> +             buf[6] = 'E';
>> +             buf[7] = '\0';
>> +     } else {
>> +             buf[4] = '\0';
>> +     }
>> +     return buf;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_fourcc2s);
>> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>> index aac8b7b..5b0fff9 100644
>> --- a/include/media/v4l2-common.h
>> +++ b/include/media/v4l2-common.h
>> @@ -264,4 +264,7 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>>
>>  void v4l2_get_timestamp(struct timeval *tv);
>>
>> +#define V4L2_FOURCC_MAX_SIZE 8
>> +char *v4l2_fourcc2s(u32 fourcc, char *buf);
>> +
>>  #endif /* V4L2_COMMON_H_ */
>
> I like the idea but the use of a character pointer and assuming a length
> looks a bit scary.
>
> As this seems to be used uniquely for printing stuff, a couple of macros
> could be used instead. Something like
>
> #define V4L2_FOURCC_CONV "%c%c%c%c%s"
> #define V4L2_FOURCC_TO_CONV(fourcc) \
>         fourcc & 0x7f, (fourcc >> 8) & 0x7f, (fourcc >> 16) & 0x7f, \
>         (fourcc >> 24) & 0x7f, fourcc & BIT(31) ? "-BE" : ""
>
> You could use it with printk-style functions, e.g.
>
>         printk("blah fourcc " V4L2_FOURCC_CONV " is a nice format",
>                V4L2_FOURCC_TO_CONV(fourcc));
>
> I guess it'd be better to add more parentheses around "fourcc" but it'd be
> less clear here that way.

I was following Hans' suggestion made in
https://www.spinics.net/lists/linux-media/msg117046.html

Hans: Do you agree with Sakari here to make it to a macro?

  Dave
