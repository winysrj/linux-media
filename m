Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1EEQzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 12:55:09 -0400
Message-ID: <4DC2D669.9020000@redhat.com>
Date: Thu, 05 May 2011 13:55:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: CX24116 i2c patch
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com> <BANLkTimiA1k-pbwuri1vAFgsfSwkdTJWAA@mail.gmail.com>
In-Reply-To: <BANLkTimiA1k-pbwuri1vAFgsfSwkdTJWAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 12:25, Devin Heitmueller escreveu:
> On Thu, May 5, 2011 at 8:28 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> Mauro,
>>
>>> Subject: [media] cx24116: add config option to split firmware download
>>> Author:  Antti Palosaari <crope@iki.fi>
>>> Date:    Wed Apr 27 21:03:07 2011 -0300
>>>
>>> It is very rare I2C adapter hardware which can provide 32kB I2C write
>>> as one write. Add .i2c_wr_max option to set desired max packet size.
>>> Split transaction to smaller pieces according to that option.
>>
>> This is none-sense. I'm naking this patch, please unqueue, regress or whatever.
>>
>> The entire point of the i2c message send is that the i2c drivers know
>> nothing about the host i2c implementation, and they should not need
>> to. I2C SEND and RECEIVE are abstract and require no knowledge of the
>> hardware. This is dangerous and generates non-atomic register writes.
>> You cannot guarantee that another thread isn't reading/writing to
>> other registers in the part - breaking the driver.
>>
>> Please fix the host controller to split the i2c messages accordingly
>> (and thus keeping the entire transaction atomic).
>>
>> This is the second time I've seen the 'fix' to a problem by patching
>> the i2c driver. Fix the i2c bridge else we'll see this behavior
>> spreading to multiple i2c driver. It's just wrong.
> 
> I tend to agree with Steven on this one.  That said, these sorts of
> things usually get introduced in cases where the i2c master is not
> well enough understood to know how to split the transactions and still
> preserve the repeat start (common with reverse engineered drivers).
> It can also occur in cases where there really is a hardware limitation
> that prevents the caller from making multiple requests to the chip
> while not sending the stop bit (although this is less common).
> 
> Do we know this to be the case with the anysee bridge?  Is this a
> reverse engineered device?  Is there documentation/datasheets to
> reference?

> 
> Do we know if this is an issue with the i2c master driver not being
> fully baked, or if it's a hardware limitation?

I can't tell you how Antti is working, but, since this is a USB device,
and cx24116 is trying to send a 32KB message via one single I2C transfer,
I can tell you for sure that that this won't work.

USB control messages can have, at maximum, 80 bytes of data on it. So,
the message needs to be broken into 80-byte payloads (assuming that
Anysee accepts the maximum size).

Mauro.

