Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx5.orcon.net.nz ([219.88.242.55] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mcree@orcon.net.nz>) id 1K80TD-0007SL-9d
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 00:13:08 +0200
Received: from Debian-exim by mx5.orcon.net.nz with local (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>) id 1K80Sv-0003v3-DM
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 10:12:49 +1200
Received: from cree.phys.waikato.ac.nz ([130.217.188.11])
	by mx5.orcon.net.nz with esmtpa (Exim 4.67)
	(envelope-from <mcree@orcon.net.nz>) id 1K80Sv-0003uc-2o
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 10:12:49 +1200
Message-Id: <F4ED6217-5ABE-4136-BD5A-A56779902F12@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: linux-dvb@linuxtv.org
In-Reply-To: <484BA795.8010701@orcon.net.nz>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Mon, 16 Jun 2008 10:12:47 +1200
References: <484BA795.8010701@orcon.net.nz>
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

> I am getting 'I2C read failed' and 'ep 0 read error' errors with a
> Hauppauge Nova T 500 PCI card.

> This is running on a Compaq Alpha XP1000 workstation. It has a 667Mhz
> Alpha EV67 cpu.  Running Debian Lenny.

I should've also state that the Hauppauge card was in one of the  
secondary PCI slots, behind a bridge.  Shifting the card to one of the  
primary PCI slots solved the problems reported above.  I now can tune  
and stream from the card.

There, not that "scary" as the only responder suggested.

A new problem arose - mplayer would report that the video stream is  
MPEG2 and proceed to multitudes of decoding errors.   Somewhere a lie  
had occurred; it is MPEG4 with H.264 encoding on the terrestrial  
transmission in NZ.    Updating dvb-utils to latest in mercurial has  
fixed that problem and I now can get video and audio streams from the  
hauppauge card.

Unfortunately mplayer on a single Alpha 667MHz EV67 isn't fast enough  
to play the video streams, not even the 576i streams.  Bugger.

Michael.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
