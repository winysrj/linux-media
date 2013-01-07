Return-path: <linux-media-owner@vger.kernel.org>
Received: from tropek.jajcus.net ([84.205.176.49]:40072 "EHLO
	tropek.jajcus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3AGLLE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 06:11:04 -0500
Received: from jajo.eggsoft.pl (jajo.nigdzie [10.252.0.4])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tropek.jajcus.net (Postfix) with ESMTPS id 963025002
	for <linux-media@vger.kernel.org>; Mon,  7 Jan 2013 12:11:02 +0100 (CET)
Date: Mon, 7 Jan 2013 12:10:34 +0100
From: Jacek Konieczny <jajcus@jajcus.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [BUG] Problem with LV5TDLX DVB-T USB and the 3.7.1 kernel
Message-ID: <20130107121034.7da1a00a@jajo.eggsoft>
In-Reply-To: <50E83874.5060700@iki.fi>
References: <20130105150539.32186362@lolek.nigdzie>
	<50E83874.5060700@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 05 Jan 2013 16:28:04 +0200
Antti Palosaari <crope@iki.fi> wrote:

> Take USB sniffs, make scripts to generate e4000 register write code
> from the sniffs, copy & paste that code from the sniffs until it
> starts working. After it starts working it is quite easy to comment
> out / tweak with driver in order to find problem. With the experience
> and luck it is only few hours to fix, but without a experience you
> will likely need to learn a lot of stuff first.

I have not experience with the linux media drivers coding, so it probably 
would take me much more than a few hours or require lots of luck.

> Of course those sniffs needed to take from working case, which just 
> makes successful tuning to 746000000 or 698000000.
> 
> Also you could use to attenuate or amplifier signal to see if it
> helps.

Already tried that, with various levels of attenuation and amplification, 
the results vary from snr always 0000 to, at best, approximately every 
second line of tzap output shows non-zero snr.

> I don't have much time / money, no interest, no equipment (DVB-T 
> modulator) to start optimizing it currently.

I see. Can sending the device to you help in any way? In case I cannot make
it work, I can, as well, send it to someone who could do good use of it.
But first, I will try to fix it myself somehow.

I'll try my luck with code. Maybe comparing the drivers with those from
Realtek, which used to work for me, will help. Thanks for all the hints.

Greets,
	Jacek
