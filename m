Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:51096 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1CKUj3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 15:39:29 -0500
Message-ID: <4D7A8879.5010401@linuxtv.org>
Date: Fri, 11 Mar 2011 21:39:21 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org, rjkm@metzlerbros.de
Subject: Re: [PATCH] Ngene cam device name
References: <419PcksGF8800S02.1299868385@web02.cms.usa.net>
In-Reply-To: <419PcksGF8800S02.1299868385@web02.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> On 03/10/2011 04:29 PM, Issa Gorissen wrote:
>>> As the cxd20099 driver is in staging due to abuse of the sec0 device,
> this
>>> patch renames it to cam0. The sec0 device is not in use and can be
> removed
>>
>> That doesn't solve anything. Besides, your patch doesn't even do what
>> you describe.
>>
>> Wouldn't it be possible to extend the current CA API? If not, shouldn't
>> a new API be created that covers both old and new requirements?
>>
>> It's rather unintuitive that some CAMs appear as ca0, while others as cam0.
>>
>> If it was that easy to fix, it wouldn't be in staging today.
>>
>> Regards,
>> Andreas
> 
> 
> Yes indeed, this patch is missing the update of dnames arrays in dvbdev.c
> 
> Now, according to Mauro comments, he has put this code into staging because of
> the usage of sec0 name for a cam device.
> 
> Please comment on Oliver's explanations from this thread
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg26901.html

Oliver explained that he's not going to put work into this driver,
because he's not using it.

Until now, I haven't heard any reasons for just adding another device
node other than it being easier than defining a proper interface. The
fact that a solution "just works as is" is not sufficient to move a
driver from staging. IMO the CI driver should not have been included at
all in its current shape.

Regards,
Andreas
