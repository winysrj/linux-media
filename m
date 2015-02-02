Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1043 "EHLO
	smtp-out-238.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965037AbbBBUrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 15:47:31 -0500
Message-ID: <54CFE25D.2000707@metafoo.de>
Date: Mon, 02 Feb 2015 21:47:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mark Brown <broonie@kernel.org>, linux-i2c@vger.kernel.org,
	linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
References: <1419367799-14263-1-git-send-email-crope@iki.fi> <1419367799-14263-21-git-send-email-crope@iki.fi> <20150202180726.454dc878@recife.lan> <54CFDCCC.3030006@iki.fi> <20150202203324.GA11486@katana>
In-Reply-To: <20150202203324.GA11486@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2015 09:33 PM, Wolfram Sang wrote:
>
>>> Ok, this may eventually work ok for now, but a further change at the I2C
>>> core could easily break it. So, we need to double check about such
>>> patch with the I2C maintainer.
>>>
>>> Jean,
>>>
>>> Are you ok with such patch? If so, please ack.
>
> Jean handed over I2C to me in late 2012 :)
>
>> Basic problem here is that I2C-mux itself is controlled by same I2C device
>> which implements I2C adapter for tuner.
>>
>> Here is what connections looks like:
>>   ___________         ____________         ____________
>> |  USB IF   |       |   demod    |       |    tuner   |
>> |-----------|       |------------|       |------------|
>> |           |--I2C--|-----/ -----|--I2C--|            |
>> |I2C master |       |  I2C mux   |       | I2C slave  |
>> |___________|       |____________|       |____________|
>>
>>
>> So when tuner is called via I2C, it needs recursively call same I2C adapter
>> which is already locked. More elegant solution would be indeed nice.
>
> So, AFAIU this is the same problem that I2C based mux devices have (like
> drivers/i2c/muxes/i2c-mux-pca954x.c)? They also use the unlocked
> transfers...

But those are all called with the lock for the adapter being held. I'm not 
convinced this is the same for this patch. This patch seems to add a device 
mutex which protects against concurrent access to the bus with the device 
itself, but not against concurrent access with other devices on the same bus.
