Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46923 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaLVMz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 07:55:28 -0500
Message-ID: <549814BB.3040808@iki.fi>
Date: Mon, 22 Dec 2014 14:55:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
References: <1419114892-4550-1-git-send-email-crope@iki.fi> <20141222124411.GK17800@sirena.org.uk>
In-Reply-To: <20141222124411.GK17800@sirena.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/22/2014 02:44 PM, Mark Brown wrote:
> On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:
>> Lockdep validator complains recursive locking and deadlock when two
>> different regmap instances are called in a nested order, as regmap
>> groups locks by default. That happens easily for example when both
>
> I don't know what "regmap groups locks by default" means.

It means, that lockdep does not track individual lock instances, but 
group of lock instances, which are called classes. In that case, there 
is 2 regmap mutexes, one in a I2C client driver and another in I2C 
adapter driver. Even those are different locks (mutexes) in a different 
driver, lockdep refers those as a single and same lock and due to that 
it thinks there is recursive lock => deadlock.

from: Documentation/locking/lockdep-design.txt

Lock-class
----------

The basic object the validator operates upon is a 'class' of locks.

A class of locks is a group of locks that are logically the same with
respect to locking rules, even if the locks may have multiple (possibly
tens of thousands of) instantiations. For example a lock in the inode
struct is one class, while each inode has its own instantiation of that
lock class.

The validator tracks the 'state' of lock-classes, and it tracks
dependencies between different lock-classes. The validator maintains a
rolling proof that the state and the dependencies are correct.

Unlike an lock instantiation, the lock-class itself never goes away: when
a lock-class is used for the first time after bootup it gets registered,
and all subsequent uses of that lock-class will be attached to this
lock-class.


>> I2C client and I2C adapter are using regmap. As a solution, add
>> configuration option to pass custom lock class key for lockdep
>> validator.
>
> Why is this configurable, how would a device know if the system it is in
> needs a custom locking class and can safely use one?

If RegMap instance is bus master, eg. I2C adapter, then you should 
define own custom key. If you don't define own key and there will be 
slave on that bus which uses RegMap too, there will be recursive locking 
from a lockdep point of view.


regards
Antti

-- 
http://palosaari.fi/
