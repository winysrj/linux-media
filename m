Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KTiyI-0000S6-9n
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 21:58:59 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id DE234D880A4
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 21:57:47 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
References: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
Date: Thu, 14 Aug 2008 20:57:46 +0100
Message-Id: <1218743866.8654.2.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Possible bug in dib0700_core.c i2c transfer	function
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 2008-08-14 at 14:57 -0400, Devin Heitmueller wrote:
> Sent this to Patrick Boettcher last week and didn't hear anything
> back.  Figured it might be worth sending to the list to see if anyone
> else had any ideas:
> 
> ---
> 
> I have been doing some work on the Pinnacle PCTV HD Pro USB Stick,
> which uses the dib0700/s5h1411/xc5000 combination.  I'm making good
> progress but I think I might have run into a bug.
> 
> The dib0700_i2c_xfer() function appears to have a problem where it
> converts i2c read calls into i2c write calls in certain cases.  In
> particular, if you send a single i2c read message, the function always
> treats it as a write request.

I, for one, am very interested in this.

I cannot code or really understand the details, but could this explain
the more or less regular i2c read failures or even write failures
eventually leading to device lock-ups that we are still experiencing if
we are a bit too agressive?

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
