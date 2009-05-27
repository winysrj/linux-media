Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from snt0-omc3-s11.snt0.hotmail.com ([65.55.90.150])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajmcharrett@hotmail.com>) id 1M9Hvt-0007Yv-Kg
	for linux-dvb@linuxtv.org; Wed, 27 May 2009 14:08:34 +0200
Message-ID: <SNT115-W3782B298CD70B006FFE2E3A6530@phx.gbl>
From: Adam Charrett <ajmcharrett@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 27 May 2009 13:07:58 +0100
In-Reply-To: <mailman.1.1243418401.15557.linux-dvb@linuxtv.org>
References: <mailman.1.1243418401.15557.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] EPG (Electronic Program Guide) Tools
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> Message: 1
> Date: Tue, 26 May 2009 13:51:11 -0400
> From: Chris Capon =

> Subject: [linux-dvb] EPG (Electronic Program Guide) Tools
> To: linux-dvb@linuxtv.org
> Message-ID: =

> Content-Type: text/plain; charset=3DISO-8859-1; format=3Dflowed
>
> Hi:
> I've installed an HVR-1600 card in a Debian system to receive ATSC
> digital broadcasts here in Canada. Everything works great.
>
> scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB> channels.conf
>
> finds a complete list of broadcasters.
>
> azap -c channels.conf -r "channel-name"
>
> tunes in the stations and displays signal strength info.
>
> cp /dev/dvb/adapter0/dvr0 xx.mpg
>
> captures the output stream which can be played by mplayer.
>
>
>
> What I'm missing is information about the Electronic Program Guide
> (EPG). There doesn't seem to be much info on linuxtv.org on how to read i=
t.
>
> Where does the EPG come from?
>
> Is it incorporated into the output stream through PID's some how or is
> it read from one of the other devices under adapter0?
>
> Are there simple command line tools to read it or do you have to write a
> custom program to interpret it somehow?
>
> Could someone please point me in the right direction to get started? If
> no tools exist, perhaps links to either api or lib docs/samples?
>
>
> Much appreciated.
> Chris.
>

I believe the only 2 tools that can extract ATSC EPG information are MythTV=
 and DVBStreamer (not DVB stream).
I haven't any experience with MythTV but I can say that DVBStreamer does ap=
pear to work with some US stations and is being used by several people to e=
xtract the EPG for use with Freevo.

Heres a link to a simple script to use with DVBSTreamer to update then extr=
act the EPG information for all known/found services:

http://apps.sourceforge.net/mediawiki/dvbstreamer/index.php?title=3DFAQ

Finally there was another tool, pchdtv, which the author removed from the w=
eb sometime ago but might be worth a google for.

Cheers

Adam

Disclose: I am the author of DVBStreamer.

_________________________________________________________________
View your Twitter and Flickr updates from one place =96 Learn more!
http://clk.atdmt.com/UKM/go/137984870/direct/01/
_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
