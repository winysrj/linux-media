Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:48881 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbZGJPkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 11:40:46 -0400
Message-ID: <4A5760FA.6080203@powercraft.nl>
Date: Fri, 10 Jul 2009 17:40:42 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>	 <4A4E2B45.8080607@powercraft.nl>	 <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>	 <4A572F7E.6010701@iki.fi> <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
In-Reply-To: <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Jul 10, 2009 at 8:09 AM, Antti Palosaari<crope@iki.fi> wrote:
>> af9013 is correct in my mind. af9013 will return -EINVAL (error invalid
>> value) in case of first garbage value met (maybe better to switch auto mode
>> when garbage value meet and print debug log?).
>>
>> Of course there should be at least debug printing to inform that... but fix
>> you suggest is better for compatibility. You can do that, it is ok for me.
> 
> From a purist standpoint, I agree that the application at fault, and
> if it were some no-name application I would just say "fix the broken
> application".  Except it's not a no-name application - it's mplayer.
> 
> Are you familiar with Postel's Law?
> 
> http://en.wikipedia.org/wiki/Postel%27s_Law
> 
> Saying "this demod is not going to work properly with all versions of
> one of the most popular applications", especially when other demods
> handle the condition gracefully, is the sort of thing that causes real
> problems for the Linux community.
> 
> I'm not the maintainer for this demod, so I'm not the best person to
> make such a fix.  I spent four hours and debugged the issue as a favor
> to Jelle de Jong since he loaned me some hardware a couple of months
> ago.  I guess I can make the fix, but it's just going to take away
> from time better spent on things I am more qualified to work on.
> 
> Devin
> 

I agree with the arguments, I believe Antti did also and said to me he
will try to work something out next week.

Antti if you can fix this issue and help in the future to make some
signal strength API for application, like w_scan, you can keep the
Realtek based dvb-t device I sent to you as a gift, some credits for me
in patches would also be nice since it takes up a lot of time and money
on my side to :D

I tolled the mplayer people maybe 5 month's ago about this issue. They
were quite simple I had 4 devices that worked with mplayer one did not
the problem was with the device, they did not want to listen to the idea
something was wrong with there mplayer. If somebody want to convince
them with this new prove/research please do so, I let it rest.

Many thanks to Devin and Antti,

Best regards,

Jelle
