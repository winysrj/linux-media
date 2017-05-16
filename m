Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33379 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdEPM4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 08:56:38 -0400
Subject: Re: [patch, libv4l]: Introduce define for lookup table size
To: Pavel Machek <pavel@ucw.cz>
References: <20170424212914.GA20780@amd> <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd> <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd> <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd> <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd> <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
Date: Tue, 16 May 2017 14:56:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170516124519.GA25650@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/05/17 14:45, Pavel Machek wrote:
> Hi!
> 
>>> Make lookup table size configurable at compile-time.
>>
>> I don't think I'll take this patch. The problem is that if we really add
>> support for 10 or 12 bit lookup tables in the future, then just changing
>> LSIZE isn't enough.
>>
>> This patch doesn't really add anything as it stands.
> 
> Well, currently we have 256, 255 and 0xff sprinkled through the code,
> when it means to say "lookup table size". That is quite wrong (because
> you can't really grep "what depends on the table size).
> 
> And BTW with the LSIZE set to 1024, 10 bit processing seems to
> work. So it is already useful, at least for me.
> 
> But now I noticed the patch is subtly wrong:
> 
>>> -#define CLIP256(color) (((color) > 0xff) ? 0xff : (((color) < 0) ? 0 : (color)))
>>> +#define CLIPLSIZE(color) (((color) > LSIZE) ? LSIZE : (((color) <
> 0) ? 0 : (color)))
> 
> This should be LSIZE-1.
> 
> So I need to adjust the patch. But I'd still like you to take (fixed
> version) for documentation purposes...

I much rather do this as part of a longer series that actually adds 10 bit support.

The problem is that adding support for 10 bit doesn't mean you can just use LSIZE
all the time since you still need support for 8 bit as well.

E.g. CLIPLSIZE makes no sense, I would expect to see a CLIP256 and a CLIP1024.

So it becomes a bit more complex than just adding an LSIZE define.

Regards,

	Hans

> 
> Best regards,
> 									Pavel
> 
>>>  #define CLIP(color, min, max) (((color) > (max)) ? (max) : (((color) < (min)) ? (min) : (color)))
>>>  
>>>  static int whitebalance_active(struct v4lprocessing_data *data)
>>> @@ -111,10 +111,10 @@ static int whitebalance_calculate_lookup_tables_generic(
>>>  
>>>  	avg_avg = (data->green_avg + data->comp1_avg + data->comp2_avg) / 3;
>>>  
>>> -	for (i = 0; i < 256; i++) {
>>> -		data->comp1[i] = CLIP256(data->comp1[i] * avg_avg / data->comp1_avg);
>>> -		data->green[i] = CLIP256(data->green[i] * avg_avg / data->green_avg);
>>> -		data->comp2[i] = CLIP256(data->comp2[i] * avg_avg / data->comp2_avg);
>>> +	for (i = 0; i < LSIZE; i++) {
>>> +		data->comp1[i] = CLIPLSIZE(data->comp1[i] * avg_avg / data->comp1_avg);
>>> +		data->green[i] = CLIPLSIZE(data->green[i] * avg_avg / data->green_avg);
>>> +		data->comp2[i] = CLIPLSIZE(data->comp2[i] * avg_avg / data->comp2_avg);
>>>  	}
>>>  
>>>  	return 1;
>>>
> 
