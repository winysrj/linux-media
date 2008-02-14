Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JPcDF-00041N-52
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 12:25:09 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id A43D3D88112
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 12:23:33 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <8ceb98f20802140139j307e02c8t473f12496d37cdcb@mail.gmail.com>
References: <1202892942.22746.37.camel@tux>
	<8ceb98f20802140120s4fdc9912wc1f30baa4c8d4da4@mail.gmail.com>
	<8ceb98f20802140139j307e02c8t473f12496d37cdcb@mail.gmail.com>
Date: Thu, 14 Feb 2008 11:23:47 +0000
Message-Id: <1202988227.6596.13.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] wintv nova-t stick, dib0700 and remote	controllers..
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On Thu, 2008-02-14 at 10:39 +0100, Filippo Argiolas wrote:
> I'm asking this because calling dib0700_rc_setup after each keypress
> poll resets the ir data into the  device to  0 0 0 0. What I'd like to
> know since I know almost nothing about dvb devices if is this going to
> someway damage my device if called each 150ms (period of the poll).
> If not I'll write a patch to support some of my remotes as well
> repeated keys events as soon I'll have some spare time.
> Does any of you know a different method to erase last received data
> from the device?
> 
> 
> 
> 2008/2/14, Filippo Argiolas <filippo.argiolas@gmail.com>:
> > No answer?
> >  Please could someone tell me if is it dangerous to call
> >  dib0700_rc_setup (from dib0700core.c) every 100ms to reset remote
> >  control data? Do you know any other method to reset data about last
> >  key received from the ir sensor?
> >  Thanks

Filippo,

>From a user point of view I can tell you that this topic interests me
and that the tread is flagged in my email client.

As for the technical side, I'm a clueless human being about this and
can't help.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
