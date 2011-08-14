Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44923 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1HNMLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 08:11:52 -0400
Message-ID: <4E47BB82.8040801@iki.fi>
Date: Sun, 14 Aug 2011 15:11:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Chris Rankin <rankincj@yahoo.com>, linux-media@vger.kernel.org
Subject: Re: PCTV 290e nanostick and remote control support
References: <4E46FB3C.7060402@iki.fi> <1313286189.94904.YahooMailClassic@web121720.mail.ne1.yahoo.com> <CAGoCfiw0p7jwac94eYM9apUN4Qd8mduteq_xH8ePoyxvO7SNGA@mail.gmail.com>
In-Reply-To: <CAGoCfiw0p7jwac94eYM9apUN4Qd8mduteq_xH8ePoyxvO7SNGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2011 04:48 AM, Devin Heitmueller wrote:
> On Sat, Aug 13, 2011 at 9:43 PM, Chris Rankin <rankincj@yahoo.com> wrote:
>> The rc-pinnacle-pctv-hd keymap is missing the definition of the OK key:
>>
>> --- linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c.orig       2011-08-14 02:42:01.000000000 +0100
>> +++ linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c    2011-08-14 02:12:45.000000000 +0100
>> @@ -20,6 +20,7 @@
>>        { 0x0701, KEY_MENU }, /* Pinnacle logo */
>>        { 0x0739, KEY_POWER },
>>        { 0x0703, KEY_VOLUMEUP },
>> +       { 0x0705, KEY_OK },
>>        { 0x0709, KEY_VOLUMEDOWN },
>>        { 0x0706, KEY_CHANNELUP },
>>        { 0x070c, KEY_CHANNELDOWN },
>>
>> Cheers,
>> Chris
> 
> Wow, how the hell did I miss that?  I did numerous remotes for em28xx
> based devices that use that RC profile, and never noticed that issue.
> 
> Will have to check the merge logs.  Maybe the key got lost when they
> refactored the IR support.

It seems to be very old bug, year 2007, not coming from merge errors! It
could be even possible there have not been such button originally. Very
weird situation none have found it earlier. For example I just pressed
few buttons to see number are coming to console => OK it works (didn't
looked all buttons sends events).

That's commit which adds those keytables:
commit 54d75ebaa02809f24a16624e32706af3bf97588e

regards
Antti

-- 
http://palosaari.fi/
