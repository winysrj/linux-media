Return-path: <mchehab@pedra>
Received: from www.open-std.org ([83.133.64.141]:55844 "EHLO www2.open-std.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753127Ab1ARBtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 20:49:18 -0500
Date: Tue, 18 Jan 2011 02:49:15 +0100
From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>,
	linux-media@vger.kernel.org
Subject: Re: How to help with RTL2832U based TV?
Message-ID: <20110118014915.GA9540@www2.open-std.org>
References: <20110116105535.GA17461@www2.open-std.org> <1295312704.3156.3.camel@maxim-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295312704.3156.3.camel@maxim-laptop>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 18, 2011 at 03:05:04AM +0200, Maxim Levitsky wrote:
> On Sun, 2011-01-16 at 11:55 +0100, Keld Jørn Simonsen wrote:
> > Antti Palosaari wrote Thu, 03 Dec 2009 13:48:01 -0800
> > 
> > > On 12/03/2009 10:09 PM, Peter Rasmussen wrote:
> > > 
> > >     as mentioned in the welcome email of this list, but it isn't
> > > apparent to
> > >     me what the status in Linux of using a device based on this chip is?
> > > 
> > > I have got today device having this chip (thanks to verkkokauppa.com for
> > > sponsoring) and I am going to implement the driver. I am in hope I can
> > > share some code from the old RTL2831U chip driver. I haven't looked
> > > driver code yet nor taken any sniffs. I will do that during next week.
> > 
> > OK, what is the status of this now?
> > It seems from the status page that it is not finished.
> > 
> > > Anyhow, there is Realtek released driver spreading over the net for that
> > > chip, you can use it.
> > 
> > I tried to find this but without luck.
> > Do you know where it can be found?
> > 
> > Anyway, I got the dongle to work via the following receipt:
> > http://www.linuxin.dk/node/15583 (in Danish, but I think Google can
> > translate it).
> > 
> > I would appreciate that this be in the kernel tree proper
> 
> I am doing a driver rewrite.
> Don't know when I finish it though.

Sounds good!

Why is the driver mentioned in http://www.linuxin.dk/node/15583 no good?

> Could you tell me what tuner you have, and does your card also support
> DVB-C?

It is called Zolid, and has usb id 1d19:1102

I tried it in a DVB-C environment, and it worked fine.

> (some Realtek cards also support Chinese DTMB, but even if yours does,
> you probably won't be able to test it (unless you live there).

I live in Denmark. Occasionally I travel abroad, and I actually should
have been in China 2 months ago. Next stop: USA.

best regards
keld
