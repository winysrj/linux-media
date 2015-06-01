Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34568 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbbFAHsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 03:48:02 -0400
Message-ID: <556C0E2F.3050702@iki.fi>
Date: Mon, 01 Jun 2015 10:47:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] si2168: Implement own I2C adapter locking
References: <1432933510-19028-1-git-send-email-crope@iki.fi> <556B3D4E.6090509@baker-net.org.uk>
In-Reply-To: <556B3D4E.6090509@baker-net.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2015 07:56 PM, Adam Baker wrote:
> On 29/05/15 22:05, Antti Palosaari wrote:
>> We need own I2C locking because of tuner I2C adapter/repeater.
>> Firmware command is executed using I2C send + reply message. Default
>> I2C adapter locking protects only single I2C operation, not whole
>> send + reply sequence as needed. Due to that, it was possible tuner
>> I2C message interrupts firmware command sequence.
>>
>> Reported-by: Adam Baker <linux@baker-net.org.uk>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>
> Reviewed-by: Adam Baker <linux@baker-net.org.uk>
>
> Having looked over this I can't see any remaining deadlocks or failures
> to provide adequate locking.
>
> Without a detailed device datasheet (the public datasheet is only the
> short version) it is impossible to say
>
> 1) If accessing the I2C gate in between a read and write cycle would
> actually cause a problem, if it doesn't then a simpler solution would be
> possible but it seems reasonable to assume that it does.

Hey, you could very very easily make test and see what happens. Just add 
dummy I2C gate open / close request to si2168_cmd_execute_unlocked() and 
see what happens.

I suspect it will fail as I cannot see how firmware could even report 
status of multiple operations happening same time. Firmware status is 
always first byte of read operation, there is no flag to say which 
operation status is for. OK, currently I2C gate status is not checked at 
all, but still.

i2c_master_send("download firmware packet");
i2c_master_send("open I2C gate");
i2c_master_recv("read status");  <-- which operation status it will be?

Many fw operations are pretty fast and reply is always "firmware ready". 
But there is some operations that will take up to 70ms.

> 2) How effective the retry mechanism is. The current behaviour that
> retries the read cycle without retrying the preceding write means that
> it isn't possible to pass the read and write messages as multiple
> messages to i2c_transfer and let that handle the locking for us.

Passing multiple messages to i2c_transfer() is different that multiple 
i2c_master_send() / i2c_master_recv(). Look what means "repeated start 
condition" from some I2C documentation to understand the difference.


> Do you know how likely it is for this issue to be triggered without the
> signal stats patch applied? My suspicion is that it could only happen if
> user space deliberately tried changing parameters on the tuner and
> frontend at the same time from different threads and hence the fix isn't
> worth pushing to stable.

Those callbacks are driven be DVB core which serializes all operations. 
So it could not happen (without that statistics polling kernel thread).

regards
Antti

-- 
http://palosaari.fi/
