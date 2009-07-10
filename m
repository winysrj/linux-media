Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33779 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbZGJXLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 19:11:10 -0400
Message-ID: <4A57CA85.8090407@iki.fi>
Date: Sat, 11 Jul 2009 02:11:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jelle de Jong <jelledejong@powercraft.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>	 <4A4E2B45.8080607@powercraft.nl>	 <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>	 <4A572F7E.6010701@iki.fi> <829197380907100816o4a3daa22k78a424da5bebed1e@mail.gmail.com> <4A57AEC9.9040602@iki.fi>
In-Reply-To: <4A57AEC9.9040602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hei Devin and Jelle,

On 07/11/2009 12:12 AM, Antti Palosaari wrote:
>> I'm not the maintainer for this demod, so I'm not the best person to
>> make such a fix. I spent four hours and debugged the issue as a favor
>> to Jelle de Jong since he loaned me some hardware a couple of months
>> ago. I guess I can make the fix, but it's just going to take away
>> from time better spent on things I am more qualified to work on.
>>
>> Devin
>
> I will fix that just right now. I think I will change demodulator from
> "return error invalid value" to "force detect transmission parameters
> automatically" in case of broken parameters given.

It is fixed now as I see best way.

For reason or other my MPlayer didn't give garbage and I never seen any 
of those debugs added. I added just similar channels.conf line as Jelle 
but changed freq and PIDs used here. Maybe garbage fields are filled "0" 
which corresponds AUTO.
Anyhow, here it is. Could you test?
http://linuxtv.org/hg/~anttip/af9013/

regards
Antti
-- 
http://palosaari.fi/
