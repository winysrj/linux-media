Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:35788 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbaGZJrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 05:47:25 -0400
Message-ID: <53D37774.8080904@uli-eckhardt.de>
Date: Sat, 26 Jul 2014 11:40:04 +0200
From: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] imon: Fix internal key table for 15c2:0034
References: <53247996.7050303@uli-eckhardt.de> <20140723175537.0e9e5541.m.chehab@samsung.com>
In-Reply-To: <20140723175537.0e9e5541.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am 23.07.2014 22:55, schrieb Mauro Carvalho Chehab:
> Hi Ulrich,
>
> Em Sat, 15 Mar 2014 17:02:30 +0100
> Ulrich Eckhardt <uli-lirc@uli-eckhardt.de> escreveu:

> First of all, your emailer mangled the patch. It added extra spaces,
> converted tab into spaces, etc. The patch can't be applied like that.

Upps, sorry that was not the problem of the mailer, the problem was
located in front of the keyboard. I will recreate the patches against 
the latest git kernel.

>> +struct imon_usb_dev_descr {
>> +       __u16 flags;
>> +#define IMON_NO_FLAGS 0
>> +#define IMON_NEED_20MS_PKT_DELAY 1
>> +       struct imon_panel_key_table key_table[];
>> +};
>> +
>
> It seems that you're merging two different issues at the same patch.
> Please split it into one patch per logical change.

My first attempt, was to get the front panel to work. But this change 
would have break other iMON remotes. So I decided to extend the current 
design to support the definition of key tables for each USB device 
indifferently.

I will create a first patch for extending the design and a second patch 
for the iMON DH102 specifics.

>> -static u32 imon_panel_key_lookup(u64 code)
>> +static u32 imon_panel_key_lookup(struct imon_context *ictx, u64 code)
>>     {
>> -       int i;
>> +       int i = 0;
>> +       struct imon_panel_key_table *key_table = ictx->dev_descr->key_table;
>>            u32 keycode = KEY_RESERVED;
>>
>> -       for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
>> -               if (imon_panel_key_table[i].hw_code == (code | 0xffee)) {
>> -                       keycode = imon_panel_key_table[i].keycode;
>> +       while (key_table[i].hw_code != 0) {
>
> Why to convert a for into a while? using a for() is more Kernel style
> for loops like this one.

Due to this change, the imon_panel_key_table is not an array of a 
defined size anymore. Depending on the device, more or less definitions 
for the key table are necessary. So AFAIK I can't use the ARRAY_SIZE 
macro for this.

>> @@ -1591,8 +1733,8 @@ static void imon_incoming_packet(struct
>>            spin_lock_irqsave(&ictx->kc_lock, flags);
>>
>>            do_gettimeofday(&t);
>> -       /* KEY_MUTE repeats from knob need to be suppressed */
>> -       if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
>> +       /* repeats from panel need to be suppressed */
>> +       if (ictx->kc == ictx->last_keycode) {
>
>
> Why did you remove KEY_MUTE? Again, best to put its removal on a
> separate patch, clearly stating why this change is needed.

Other keys of the front panel will also send repeats, leading to strange 
behavior. I will put this in the third patch with a detailed description.
-- 
Ulrich Eckhardt                  http://www.uli-eckhardt.de

Ein Blitzableiter auf dem Kirchturm ist das denkbar stärkste
Misstrauensvotum gegen den lieben Gott. (Karl Krauss)
