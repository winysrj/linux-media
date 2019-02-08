Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77801C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472BD2147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfBHJIZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:08:25 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60816 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727238AbfBHJIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 04:08:25 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s290gyrkTBDyIs291gLesI; Fri, 08 Feb 2019 10:08:23 +0100
Subject: Re: [PATCH] v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <c3a4c93b-e331-b049-fddf-7f7196bc362a@xs4all.nl>
 <20190208090629.vta7rf2vvpzftgsp@paasikivi.fi.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e958128c-cc9a-5c99-9871-91c192fb55fd@xs4all.nl>
Date:   Fri, 8 Feb 2019 10:08:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190208090629.vta7rf2vvpzftgsp@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOSAG8fprrLPF1tsEnL28F5iST5GXHkm8ugBgkjff3rGlnbFIAxo3q4A/Wz+MaI5t3u3B66JJ439V+EuuyciHZhZdnu4o4J63hv0l0ahiulUslA2JuxT
 HJ38O4XD7rBVCTevEfg4qHKO+YV296Xu4e76wipv0i6uC2+uXzEFIX2qBEIyUrC25IvALNI0lIuUS5tw0wckzACzE+R0IBfkNArMHUDU3xzTSX1OPf86v7JO
 uM2Osva37YkOHJHB5uwL3Eyvl4GK8kj5Q/VlQSPjhXv+FhgjIFPTe8zAHa0TcI050y6sd4W++/Dh6gGwoLrm4mJwOIXeQUd4QHe/vNkMoSfTz4SpAwX4ccWC
 CuxNHB74
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/8/19 10:06 AM, Sakari Ailus wrote:
> On Fri, Feb 08, 2019 at 09:49:23AM +0100, Hans Verkuil wrote:
>> The sd argument of this macro can be a more complex expression. Since it
>> is used 5 times in the macro it can be evaluated that many times as well.
>>
>> So assign it to a temp variable in the beginning and use that instead.
>>
>> This also avoids any potential side-effects of evaluating sd.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Nice one!
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I wonder if this addresses some of the sparse issues related to using a
> macro to come up with sd?

It does solve those as well, in fact :-)

I rejected the omap3/4 patches in favor of this one, which is a much, much
cleaner solution.

Regards,

	Hans

> 
>> ---
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 47af609dc8f1..34da094a3f40 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -1093,13 +1093,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
>>   */
>>  #define v4l2_subdev_call(sd, o, f, args...)				\
>>  	({								\
>> +		struct v4l2_subdev *__sd = (sd);			\
>>  		int __result;						\
>> -		if (!(sd))						\
>> +		if (!__sd)						\
>>  			__result = -ENODEV;				\
>> -		else if (!((sd)->ops->o && (sd)->ops->o->f))		\
>> +		else if (!(__sd->ops->o && __sd->ops->o->f))		\
>>  			__result = -ENOIOCTLCMD;			\
>>  		else							\
>> -			__result = (sd)->ops->o->f((sd), ##args);	\
>> +			__result = __sd->ops->o->f(__sd, ##args);	\
>>  		__result;						\
>>  	})
>>
> 

