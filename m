Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1K89CM-0003qk-QH
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 09:32:31 +0200
Received: from [192.168.0.188] (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 48559F3F000014CB for linux-dvb@linuxtv.org;
	Mon, 16 Jun 2008 09:31:50 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Mon, 16 Jun 2008 09:32:27 +0200
References: <484BA795.8010701@orcon.net.nz>
	<F4ED6217-5ABE-4136-BD5A-A56779902F12@orcon.net.nz>
In-Reply-To: <F4ED6217-5ABE-4136-BD5A-A56779902F12@orcon.net.nz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806160932.27229.Nicola.Sabbi@poste.it>
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

On Monday 16 June 2008 00:12:47 Michael Cree wrote:
> On 8/06/2008, at 9:34 PM, Michael Cree wrote:
> > I am getting 'I2C read failed' and 'ep 0 read error' errors with
> > a Hauppauge Nova T 500 PCI card.
> >
> > This is running on a Compaq Alpha XP1000 workstation. It has a
> > 667Mhz Alpha EV67 cpu.  Running Debian Lenny.
>
> I should've also state that the Hauppauge card was in one of the
> secondary PCI slots, behind a bridge.  Shifting the card to one of
> the primary PCI slots solved the problems reported above.  I now
> can tune and stream from the card.
>
> There, not that "scary" as the only responder suggested.
>
> A new problem arose - mplayer would report that the video stream is
> MPEG2 and proceed to multitudes of decoding errors.   Somewhere a
> lie had occurred; it is MPEG4 with H.264 encoding on the
> terrestrial transmission in NZ.    Updating dvb-utils to latest in
> mercurial has fixed that problem and I now can get video and audio
> streams from the hauppauge card.
>

add the pmt pid to the stream and mplayer will decode correctly 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
