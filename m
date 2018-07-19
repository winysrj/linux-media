Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:59088 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbeGSLWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 07:22:30 -0400
Subject: Re: [PATCH] media: coda: add missing h.264 levels
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20180628110147.24428-1-p.zabel@pengutronix.de>
 <1531996340.3755.5.camel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e35a9f6a-4704-29ad-66c5-b17bc71d18ac@xs4all.nl>
Date: Thu, 19 Jul 2018 12:39:52 +0200
MIME-Version: 1.0
In-Reply-To: <1531996340.3755.5.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/18 12:32, Philipp Zabel wrote:
> Hi,
> 
> On Thu, 2018-06-28 at 13:01 +0200, Philipp Zabel wrote:
>> This enables reordering support for h.264 main profile level 4.2,
>> 5.0, and 5.1 streams. Even though we likely can't play back such
>> streams at full speed, we should still recognize them correctly.
>>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>> ---
>>  drivers/media/platform/coda/coda-h264.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
>> index 0e27412e01f5..07b4c706504f 100644
>> --- a/drivers/media/platform/coda/coda-h264.c
>> +++ b/drivers/media/platform/coda/coda-h264.c
>> @@ -108,6 +108,9 @@ int coda_h264_level(int level_idc)
>>  	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
>>  	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
>>  	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
>> +	case 42: return V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
>> +	case 50: return V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
>> +	case 51: return V4L2_MPEG_VIDEO_H264_LEVEL_5_1;
>>  	default: return -EINVAL;
>>  	}
>>  }
> 
> I've seen that some newer coda patches have been accepted already,
> maybe this fell through the cracks?

No, this was part of a pull request of mine posted July 6th which hasn't
been merged yet (Mauro is traveling with poor internet connectivity). I
think he's back next week, so hopefully we'll see these pull request merged.

Regards,

	Hans
