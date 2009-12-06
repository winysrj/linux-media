Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933721AbZLFLq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 06:46:56 -0500
Message-ID: <4B1B99A5.2080903@redhat.com>
Date: Sun, 06 Dec 2009 09:46:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: hermann pitton <hermann-pitton@arcor.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc> <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com> <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net>
In-Reply-To: <20091206065512.GA14651@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> Hi,
> 
> On Sun, Dec 06, 2009 at 04:36:33AM +0100, hermann pitton wrote:
>> Hi,
>>
>> Am Freitag, den 04.12.2009, 19:28 -0500 schrieb Jon Smirl:
>>> On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
>>>> BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
>>>> codes. Anyone here has docs on the XMP protocol?
>>> Assuming a general purpose receiver (not one with fixed hardware
>>> decoding), is it important for Linux to receive IR signals from all
>>> possible remotes no matter how old or obscure? Or is it acceptable to
>>> tell the user to throw away their dedicated remote and buy a universal
>>> multi-function one?  Universal multi-function remotes are $12 in my
>>> grocery store - I don't even have to go to an electronics store.
>> finally we have some point here, IMHO, that is not acceptable and I told
>> you previously not to bet on such. Start some poll and win it, and I'll
>> shut up :)
>>
> 
> Who would participate in the poll though?
> 
>> To be frank, you are quite mad at this point, or deliver working other
>> remotes to __all__ for free.
>>
> 
> I do not believe you are being realistic. Sometimes we just need to say
> that the device is a POS and is just not worth it. Remember, there is
> still "lirc hole" for the hard core people still using solder to produce
> something out of the spare electronic components that may be made to
> work (never mind that it causes the CPU constantly poll the device, not
> letting it sleep and wasting electricity as a result - just hypotetical
> example here).
> 
> We still need to do cost-benefit analysis and decide whether supporting
> the exotic setups _in kernel_ makes sense if it encumbers implementation
> and causes issues to the other 95% people.

Fully agreed. The costs (our time) to add and keep supporting an in-kernel
driver for an IR that just one person is still using is higher than 
asking the user to get a new IR. This time would be better spent adding a new
driver for other devices.

Cheers,
Mauro.


