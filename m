Return-Path: <SRS0=E4aF=O2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C014C43387
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 09:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663482084D
	for <linux-media@archiver.kernel.org>; Mon, 17 Dec 2018 09:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbeLQJZA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:25:00 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44454 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbeLQJY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Dec 2018 04:24:59 -0500
Received: from [IPv6:2001:983:e9a7:1:2173:27fa:b490:7464] ([IPv6:2001:983:e9a7:1:2173:27fa:b490:7464])
        by smtp-cloud9.xs4all.net with ESMTPA
        id Yp8wgbeaYMlDTYp8xgbQjM; Mon, 17 Dec 2018 10:24:57 +0100
Subject: Re: [PATCHv5 5/8] videodev2.h: add v4l2_timeval_to_ns inline function
To:     Jonas Karlman <jonas@kwiboo.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-6-hverkuil-cisco@xs4all.nl>
 <AM0PR03MB4676BB01D8793B9F8B7763D4ACA30@AM0PR03MB4676.eurprd03.prod.outlook.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <78dfa123-f8d2-826c-6ae8-19180fe61707@xs4all.nl>
Date:   Mon, 17 Dec 2018 10:24:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <AM0PR03MB4676BB01D8793B9F8B7763D4ACA30@AM0PR03MB4676.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKng/Cpe27nSTNohXbU1+BsJNQbJMFoEEr3FFw8wHF0R6rpQeoLrf9V4flroVmd5C8R8NcH2CgR72hOGunB8sgAxhKWDR6jef8OZ0Og2H97T3Rg+5QHO
 iCHA3rRs9QrcidJklI5ZeRkprMx00rQq5jPsG9RhLV9XQCKHJkQ+qiE7HJZCvfPAaT0uPG6x5Adi8T0ugjR5TXGd87VyXRPaPI8R7L9f7p/x8ntxW0gkYgh0
 uufYgZEouR6iVBqMvudFS4dktLUx6rd1+5a3TASrvQE78Frw44IX2JZSKw3UydSTtFI30zQgLfka+2gXGmqTLYO6oRu1wjnYJPoCIc9UtoXhsM4yP9qeXbQ3
 w3mrFGOp6IS4MDnhOONqNiKZofZOiQ+56cQNnd7+NiyjkGu2qa2De8mmFNB1Bf0LNBxPtEi1GG+thh2Bp9SLuNQO6LK9NVo4a5KaJRJUxA27tDliwGDUcIxB
 cQ0UdzLujFsnQ10Gnemp4dRKe5VDUJXKr7g9vMNUpATP3XBknr+9athjvgY=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/16/18 10:47 PM, Jonas Karlman wrote:
> 
> On 2018-12-12 13:38, hverkuil-cisco@xs4all.nl wrote:
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> We want to be able to uniquely identify buffers for stateless
>> codecs. The internal timestamp (a u64) as stored internally in the
>> kernel is a suitable candidate for that, but in struct v4l2_buffer
>> it is represented as a struct timeval.
>>
>> Add a v4l2_timeval_to_ns() function that converts the struct timeval
>> into a u64 in the same way that the kernel does. This makes it possible
>> to use this u64 elsewhere as a unique identifier of the buffer.
>>
>> Since timestamps are also copied from the output buffer to the
>> corresponding capture buffer(s) by M2M devices, the u64 can be
>> used to refer to both output and capture buffers.
>>
>> The plan is that in the future we redesign struct v4l2_buffer and use
>> u64 for the timestamp instead of a struct timeval (which has lots of
>> problems with 32 vs 64 bit and y2038 layout changes), and then there
>> is no more need to use this function.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  include/uapi/linux/videodev2.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 2db1635de956..3580c1ea4fba 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -971,6 +971,18 @@ struct v4l2_buffer {
>>  	};
>>  };
>>  
>> +/**
>> + * v4l2_timeval_to_ns - Convert timeval to nanoseconds
>> + * @ts:		pointer to the timeval variable to be converted
>> + *
>> + * Returns the scalar nanosecond representation of the timeval
>> + * parameter.
>> + */
>> +static inline u64 v4l2_timeval_to_ns(const struct timeval *tv)
>> +{
>> +	return (__u64)tv->tv_sec * 1000000000ULL + tv->tv_usec * 1000;
>> +}
> This is causing a compile issue in userspace application, replacing u64
> with __u64 solves the compile issue below.
> 
> In file included from libavcodec/v4l2_request.h:22,
>                  from libavcodec/v4l2_request.c:28:
> /home/docker/LibreELEC/build.LibreELEC-H3.arm-9.0-devel/toolchain/armv7ve-libreelec-linux-gnueabi/sysroot/usr/include/linux/videodev2.h:975:19:
> error: unknown type name 'u64'
>  static __inline__ u64 v4l2_timeval_to_ns(const struct timeval *tv)
>                    ^~~

Oops, I missed that one. Fixed in my git branch.

Thanks for reporting this!

	Hans

> 
> Regards,
> Jonas
>> +
>>  /*  Flags for 'flags' field */
>>  /* Buffer is mapped (flag) */
>>  #define V4L2_BUF_FLAG_MAPPED			0x00000001

