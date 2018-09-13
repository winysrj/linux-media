Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57744 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728069AbeIMTXU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:23:20 -0400
Subject: Re: [PATCH] staging: cedrus: Fix checkpatch issues
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org
References: <20180913093023.12225-1-maxime.ripard@bootlin.com>
 <20180913105447.1fab110d@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <21bb66d0-21ba-a36d-a3b8-ad5b1689bcbe@xs4all.nl>
Date: Thu, 13 Sep 2018 16:13:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180913105447.1fab110d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/18 15:54, Mauro Carvalho Chehab wrote:
>>  	switch (ctx->src_fmt.pixelformat) {
>>  	case V4L2_PIX_FMT_MPEG2_SLICE:
>> -		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
>> -			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
>> -		run.mpeg2.quantization = cedrus_find_control_data(ctx,
>> -			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
>> +		run.mpeg2.slice_params =
>> +			cedrus_find_control_data(ctx,
>> +						 V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
>> +		run.mpeg2.quantization =
>> +			cedrus_find_control_data(ctx,
>> +						 V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
> 
> Nah, this an example where we should violate the 80-columns limit, in order
> to make easier for humans to understand.
> 
> I would code it as:
> 
> 		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
> 								  V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);

Why not keep this unchanged? There is nothing wrong IMHO with
the original:

		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);

Perfectly readable, and certainly better then Maxime's or your version.

Regards,

	Hans
