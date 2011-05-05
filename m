Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50099 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1EEPZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 11:25:31 -0400
Received: by ewy4 with SMTP id 4so708378ewy.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 08:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
Date: Thu, 5 May 2011 11:25:29 -0400
Message-ID: <BANLkTimiA1k-pbwuri1vAFgsfSwkdTJWAA@mail.gmail.com>
Subject: Re: CX24116 i2c patch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 5, 2011 at 8:28 AM, Steven Toth <stoth@kernellabs.com> wrote:
> Mauro,
>
>> Subject: [media] cx24116: add config option to split firmware download
>> Author:  Antti Palosaari <crope@iki.fi>
>> Date:    Wed Apr 27 21:03:07 2011 -0300
>>
>> It is very rare I2C adapter hardware which can provide 32kB I2C write
>> as one write. Add .i2c_wr_max option to set desired max packet size.
>> Split transaction to smaller pieces according to that option.
>
> This is none-sense. I'm naking this patch, please unqueue, regress or whatever.
>
> The entire point of the i2c message send is that the i2c drivers know
> nothing about the host i2c implementation, and they should not need
> to. I2C SEND and RECEIVE are abstract and require no knowledge of the
> hardware. This is dangerous and generates non-atomic register writes.
> You cannot guarantee that another thread isn't reading/writing to
> other registers in the part - breaking the driver.
>
> Please fix the host controller to split the i2c messages accordingly
> (and thus keeping the entire transaction atomic).
>
> This is the second time I've seen the 'fix' to a problem by patching
> the i2c driver. Fix the i2c bridge else we'll see this behavior
> spreading to multiple i2c driver. It's just wrong.

I tend to agree with Steven on this one.  That said, these sorts of
things usually get introduced in cases where the i2c master is not
well enough understood to know how to split the transactions and still
preserve the repeat start (common with reverse engineered drivers).
It can also occur in cases where there really is a hardware limitation
that prevents the caller from making multiple requests to the chip
while not sending the stop bit (although this is less common).

Do we know this to be the case with the anysee bridge?  Is this a
reverse engineered device?  Is there documentation/datasheets to
reference?

Do we know if this is an issue with the i2c master driver not being
fully baked, or if it's a hardware limitation?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
