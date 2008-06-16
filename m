Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1K89cS-00064B-Oa
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 09:59:17 +0200
Received: from [10.11.11.138] (user-54400511.l5.c3.dsl.pol.co.uk [84.64.5.17])
	by mail.youplala.net (Postfix) with ESMTP id 353BCD88171
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 09:57:31 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <200806160932.27229.Nicola.Sabbi@poste.it>
References: <484BA795.8010701@orcon.net.nz>
	<F4ED6217-5ABE-4136-BD5A-A56779902F12@orcon.net.nz>
	<200806160932.27229.Nicola.Sabbi@poste.it>
Date: Mon, 16 Jun 2008 08:57:31 +0100
Message-Id: <1213603051.6841.28.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Problems (bug?) with Hauppauge Nova T 500
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

On 8/06/2008, at 9:34 PM, Michael Cree wrote:
> > > I am getting 'I2C read failed' and 'ep 0 read error' errors with
> > > a Hauppauge Nova T 500 PCI card.
> > >
> > > This is running on a Compaq Alpha XP1000 workstation. It has a
> > > 667Mhz Alpha EV67 cpu.  Running Debian Lenny.
> >
> > I should've also state that the Hauppauge card was in one of the
> > secondary PCI slots, behind a bridge.  Shifting the card to one of
> > the primary PCI slots solved the problems reported above.  I now
> > can tune and stream from the card.
> >
> > There, not that "scary" as the only responder suggested.

Well, good for you. Really.

The thing is that not many people have Alphas at home to help you and
test things out or compare experience.

That's what I meant by "scary"

Nico



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
