Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JM3wz-00020f-Tj
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 17:13:41 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id 68C34D88110
	for <linux-dvb@linuxtv.org>; Mon,  4 Feb 2008 17:12:18 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47A735A0.2040801@rogers.com>
References: <1201877013.6796.5.camel@acropora>
	<1201955576.935.23.camel@youkaida>  <47A735A0.2040801@rogers.com>
Date: Mon, 04 Feb 2008 16:11:57 +0000
Message-Id: <1202141517.6826.47.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] script to automatically get signal strength and BER
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


On Mon, 2008-02-04 at 10:56 -0500, CityK wrote:
> Nicolas Will wrote:
> > On Fri, 2008-02-01 at 14:43 +0000, Nicolas Will wrote:
> >   
> >> Hi all,
> >>
> >> Before I try to make one, did anyone write a script that goes
> through
> >> a
> >> channels.conf file and outputs human readable signal strength, BER
> and
> >> such for all channels?
> >>     
> >
> > I received 2 scripts by pers. email.
> >
> > Thanks guys !
> >
> > I have created a wiki page containing the scripts"
> >
> > http://linuxtv.org/wiki/index.php/Testing_reception_quality
> >
> > Hope this helps.
> >
> > Nico
> Also see femon (part of the dvb-apps)
> "femon -h" for help
> "femon -H" for what you want

Ah.

My femon (dvb-utils on my Gutsy Mythbuntu) does not have the -H option.
It's probably too old.

I shall look at the hg sources.

The first script created a nice baseline and comparaison tool for the
before and after masthead amp installation.

A 26-dB masthead amp + associated in-line power supply gave me 20-25%
better signal strength, and most importantly brough all the BER to zero.

http://www.youplala.net/~will/htpc/signaltest/

I'm happy :o)

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
