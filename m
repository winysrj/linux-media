Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43783 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZGJVMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 17:12:48 -0400
Message-ID: <4A57AEC9.9040602@iki.fi>
Date: Sat, 11 Jul 2009 00:12:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>	 <4A4E2B45.8080607@powercraft.nl>	 <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>	 <4A572F7E.6010701@iki.fi> <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
In-Reply-To: <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2009 06:16 PM, Devin Heitmueller wrote:
> On Fri, Jul 10, 2009 at 8:09 AM, Antti Palosaari<crope@iki.fi>  wrote:
>> af9013 is correct in my mind. af9013 will return -EINVAL (error invalid
>> value) in case of first garbage value met (maybe better to switch auto mode
>> when garbage value meet and print debug log?).
>>
>> Of course there should be at least debug printing to inform that... but fix
>> you suggest is better for compatibility. You can do that, it is ok for me.
>
>> From a purist standpoint, I agree that the application at fault, and
> if it were some no-name application I would just say "fix the broken
> application".  Except it's not a no-name application - it's mplayer.
>
> Are you familiar with Postel's Law?

No :)

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

I will fix that just right now. I think I will change demodulator from 
"return error invalid value" to "force detect transmission parameters 
automatically" in case of broken parameters given.

thanks,
Antti
-- 
http://palosaari.fi/
