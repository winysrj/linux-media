Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:56162 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0FFT2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 15:28:19 -0400
Date: Sun, 6 Jun 2010 21:28:14 +0200
From: Lars Schotte <lars.schotte@schotteweb.de>
To: Niels Wagenaar <n.wagenaar@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] hvr4000 doesnt work w/ dvb-s2 nor DVB-T
Message-ID: <20100606212814.1e55206c@romy.gusto>
In-Reply-To: <AANLkTin1jaMbG0ULhQRZi3QWkd2oVXazJ4BTGh5rMYdM@mail.gmail.com>
References: <20100606010311.6d98ef7b@romy.gusto>
	<20100606084301.GA3070@gmail.com>
	<20100606133946.76c3a6e0@romy.gusto>
	<20100606124925.GB3070@gmail.com>
	<20100606145154.60de422e@romy.gusto>
	<20100606125636.GC3070@gmail.com>
	<20100606150554.55be1852@romy.gusto>
	<AANLkTin1jaMbG0ULhQRZi3QWkd2oVXazJ4BTGh5rMYdM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK,
i am using w_scan, it scanned and found DVB-S2 channels but szap-s2
doesnt tune in and there is no data, exactly like i said, so either you
are lying and you have none of this things running or you were paid by
huappauge to say this.

i am using fedora 13 and HVR4000 and only DVB-S works. mplayer has the
same problem and again - I have no diseq switch installed.

On Sun, 6 Jun 2010 15:28:07 +0200
Niels Wagenaar <n.wagenaar@xs4all.nl> wrote:

> No offence. But all these problems are complete FUD. I've been using a
> HVR-4000 and a NOVA-HD-S2 since VDR 1.7.0 (which required multiproto)
> and since I made the S2API-patch for VDR 1.7.0 (which I released in
> October 2009). I've never experienced these issues in the past 1,5
> years.
> 
> DiSEqC handling is no problem at all. I've set it up with DiSEqC 1.0
> and 1.2 in combination with VDR. And I've never seen any lock problems
> with DVB-S2 channels using QPSK or 8PSK modulation on Hotbird 13.0e,
> Astra 19.2e, Astra 23.5e and Astra 28.2e.
> 
> If you need channellists (why even use something like szap, scan or
> wscan if you can download it yourself), just go to Linowsat [1] or VDR
> Settings [2]. And here's an example for a diseqc.conf which I've used
> since the beginning:
> 
> # port 1 option a position a -> Astra 19.2e
> # port 2 option a position b -> Hotbird 13.0e
> # port 3 option b position a -> Astra 23.5e
> # port 4 option b position b -> Astra 28.2e / Eurobird 28.5e
> #
> # port 1
> S19.2E  11700 V  9750   t v W15 [E0 10 38 F0] W100 [E0 10 38 F0] W100
> [E0 11 00] W100 A W15 t
> S19.2E  99999 V 10600   t v W15 [E0 10 38 F1] W100 [E0 10 38 F1] W100
> [E0 11 00] W100 A W15 T
> S19.2E  11700 H  9750   t V W15 [E0 10 38 F2] W100 [E0 10 38 F2] W100
> [E0 11 00] W100 A W15 t
> S19.2E  99999 H 10600   t V W15 [E0 10 38 F3] W100 [E0 10 38 F3] W100
> [E0 11 00] W100 A W15 T
> # port 2
> S13.0E  11700 V  9750   t v W15 [E0 10 38 F4] W100 [E0 10 38 F4] W100
> [E0 11 00] W100 B W15 t
> S13.0E  99999 V 10600   t v W15 [E0 10 38 F5] W100 [E0 10 38 F5] W100
> [E0 11 00] W100 B W15 T
> S13.0E  11700 H  9750   t V W15 [E0 10 38 F6] W100 [E0 10 38 F6] W100
> [E0 11 00] W100 B W15 t
> S13.0E  99999 H 10600   t V W15 [E0 10 38 F7] W100 [E0 10 38 F7] W100
> [E0 11 00] W100 B W15 T
> # port 3
> S23.5E  11700 V  9750   t v W15 [E0 10 38 F8] W100 [E0 10 38 F8] W100
> [E0 11 00] W100 A W15 t
> S23.5E  99999 V 10600   t v W15 [E0 10 38 F9] W100 [E0 10 38 F9] W100
> [E0 11 00] W100 A W15 T
> S23.5E  11700 H  9750   t V W15 [E0 10 38 FA] W100 [E0 10 38 FA] W100
> [E0 11 00] W100 A W15 t
> S23.5E  99999 H 10600   t V W15 [E0 10 38 FB] W100 [E0 10 38 FB] W100
> [E0 11 00] W100 A W15 T
> # port 4
> S28.2E  11700 V  9750   t v W15 [E0 10 38 FC] W100 [E0 10 38 FC] W100
> [E0 11 00] W100 B W15 t
> S28.2E  99999 V 10600   t v W15 [E0 10 38 FD] W100 [E0 10 38 FD] W100
> [E0 11 00] W100 B W15 T
> S28.2E  11700 H  9750   t V W15 [E0 10 38 FE] W100 [E0 10 38 FE] W100
> [E0 11 00] W100 B W15 t
> S28.2E  99999 H 10600   t V W15 [E0 10 38 FF] W100 [E0 10 38 FF] W100
> [E0 11 00] W100 B W15 T
> S28.5E  11700 V  9750   t v W15 [E0 10 38 FC] W100 [E0 10 38 FC] W100
> [E0 11 00] W100 B W15 t
> S28.5E  99999 V 10600   t v W15 [E0 10 38 FD] W100 [E0 10 38 FD] W100
> [E0 11 00] W100 B W15 T
> S28.5E  11700 H  9750   t V W15 [E0 10 38 FE] W100 [E0 10 38 FE] W100
> [E0 11 00] W100 B W15 t
> S28.5E  99999 H 10600   t V W15 [E0 10 38 FF] W100 [E0 10 38 FF] W100
> [E0 11 00] W100 B W15 T
> 
> 
> 2010/6/6 Lars Schotte <lars.schotte@schotteweb.de>:
> > I dont have a Diseq swich installed at the moment.
> >
> > On Sun, 6 Jun 2010 14:56:36 +0200
> > Gregoire Favre <gregoire.favre@gmail.com> wrote:
> >
> >> On Sun, Jun 06, 2010 at 02:51:54PM +0200, Lars Schotte wrote:
> >>
> >> > ah. so i see you had some problems as well. thats better,
> >> > because as long as i am not the only one maybe some time it will
> >> > work.
> >>
> >> ??? It was the developpement process and Disecq wasn't working
> >> right in the driver, which is now fixed, so the time I spent for
> >> this card should be good for you.
> 
> 
