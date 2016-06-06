Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30294 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbcFFJE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 05:04:56 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O8C007MAEK67500@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Jun 2016 10:04:54 +0100 (BST)
Subject: Re: [PATCH] [media]: Driver for Toshiba et8ek8 5MP sensor
To: Pavel Machek <pavel@ucw.cz>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
References: <20160501134122.GG26360@valkosipuli.retiisi.org.uk>
 <1462287004-21099-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160524111901.GB18307@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <57553CA5.40908@samsung.com>
Date: Mon, 06 Jun 2016 11:04:37 +0200
MIME-version: 1.0
In-reply-to: <20160524111901.GB18307@amd>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 01:19 PM, Pavel Machek wrote:
>> +/*
>> > + * Write a list of registers to i2c device.
>> > + *
>> > + * The list of registers is terminated by ET8EK8_REG_TERM.
>> > + * Returns zero if successful, or non-zero otherwise.
>> > + */
>> > +static int et8ek8_i2c_write_regs(struct i2c_client *client,
>> > +				 const struct et8ek8_reg reglist[])
>> > +{
>> > +	int r, cnt = 0;
>> > +	const struct et8ek8_reg *next, *wnext;
>> > +
>> > +	if (!client->adapter)
>> > +		return -ENODEV;
>> > +
>> > +	if (reglist == NULL)
>
> (!reglist) ? :-). Actually, you can keep your preffered style there,
> but maybe ammount of if (something that can not happen) return
> ... should be reduced. Noone should ever call this without valid
> reglist or client->adapter, right?
> 
>> > +		return -EINVAL;
>> > +
>> > +	/* Initialize list pointers to the start of the list */
>> > +	next = wnext = reglist;
>> > +
>> > +	do {
>> > +		/*
>> > +		 * We have to go through the list to figure out how
>> > +		 * many regular writes we have in a row
>> > +		 */
>> > +		while (next->type != ET8EK8_REG_TERM
>> > +		       && next->type != ET8EK8_REG_DELAY) {
>> > +			/*
>> > +			 * Here we check that the actual length fields
>> > +			 * are valid
>> > +			 */
>> > +			if (next->type != ET8EK8_REG_8BIT
>> > +			    &&  next->type != ET8EK8_REG_16BIT) {
> Extra space after &&
> 
>> > +				dev_err(&client->dev,
>> > +					"Invalid value on entry %d 0x%x\n",
>> > +					cnt, next->type);
>> > +				return -EINVAL;
>> > +			}
>
> And maybe this could be just BUG_ON(). 

It definitively doesn't look like a BUG_ON() would be appropriate here,
it's just an unexpected condition in some I2C write function of a rather
not critical device from the whole system operation stability point
of view. Perhaps you just meant WARN_ON()?

BUG_ON() should be used with care, when the condition is not recoverable,
otherwise we are just making debugging unnecessarily harder.

http://lkml.iu.edu/hypermail/linux/kernel/1506.1/00062.html
http://yarchive.net/comp/linux/BUG.html

-- 
Thanks,
Sylwester
