Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2289 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3KDJPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 04:15:36 -0500
Message-ID: <527765A9.6030200@xs4all.nl>
Date: Mon, 04 Nov 2013 10:15:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans Petter Selasky <hps@bitfrost.no>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: Re: [BUG] [PATCH 10/21] radio-tea5764: some cleanups and clamp frequency
 when out-of-range AND [PATCH 15/21] tef6862: clamp frequency.
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl> <1369994561-25236-11-git-send-email-hverkuil@xs4all.nl> <526E4E58.1020409@bitfrost.no>
In-Reply-To: <526E4E58.1020409@bitfrost.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 10/28/2013 12:45 PM, Hans Petter Selasky wrote:
> On 05/31/13 12:02, Hans Verkuil wrote:
>>   		return -EINVAL;
>> +	}
>> +	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
>>   	tea5764_power_up(radio);
>> -	tea5764_tune(radio, (f->frequency * 125) / 2);
>> +	tea5764_tune(radio, (freq * 125) / 2);
>>   	return 0;
> 
> Hi Hans,
> 
> Should the part quoted above part perhaps read:
> 
> freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
> 
> Or did "#define clamp() change" recently?

Nope, that's a bug. Thanks for spotting this!

I'll make a patch for this.

Regards,

	Hans

> 
> http://lxr.free-electrons.com/source/include/linux/kernel.h
> 
>> 698 /**
>> 699  * clamp - return a value clamped to a given range with strict typechecking
>> 700  * @val: current value
>> 701  * @min: minimum allowable value
>> 702  * @max: maximum allowable value
>> 703  *
>> 704  * This macro does strict typechecking of min/max to make sure they are of the
>> 705  * same type as val.  See the unnecessary pointer comparisons.
>> 706  */
>> 707 #define clamp(val, min, max) ({                 \
>> 708         typeof(val) __val = (val);              \
>> 709         typeof(min) __min = (min);              \
>> 710         typeof(max) __max = (max);              \
>> 711         (void) (&__val == &__min);              \
>> 712         (void) (&__val == &__max);              \
>> 713         __val = __val < __min ? __min: __val;   \
>> 714         __val > __max ? __max: __val; })
> 
> Thank you!
> 
> Same spotted in:
> 
>>> media_tree/drivers/media/radio/radio-tea5764.c: In function 'vidioc_s_frequency':
>>> media_tree/drivers/media/radio/radio-tea5764.c:359: warning: statement with no effect
>>
>>> media_tree/drivers/media/radio/tef6862.c: In function 'tef6862_s_frequency':
>>> media_tree/drivers/media/radio/tef6862.c:115: warning: statement with no effect
> 
> Keep up the good work!
> 
> --HPS
> 

