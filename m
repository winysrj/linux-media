Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37467 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2GCXEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jul 2012 19:04:42 -0400
Message-ID: <4FF37A83.2030707@iki.fi>
Date: Wed, 04 Jul 2012 02:04:35 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF1CD63.10003@nexusuk.org> <oikac9-mbk.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <oikac9-mbk.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2012 10:46 AM, Marx wrote:
> On 02.07.2012 18:33, Steve Hill wrote:
>> Can anyone give me any pointers that might help? I've searched and
>> searched and all I can see if people saying that it won't work since the
>> DVB-S2 code was integrated into the kernel tree, but I've not seen
>> anyone try to figure out _why_ it won't work.
>
> I'm on the same boat.
> I have 3 DVB-S2 cards, one of them is pctv452e, and none of them works
> reliable. Yes, it's very frustrating that card which claims linux
> support has this support broken. The problem is that community which
> uses DVB cards is much smaller then those using other equipment. So
> there are no test of every device in each kernel release.
> I'm reading this list for some time and often see patches which refactor
> some drivers, but the only check is compilation check.
> "totally rewritten DVB-USB-framework" will not help to have more drivers
> too. Makers of dvb cards often don't provide linux driver, or provide
> only once in form of patches. You will not apply such patch into new DVB
> stack. Makers must constantly refactor their drivers to suit new
> kernels, and there are only a few which do this. I don't know why they
> simply don't join this list and push drivers into kernel and then
> provide support.
> I don't know what's future of DVB stack, but I see that changes in DVB
> stack causes meany problems with drivers. Often driver is written once
> and later unsupported - changes make it non-functional and there is
> nobody who can fix it. Exactly like with pctv452e driver.

Your claims about my DVB-USB-framework work is quite bullshit. I am not 
going to convert all drivers to the new framework just doing compile 
tests. I am heavily aware it is too risky thus I implemented it as a 
alternative, converting drivers one by one when you have hardware in 
hands to test. If such big changes were made to the existing code surely 
there is breakages.

And it fixes some existing DVB-USB bugs, actually all I was aware. Also 
it removes all the hacks, and also bugs coming those hacks, from many 
drivers. Most notable complex AF9015 and AF9035. See AF9015 before 
change and after change - code size is reduced something like 25% and 
binary size too.

> Marx
>
> Ps. Steve, could you please give me full version of kernel which works
> with pctv452e?

As the new DVB-USB fixes many bugs I ask you to test it. I converted 
pctv452e driver for you:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e

Only PCTV device supported currently, not TechnoTrend at that time.


regards
Antti

-- 
http://palosaari.fi/


