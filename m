Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:30580 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754716AbdJQJ2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 05:28:49 -0400
Subject: Re: [PATCH v3 1/4] [media] v4l2-common: Add helper function for
 fourcc to string
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
 <e6dfbe4afd3f1db4c3f8a81c0813dc418896f5e1.1505916622.git.dave.stevenson@raspberrypi.org>
 <20171013210937.pzgmozz7elsb3yo5@valkosipuli.retiisi.org.uk>
 <CAAoAYcN441pVUqCu00hbKmEQWyNaK4jdwkufpJ2P8iXkcQG5KA@mail.gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <8cd44cbf-6751-c3de-1729-c8c1d54e8b00@cisco.com>
Date: Tue, 17 Oct 2017 11:28:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcN441pVUqCu00hbKmEQWyNaK4jdwkufpJ2P8iXkcQG5KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/17 11:17, Dave Stevenson wrote:
> Hi Sakari.
> 
> On 13 October 2017 at 22:09, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Hi Dave,
>>
>> On Wed, Sep 20, 2017 at 05:07:54PM +0100, Dave Stevenson wrote:
>>> New helper function char *v4l2_fourcc2s(u32 fourcc, char *buf)
>>> that converts a fourcc into a nice printable version.
>>>
>>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>>> ---
>>>
>>> No changes from v2 to v3
>>>
>>>  drivers/media/v4l2-core/v4l2-common.c | 18 ++++++++++++++++++
>>>  include/media/v4l2-common.h           |  3 +++
>>>  2 files changed, 21 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>>> index a5ea1f5..0219895 100644
>>> --- a/drivers/media/v4l2-core/v4l2-common.c
>>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>>> @@ -405,3 +405,21 @@ void v4l2_get_timestamp(struct timeval *tv)
>>>       tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
>>> +
>>> +char *v4l2_fourcc2s(u32 fourcc, char *buf)
>>> +{
>>> +     buf[0] = fourcc & 0x7f;
>>> +     buf[1] = (fourcc >> 8) & 0x7f;
>>> +     buf[2] = (fourcc >> 16) & 0x7f;
>>> +     buf[3] = (fourcc >> 24) & 0x7f;
>>> +     if (fourcc & (1 << 31)) {
>>> +             buf[4] = '-';
>>> +             buf[5] = 'B';
>>> +             buf[6] = 'E';
>>> +             buf[7] = '\0';
>>> +     } else {
>>> +             buf[4] = '\0';
>>> +     }
>>> +     return buf;
>>> +}
>>> +EXPORT_SYMBOL_GPL(v4l2_fourcc2s);
>>> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>>> index aac8b7b..5b0fff9 100644
>>> --- a/include/media/v4l2-common.h
>>> +++ b/include/media/v4l2-common.h
>>> @@ -264,4 +264,7 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>>>
>>>  void v4l2_get_timestamp(struct timeval *tv);
>>>
>>> +#define V4L2_FOURCC_MAX_SIZE 8
>>> +char *v4l2_fourcc2s(u32 fourcc, char *buf);
>>> +
>>>  #endif /* V4L2_COMMON_H_ */
>>
>> I like the idea but the use of a character pointer and assuming a length
>> looks a bit scary.
>>
>> As this seems to be used uniquely for printing stuff, a couple of macros
>> could be used instead. Something like
>>
>> #define V4L2_FOURCC_CONV "%c%c%c%c%s"
>> #define V4L2_FOURCC_TO_CONV(fourcc) \
>>         fourcc & 0x7f, (fourcc >> 8) & 0x7f, (fourcc >> 16) & 0x7f, \
>>         (fourcc >> 24) & 0x7f, fourcc & BIT(31) ? "-BE" : ""

'fourcc' should be in parenthesis '(fourcc)'.

>>
>> You could use it with printk-style functions, e.g.
>>
>>         printk("blah fourcc " V4L2_FOURCC_CONV " is a nice format",
>>                V4L2_FOURCC_TO_CONV(fourcc));
>>
>> I guess it'd be better to add more parentheses around "fourcc" but it'd be
>> less clear here that way.
> 
> I was following Hans' suggestion made in
> https://www.spinics.net/lists/linux-media/msg117046.html
> 
> Hans: Do you agree with Sakari here to make it to a macro?

Not a bad idea. But I think we should add it to the public videodev2.h
header in that case, allowing it to be used by applications as well.

How about calling the defines V4L2_FOURCC_FMT and V4L2_FOURCC_FMT_ARGS?

Regards,

	Hans
