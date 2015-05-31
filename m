Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout06.plus.net ([212.159.14.18]:44358 "EHLO
	avasout06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbEaRE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 13:04:26 -0400
Message-ID: <556B3D4E.6090509@baker-net.org.uk>
Date: Sun, 31 May 2015 17:56:46 +0100
From: Adam Baker <linux@baker-net.org.uk>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] si2168: Implement own I2C adapter locking
References: <1432933510-19028-1-git-send-email-crope@iki.fi>
In-Reply-To: <1432933510-19028-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/05/15 22:05, Antti Palosaari wrote:
> We need own I2C locking because of tuner I2C adapter/repeater.
> Firmware command is executed using I2C send + reply message. Default
> I2C adapter locking protects only single I2C operation, not whole
> send + reply sequence as needed. Due to that, it was possible tuner
> I2C message interrupts firmware command sequence.
>
> Reported-by: Adam Baker <linux@baker-net.org.uk>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---

Reviewed-by: Adam Baker <linux@baker-net.org.uk>

Having looked over this I can't see any remaining deadlocks or failures 
to provide adequate locking.

Without a detailed device datasheet (the public datasheet is only the 
short version) it is impossible to say

1) If accessing the I2C gate in between a read and write cycle would 
actually cause a problem, if it doesn't then a simpler solution would be 
possible but it seems reasonable to assume that it does.

2) How effective the retry mechanism is. The current behaviour that 
retries the read cycle without retrying the preceding write means that 
it isn't possible to pass the read and write messages as multiple 
messages to i2c_transfer and let that handle the locking for us.

Do you know how likely it is for this issue to be triggered without the 
signal stats patch applied? My suspicion is that it could only happen if 
user space deliberately tried changing parameters on the tuner and 
frontend at the same time from different threads and hence the fix isn't 
worth pushing to stable.

Adam
