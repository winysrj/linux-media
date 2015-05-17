Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:45366 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbEQOSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 10:18:33 -0400
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	"Martin Bugge (marbugge)" <marbugge@cisco.com>,
	"Mats Randgaard (matrandg)" <matrandg@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 1/4] v4l2-dv-timings: Add interlace support in
 detect cvt/gtf
Date: Sun, 17 May 2015 14:18:30 +0000
Message-ID: <D17D253E.47B41%prladdha@cisco.com>
In-Reply-To: <5555C32D.4020006@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E356070829C9C4E8C287AD071158183@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for reviewing Hans. My answer below -

On 15/05/15 3:28 pm, "Hans Verkuil" <hverkuil@xs4all.nl> wrote:

>Hi Prashant,
>
>Sorry for the very late review, I finally have time today to go through
>my pending patches.
>
>I have one question, see below:
>
>
>> @@ -539,9 +555,11 @@ bool v4l2_detect_gtf(unsigned frame_height,
>>  
>>  	/* Vertical */
>>  	v_fp = GTF_V_FP;
>> -
>>  	v_bp = (GTF_MIN_VSYNC_BP * hfreq + 500000) / 1000000 - vsync;
>> -	image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
>> +	if (interlaced)
>> +		image_height = (frame_height - 2 * v_fp - 2 * vsync - 2 * v_bp) &
>>~0x1;
>> +	else
>> +		image_height = (frame_height - v_fp - vsync - v_bp + 1) & ~0x1;
>>  
>>  	if (image_height < 0)
>>  		return false;
>> @@ -586,11 +604,20 @@ bool v4l2_detect_gtf(unsigned frame_height,
>>  	fmt->bt.hsync = hsync;
>>  	fmt->bt.vsync = vsync;
>>  	fmt->bt.hbackporch = frame_width - image_width - h_fp - hsync;
>> -	fmt->bt.vbackporch = frame_height - image_height - v_fp - vsync;
>> +	fmt->bt.vbackporch = v_bp;
>
>Is this change correct? My main concern comes from the earlier
>image_height calculation
>in the chunk above. The image_height value is rounded to an even value,
>but if the value
>is actually changed due to rounding, then one of the v_fp, vsync or v_bp
>values must
>change by one as well. After all, the frame_height is fixed and
>image_height must be
>even. And frame_height can be even or odd, both are possible. So that one
>line of rounding
>difference must go somewhere in the blanking timings.

Thanks for spotting this. Yes, I agree that it does not look correct. If
the image_height gets rounded to next even value, above calculation will
result in one extra line.

For interlaced case, I am wondering where to absorb the rounding
difference ? I suppose, we cannot absorb this difference in vsync. Should
it be v_bp of even field or odd field ? Not sure, but probably, the bottom
(even) field ?
 
Regards,
Prashant
 

>

