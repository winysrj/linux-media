Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:39527 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaCaTiP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 15:38:15 -0400
Date: Mon, 31 Mar 2014 21:38:13 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 06/11] rc-core: remove generic scancode filter
Message-ID: <20140331193813.GC9610@hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
 <20140329161116.13234.96485.stgit@zeus.muc.hardeman.nu>
 <53393591.7060405@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53393591.7060405@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 31, 2014 at 10:29:53AM +0100, James Hogan wrote:
>On 29/03/14 16:11, David Härdeman wrote:
>> The generic scancode filtering has questionable value and makes it
>> impossible to determine from userspace if there is an actual
>> scancode hw filter present or not.
>> 
>> So revert the generic parts.
>> 
>> Based on a patch from James Hogan <james.hogan@imgtec.com>, but this
>> version also makes sure that only the valid sysfs files are created
>> in the first place.
>> 
>> Signed-off-by: David Härdeman <david@hardeman.nu>
>> ---
>>  drivers/media/rc/rc-main.c |   66 +++++++++++++++++++++++++++++---------------
>>  include/media/rc-core.h    |    2 +
>>  2 files changed, 45 insertions(+), 23 deletions(-)
>> 
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index ba955ac..8675e07 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -634,7 +634,6 @@ EXPORT_SYMBOL_GPL(rc_repeat);
>>  static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>>  			  u32 scancode, u32 keycode, u8 toggle)
>>  {
>> -	struct rc_scancode_filter *filter;
>>  	bool new_event = (!dev->keypressed		 ||
>>  			  dev->last_protocol != protocol ||
>>  			  dev->last_scancode != scancode ||
>> @@ -643,11 +642,6 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>>  	if (new_event && dev->keypressed)
>>  		ir_do_keyup(dev, false);
>>  
>> -	/* Generic scancode filtering */
>> -	filter = &dev->scancode_filters[RC_FILTER_NORMAL];
>> -	if (filter->mask && ((scancode ^ filter->data) & filter->mask))
>> -		return;
>> -
>>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
>>  
>>  	if (new_event && keycode != KEY_RESERVED) {
>> @@ -1017,14 +1011,11 @@ static ssize_t store_protocols(struct device *device,
>>  	set_filter = (fattr->type == RC_FILTER_NORMAL)
>>  		? dev->s_filter : dev->s_wakeup_filter;
>>  
>> -	if (old_type != type && filter->mask) {
>> +	if (set_filter && old_type != type && filter->mask) {
>>  		local_filter = *filter;
>>  		if (!type) {
>>  			/* no protocol => clear filter */
>>  			ret = -1;
>> -		} else if (!set_filter) {
>> -			/* generic filtering => accept any filter */
>> -			ret = 0;
>>  		} else {
>>  			/* hardware filtering => try setting, otherwise clear */
>>  			ret = set_filter(dev, &local_filter);
>> @@ -1033,8 +1024,7 @@ static ssize_t store_protocols(struct device *device,
>>  			/* clear the filter */
>>  			local_filter.data = 0;
>>  			local_filter.mask = 0;
>> -			if (set_filter)
>> -				set_filter(dev, &local_filter);
>> +			set_filter(dev, &local_filter);
>>  		}
>>  
>>  		/* commit the new filter */
>> @@ -1078,7 +1068,9 @@ static ssize_t show_filter(struct device *device,
>>  		return -EINVAL;
>>  
>>  	mutex_lock(&dev->lock);
>> -	if (fattr->mask)
>> +	if (!dev->s_filter)
>> +		val = 0;
>
>I suspect this should take s_wakeup_filter into account depending on
>fattr->type. It's probably quite common to have a wakeup filter but no
>normal filter.

Thanks for spotting that.

>The rest looks reasonable, though it could easily have been a separate
>patch (at least as long as the show/store callbacks don't assume the
>presence of the callbacks they use).

Yes, I wanted to avoid there being more intermediary states than
necessary (i.e. first a read/writable sysfs file, then one that can't be
read/written, then the file disappears...).

Can still respin it on top of your patch if you prefer.


-- 
David Härdeman
