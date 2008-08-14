Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KTk3t-0005HY-Iv
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 23:08:50 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id E5DADD880A4
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 23:07:38 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <412bdbff0808141311p264d327ayb9e736f290326371@mail.gmail.com>
References: <412bdbff0808141157t241748b4n5d82b15fcbc18d4a@mail.gmail.com>
	<1218743866.8654.2.camel@youkaida>
	<412bdbff0808141311p264d327ayb9e736f290326371@mail.gmail.com>
Date: Thu, 14 Aug 2008 22:07:40 +0100
Message-Id: <1218748060.8654.7.camel@youkaida>
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

On Thu, 2008-08-14 at 16:11 -0400, Devin Heitmueller wrote:
> On Thu, Aug 14, 2008 at 3:57 PM, Nicolas Will <nico@youplala.net>
> wrote:
> > I, for one, am very interested in this.
> >
> > I cannot code or really understand the details, but could this
> explain
> > the more or less regular i2c read failures or even write failures
> > eventually leading to device lock-ups that we are still experiencing
> if
> > we are a bit too agressive?
> 
> Also, what device are you describing when you refer to your i2c
> problem?  That might help narrow down whether we are talking about an
> xc5000 issue or a dib0700 issue.


I was going to comment on this on your previous post.

My context include the Hauppauge Nova-T-500, MT2060 and DIB3000P. which
also use the dib0700 module.

I guess that this rules out xc50000.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
