Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-035.synserver.de ([212.40.185.35]:1140 "EHLO
	smtp-out-033.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752482AbaLSNpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 08:45:15 -0500
Message-ID: <54942BE5.1060803@metafoo.de>
Date: Fri, 19 Dec 2014 14:45:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] regmap: pass map name to lockdep
References: <1418936717-2806-1-git-send-email-crope@iki.fi> <5493485E.7020803@metafoo.de> <549404DE.3060905@iki.fi>
In-Reply-To: <549404DE.3060905@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2014 11:58 AM, Antti Palosaari wrote:
> On 12/18/2014 11:34 PM, Lars-Peter Clausen wrote:
>> On 12/18/2014 10:05 PM, Antti Palosaari wrote:
>>> lockdep complains recursive locking and deadlock when two different
>>> regmap instances are called in a nested order. That happen easily
>>> for example when both I2C client and muxed/repeater I2C adapter are
>>> using regmap. As a solution, pass regmap name for lockdep in order
>>> to force lockdep validate regmap mutex per driver - not as all regmap
>>> instances grouped together.
>>
>> That's not how it works. Locks are grouped by lock class, the name is
>> just for pretty printing. The only reason you do not get a warning
>> anymore is because you have now different lock classes one for configs
>> with a name and one for configs without a name.
>>
>> You really need a way to specify a custom lock class per regmap instance
>> in order to solve this problem.
>
> I looked example for that solution from v4l controls. So it is also wrong?
>
> https://patchwork.linuxtv.org/patch/17262/

No, that's correct. It creates one lock class per v4l2_ctrl_handler_init() 
invocation site.

>
>
> Do you think I should change to mutex_lock_nested() as documented in
> Documentation/locking/lockdep-design.txt ?

No, mutex_lock_nested() only works if you can identify lock subclasses.

>
> Should these macros used at all:
> include/linux/lockdep.h
>
> There is not much documentation, especially how these recursive lock
> warnings should be silenced.

You have a couple of options, either do what v4l2_ctrl_handler_init() and 
create a lock class key per regmap_init_*() invocation site. Or just add a 
lock class key per regmap instance. Or add a helper function which allows to 
change the lock class of a regmap instance that can be used by drivers where 
we expect that there will be nested locking. E.g. like in a bus master.

- Lars

