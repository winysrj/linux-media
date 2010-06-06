Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:35211 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933931Ab0FFCAO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jun 2010 22:00:14 -0400
Date: Sun, 6 Jun 2010 04:00:11 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: hvr4000 doesnt work w/ dvb-s2 nor DVB-T
Message-ID: <20100606040011.30c94d18@romy.gusto>
In-Reply-To: <AANLkTin-QLz0lM1bpGer_a71YHbnoN-dTQrPRjwtCfo3@mail.gmail.com>
References: <20100606010752.4a138f82@romy.gusto>
	<AANLkTin-QLz0lM1bpGer_a71YHbnoN-dTQrPRjwtCfo3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


thanks for your response. really!

its a pretty good sign, but as long as i have no stream running its
worth nothing.

and Yes, I used szap-s2 and was careful about what it answerd. so I am
sure that it was all right.


On Sat, 5 Jun 2010 21:33:24 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> On Sat, Jun 5, 2010 at 7:07 PM, Lars Schotte
> <lars.schotte@schotteweb.de> wrote:
> > so basically my question is, what makes you think, that HVR4000 is
> > able to play DVB-S2 streams when it doesn't?!
> 
> Well, the fact that the developer who added the Linux S2-API support
> did it for that card would be a pretty good indicator that it should
> work.
> 
> > so I have tried this out, run w_scan which printed me also all the
> > DVB-S2 channels out and provided me a tuning list (channels.conf)
> > and then I tried to tune in w/ "szap-s2 -S 1 -c
> > ~/.mplayer/channels.conf ZDFHD"
> 
> If w_scan gave you a channel list, that is a pretty good sign that the
> card is working.  You probably are just feeding the zap tool the wrong
> arguments (something which someone who has more familiarity than I do
> with dvb-s2 would probably be able to help you with.
> 
> Devin
> 
