Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8281 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LEIM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 03:12:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEJ0017ETGC3F30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 08:15:10 +0000 (GMT)
Received: from [106.116.147.88] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MEJ00DNVTGMZE50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 08:12:23 +0000 (GMT)
Message-id: <50BF01E5.7050405@samsung.com>
Date: Wed, 05 Dec 2012 09:12:21 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
 <20121204232208.GP31879@valkosipuli.retiisi.org.uk>
In-reply-to: <20121204232208.GP31879@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05.12.2012 00:22, Sakari Ailus wrote:
> Hi Andrzej,
>
> On Fri, Nov 23, 2012 at 04:22:30PM +0100, Andrzej Hajda wrote:
>> Function support variable number of subdevs in pipe-line.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   drivers/media/platform/s5p-fimc/fimc-capture.c |  100 +++++++++++++++---------
>>   1 file changed, 64 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
>> index 3acbea3..39c4555 100644
>> --- a/drivers/media/platform/s5p-fimc/fimc-capture.c
>> +++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
>> @@ -794,6 +794,21 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
>>   	return 0;
>>   }
>>   
>> +static struct media_entity *fimc_pipeline_get_head(struct media_entity *me)
>> +{
>> +	struct media_pad *pad = &me->pads[0];
>> +
>> +	while (!(pad->flags & MEDIA_PAD_FL_SOURCE)) {
>> +		pad = media_entity_remote_source(pad);
>> +		if (!pad)
>> +			break;
> Isn't it an error if a sink pad of the entity isn't connected?
> media_entity_remote_source(pad) returns NULL if the link is disabled. I'm
> just wondering if this is possible.
AFAIK documentation says nothing about it and current media_entity 
implementation
accepts pipelines with pads without active links.
In fact during s5c73m3 sensor development I have successfully used such 
pipeline as a temporary solution.
>
>> +		me = pad->entity;
>> +		pad = &me->pads[0];
>> +	}
>> +
>> +	return me;
>> +}
>> +
Regards
Andrzej

