Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33110 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbcACNee (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2016 08:34:34 -0500
Received: by mail-io0-f180.google.com with SMTP id q21so134226606iod.0
        for <linux-media@vger.kernel.org>; Sun, 03 Jan 2016 05:34:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451792869.4334.33.camel@perches.com>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<1451792869.4334.33.camel@perches.com>
Date: Sun, 3 Jan 2016 15:34:33 +0200
Message-ID: <CAM_ZknXVt=2VQtdMi6u=EgjEPSdru7Eupq9=Dc3WMNvrVMSXOQ@mail.gmail.com>
Subject: Re: [RFC PATCH v0] Add tw5864 driver
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Joe Perches <joe@perches.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrey Utkin <andrey.od.utkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 3, 2016 at 5:47 AM, Joe Perches <joe@perches.com> wrote:
> several of these have unnecessary parentheses

Thanks, fixed.

> Maybe use bool a bit more

Thanks, fixed.

> or maybe just use fls

Thanks, fls() fit greatly, rewritten the function with compatibility testing.

>> +static inline int bs_size_ue(unsigned int val)
>> +{
>> +     int i_size = 0;
>> +     static const int i_size0_254[255] = {
>
> Same sort of thing

Dropped this procedure because it is not used.
Thanks.

>> diff --git a/drivers/staging/media/tw5864/tw5864-config.c b/drivers/staging/media/tw5864/tw5864-config.c
> []
>> +u8 tw_indir_readb(struct tw5864_dev *dev, u16 addr)
>> +{
>> +     int timeout = 30000;
>
> misleading name, retries would be more proper,
> or maybe use real timed loops.

Thanks, renamed to "retries".

> This seems a little repetitive.

Thanks, reworked.

> u16?

Thanks, fixed.

> odd indentation

Indeed. For some mysterious reason, vim + syntastic insists on this way. Fixed.

>> +#ifdef DEBUG
>> +     dev_dbg(&input->root->pci->dev,
>> +             "input %d, frame md stats: min %u, max %u, avg %u, cells above threshold: %u\n",
>> +             input->input_number, min, max, sum / md_cells,
>> +             cnt_above_thresh);
>> +#endif
>
> unnecessary #ifdef

Not quite. This debug printout works with variables which are declared
in another "#ifdef DEBUG" clause. And it turns out that dev_dbg is
compiled not only if DEBUG is declared, so when I remove this ifdef, I
get "undefined variable" errors. It seems it is compiled if this
condition is met:

#if (defined DEBUG) || (defined CONFIG_DYNAMIC_DEBUG)

so I can wrap my stats variables into this statement instead. But such
change is not equivalent - I guess CONFIG_DYNAMIC_DEBUG is common to
be enabled, so debug stats will be always calculated, even when module
is not under debug. Except if I use DEFINE_DYNAMIC_DEBUG_METADATA etc.
in my code. Please let me know if this can be sorted out in cleaner
way.



On Sun, Jan 3, 2016 at 7:38 AM, Leon Romanovsky <leon@leon.nu> wrote:
> On Sun, Jan 03, 2016 at 03:41:42AM +0200, Andrey Utkin wrote:
> ....
>> +/*
>> + *  TW5864 driver - Exp-Golomb code functions
>> + *
>> + *  Copyright (C) 2015 Bluecherry, LLC <maintainers@bluecherrydvr.com>
>> + *  Copyright (C) 2015 Andrey Utkin <andrey.utkin@corp.bluecherry.net>
>
> I doubt that you have contract with your employer which permits you to
> claim copyright on the work/product.

Thank you for commenting.
I have previously asked my employer to review copyright statment, and
he told this is fine.
Now I have requrested him again with reference to your comment.

-- 
Bluecherry developer.
