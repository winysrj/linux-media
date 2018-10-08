Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:38428 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbeJHUkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Oct 2018 16:40:52 -0400
Subject: Re: [Outreachy kernel] [PATCH vicodec] media: pvrusb2: replace
 `printk` with `pr_*`
To: Greg KH <greg@kroah.com>, Dafna Hirschfeld <dafna3@gmail.com>
Cc: isely@pobox.com, mchehab@kernel.org, helen.koike@collabora.com,
        outreachy-kernel@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20181008120647.10271-1-dafna3@gmail.com>
 <20181008130719.GA20351@kroah.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8882bb79-b4cc-ca79-30b9-2f983cea6f37@xs4all.nl>
Date: Mon, 8 Oct 2018 15:29:03 +0200
MIME-Version: 1.0
In-Reply-To: <20181008130719.GA20351@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/2018 03:07 PM, Greg KH wrote:
> On Mon, Oct 08, 2018 at 03:06:47PM +0300, Dafna Hirschfeld wrote:
>> Replace calls to `printk` with the appropriate `pr_*`
>> macro.
>>
>> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
>> ---
>>  drivers/media/usb/pvrusb2/pvrusb2-debug.h    |  2 +-
>>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |  8 +++---
>>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 28 +++++++++-----------
>>  drivers/media/usb/pvrusb2/pvrusb2-main.c     |  4 +--
>>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c     |  4 +--
>>  5 files changed, 22 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-debug.h b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
>> index 5cd16292e2fa..1323f949f454 100644
>> --- a/drivers/media/usb/pvrusb2/pvrusb2-debug.h
>> +++ b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
>> @@ -17,7 +17,7 @@
>>  
>>  extern int pvrusb2_debug;
>>  
>> -#define pvr2_trace(msk, fmt, arg...) do {if(msk & pvrusb2_debug) printk(KERN_INFO "pvrusb2: " fmt "\n", ##arg); } while (0)
>> +#define pvr2_trace(msk, fmt, arg...) do {if (msk & pvrusb2_debug) pr_info("pvrusb2: " fmt "\n", ##arg); } while (0)
> 
> You should not need prefixes for pr_info() calls.
> 
>>  
>>  /* These are listed in *rough* order of decreasing usefulness and
>>     increasing noise level. */
>> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
>> index a8519da0020b..7702285c1519 100644
>> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
>> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
>> @@ -3293,12 +3293,12 @@ void pvr2_hdw_trigger_module_log(struct pvr2_hdw *hdw)
>>  	int nr = pvr2_hdw_get_unit_number(hdw);
>>  	LOCK_TAKE(hdw->big_lock);
>>  	do {
>> -		printk(KERN_INFO "pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
>> +		pr_info("pvrusb2: =================  START STATUS CARD #%d  =================\n", nr);
> 
> A driver should be using dev_info(), not pr_*.

pvrusb2 is an exception due to historical reasons. I'd rather not switch
over to dev_*.

> 
> Also, for the outreachy application process, I can not accept patches
> outside of drivers/staging/.

Hmm, that means media drivers are out of bounds since drivers in staging/media
are either high-quality drivers waiting for missing core features or that need maturing,
or they are deprecated drivers that will be removed in the not-too-distant future and
we're not accepting patches for those.

Whereas there are loads of old media drivers in driver/media that could use some TLC.
Although pvrusb2 was an unfortunate driver to pick, but Dafna had no way of knowing that.

There might be the odd checkpatch issue in staging/media, but I expect that that will be
slim pickings...

Sorry Dafna, I wasn't aware of this restriction. It looks like you will need to look
elsewhere in staging.

Regards,

	Hans

> 
> sorry,
> 
> greg k-h
> 
