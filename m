Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:44881 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbZGSNRb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 09:17:31 -0400
Message-ID: <4A631CEA.4090802@rtr.ca>
Date: Sun, 19 Jul 2009 09:17:30 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key
   funcs and set ir_type
References: <1247862585.10066.16.camel@palomino.walls.org>	<1247862937.10066.21.camel@palomino.walls.org>	<20090719144749.689c2b3a@hyperion.delvare>	<4A6316F9.4070109@rtr.ca> <20090719145513.0502e0c9@hyperion.delvare> <4A631B41.5090301@rtr.ca>
In-Reply-To: <4A631B41.5090301@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark Lord wrote:
> Jean Delvare wrote:
>> Hi Mark,
>>
>> On Sun, 19 Jul 2009 08:52:09 -0400, Mark Lord wrote:
>>> While you folks are looking into ir-kbd-i2c,
>>> perhaps one of you will fix the regressions
>>> introduced in 2.6.31-* ?
>>>
>>> The drive no longer detects/works with the I/R port on
>>> the Hauppauge PVR-250 cards, which is a user-visible regression.
>>
>> This is bad. If there a bugzilla entry? If not, where can I read more
>> details / get in touch with an affected user?
> ..
> 
> I imagine there will be thousands of affected users once the kernel
> is released, but for now I'll volunteer as a guinea-pig.
> 
> It is difficult to test with 2.6.31 on the system at present, though,
> because that kernel also breaks other things that the MythTV box relies on,
> and the system is in regular use as our only PVR.
> 
> Right now, all I know is, that the PVR-250 IR port did not show up
> in /dev/input/ with 2.6.31 after loading ir_kbd_i2c.  But it does show
> up there with all previous kernels going back to the 2.6.1x days.
..

Actually, I meant to say that it does not show up in the output from
the lsinput command, whereas it did show up there in all previous kernels.

> So, to keep the pain level reasonable, perhaps you could send some
> debugging patches, and I'll apply those, reconfigure the machine for
> 2.6.31 again, and collect some output for you.  And also perhaps try
> a few things locally as well to speed up the process.
> 
> Okay?
> 
> Thanks
> 

