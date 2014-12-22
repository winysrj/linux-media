Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57423 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbaLVNxN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:53:13 -0500
Message-ID: <54982246.20300@iki.fi>
Date: Mon, 22 Dec 2014 15:53:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
References: <1419114892-4550-1-git-send-email-crope@iki.fi> <20141222124411.GK17800@sirena.org.uk> <549814BB.3040808@iki.fi> <20141222133142.GM17800@sirena.org.uk>
In-Reply-To: <20141222133142.GM17800@sirena.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/22/2014 03:31 PM, Mark Brown wrote:
> On Mon, Dec 22, 2014 at 02:55:23PM +0200, Antti Palosaari wrote:
>> On 12/22/2014 02:44 PM, Mark Brown wrote:
>>> On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:
>
>>>> I2C client and I2C adapter are using regmap. As a solution, add
>>>> configuration option to pass custom lock class key for lockdep
>>>> validator.
>
>>> Why is this configurable, how would a device know if the system it is in
>>> needs a custom locking class and can safely use one?
>
>> If RegMap instance is bus master, eg. I2C adapter, then you should define
>> own custom key. If you don't define own key and there will be slave on that
>> bus which uses RegMap too, there will be recursive locking from a lockdep
>> point of view.
>
> That doesn't really explain to me why this is configurable, why should
> drivers have to worry about this?

Did you read the lockdep documentation I pointed previous mail?
from: Documentation/locking/lockdep-design.txt

There is not very detailed documentation available, but the section 
"Exception: Nested data dependencies leading to nested locking" explains 
something.

One possibility is to disable lockdep checking from that driver totally, 
then drivers do not need to care it about. But I don't think it is 
proper way. One solution is to use custom regmap locking available 
already, but Mauro nor me didn't like that hack:
[RFC HACK] rtl2832: implement own lock for RegMap
https://www.mail-archive.com/linux-media@vger.kernel.org/msg83323.html

> Please also write technical terms like regmap normally.

Lower-case letters?

regards
Antti

-- 
http://palosaari.fi/
