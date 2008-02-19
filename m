Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRYC9-0003Ov-OJ
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 20:32:01 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id B54F9D88113
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 20:31:08 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1203448799.28796.3.camel@youkaida>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
Date: Tue, 19 Feb 2008 19:30:57 +0000
Message-Id: <1203449457.28796.7.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat
	with	dib0700	ir	receiver
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


On Tue, 2008-02-19 at 19:19 +0000, Nicolas Will wrote:
> 
> On Tue, 2008-02-19 at 17:21 +0000, Nicolas Will wrote:
> > 
> > On Tue, 2008-02-19 at 16:17 +0100, Filippo Argiolas wrote:
> > > I've also implemented repeated key
> > > feature (with repeat delay to avoid unwanted double hits) for rc-5
> > and
> > > nec protocols. It also contains some keymap for the remotes I've
> > used
> > > for testing (a philipps compatible rc5 remote and a teac nec
> > remote).
> > > They are far from being complete since I've used them just for
> > > testing.
> > 
> > I'm quite interested in testing this patch, key repeats have been a
> > nagging thing in the back of my mind.
> 
> 
> Now this is rich!
> 
> I love it!
> 
> Key repeat works!
> 
> And the log flooding has stopped without the manual patch that was
> needed previously.
> 
> I hope you live in Aberdeen, Scotland, because I want to buy you a few
> beers right here and now! (though your name suggest a very different
> origin)
> 
> The patch applies cleanly on a fresh tree from 20mn ago. No warning
> while compiling. No weird stuff in the messages.

dib0700 users, please test as well and report.

v4l-dvb people, please review.

This, or an equivalent, needs to get inside the mainline.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
