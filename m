Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta.bitpro.no ([92.42.64.202]:32785 "EHLO mta.bitpro.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3J1MCC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 08:02:02 -0400
Message-ID: <526E4E58.1020409@bitfrost.no>
Date: Mon, 28 Oct 2013 12:45:28 +0100
From: Hans Petter Selasky <hps@bitfrost.no>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [BUG] [PATCH 10/21] radio-tea5764: some cleanups and clamp frequency
 when out-of-range AND [PATCH 15/21] tef6862: clamp frequency.
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl> <1369994561-25236-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-11-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/13 12:02, Hans Verkuil wrote:
>   		return -EINVAL;
> +	}
> +	clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);
>   	tea5764_power_up(radio);
> -	tea5764_tune(radio, (f->frequency * 125) / 2);
> +	tea5764_tune(radio, (freq * 125) / 2);
>   	return 0;

Hi Hans,

Should the part quoted above part perhaps read:

freq = clamp(freq, FREQ_MIN * FREQ_MUL, FREQ_MAX * FREQ_MUL);

Or did "#define clamp() change" recently?

http://lxr.free-electrons.com/source/include/linux/kernel.h

> 698 /**
> 699  * clamp - return a value clamped to a given range with strict typechecking
> 700  * @val: current value
> 701  * @min: minimum allowable value
> 702  * @max: maximum allowable value
> 703  *
> 704  * This macro does strict typechecking of min/max to make sure they are of the
> 705  * same type as val.  See the unnecessary pointer comparisons.
> 706  */
> 707 #define clamp(val, min, max) ({                 \
> 708         typeof(val) __val = (val);              \
> 709         typeof(min) __min = (min);              \
> 710         typeof(max) __max = (max);              \
> 711         (void) (&__val == &__min);              \
> 712         (void) (&__val == &__max);              \
> 713         __val = __val < __min ? __min: __val;   \
> 714         __val > __max ? __max: __val; })

Thank you!

Same spotted in:

>> media_tree/drivers/media/radio/radio-tea5764.c: In function 'vidioc_s_frequency':
>> media_tree/drivers/media/radio/radio-tea5764.c:359: warning: statement with no effect
>
>> media_tree/drivers/media/radio/tef6862.c: In function 'tef6862_s_frequency':
>> media_tree/drivers/media/radio/tef6862.c:115: warning: statement with no effect

Keep up the good work!

--HPS
