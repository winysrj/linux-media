Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRY4w-0002CK-6S
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 20:24:34 +0100
Received: from [11.11.11.138] (unknown [84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id 49E56D88113
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 20:23:38 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1203441662.9150.29.camel@acropora>
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
Date: Tue, 19 Feb 2008 19:19:59 +0000
Message-Id: <1203448799.28796.3.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with
	dib0700	ir	receiver
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


On Tue, 2008-02-19 at 17:21 +0000, Nicolas Will wrote:
> 
> On Tue, 2008-02-19 at 16:17 +0100, Filippo Argiolas wrote:
> > I've also implemented repeated key
> > feature (with repeat delay to avoid unwanted double hits) for rc-5
> and
> > nec protocols. It also contains some keymap for the remotes I've
> used
> > for testing (a philipps compatible rc5 remote and a teac nec
> remote).
> > They are far from being complete since I've used them just for
> > testing.
> 
> I'm quite interested in testing this patch, key repeats have been a
> nagging thing in the back of my mind.


Now this is rich!

I love it!

Key repeat works!

And the log flooding has stopped without the manual patch that was
needed previously.

I hope you live in Aberdeen, Scotland, because I want to buy you a few
beers right here and now! (though your name suggest a very different
origin)

The patch applies cleanly on a fresh tree from 20mn ago. No warning
while compiling. No weird stuff in the messages.

> 
> I'll be testing this patch, and I'll document it in the wiki here:
> 
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500

Done.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
