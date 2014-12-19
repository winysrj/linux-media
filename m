Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaLSK6l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:58:41 -0500
Message-ID: <549404DE.3060905@iki.fi>
Date: Fri, 19 Dec 2014 12:58:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] regmap: pass map name to lockdep
References: <1418936717-2806-1-git-send-email-crope@iki.fi> <5493485E.7020803@metafoo.de>
In-Reply-To: <5493485E.7020803@metafoo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2014 11:34 PM, Lars-Peter Clausen wrote:
> On 12/18/2014 10:05 PM, Antti Palosaari wrote:
>> lockdep complains recursive locking and deadlock when two different
>> regmap instances are called in a nested order. That happen easily
>> for example when both I2C client and muxed/repeater I2C adapter are
>> using regmap. As a solution, pass regmap name for lockdep in order
>> to force lockdep validate regmap mutex per driver - not as all regmap
>> instances grouped together.
>
> That's not how it works. Locks are grouped by lock class, the name is
> just for pretty printing. The only reason you do not get a warning
> anymore is because you have now different lock classes one for configs
> with a name and one for configs without a name.
>
> You really need a way to specify a custom lock class per regmap instance
> in order to solve this problem.

I looked example for that solution from v4l controls. So it is also wrong?

https://patchwork.linuxtv.org/patch/17262/


Do you think I should change to mutex_lock_nested() as documented in
Documentation/locking/lockdep-design.txt ?

Should these macros used at all:
include/linux/lockdep.h

There is not much documentation, especially how these recursive lock 
warnings should be silenced.


regards
Antti
-- 
http://palosaari.fi/
