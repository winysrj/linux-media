Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LCOOT-0004k4-VS
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 02:06:42 +0100
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>
References: <4728568367913277327@unknownmsgid>
	<412bdbff0812151428q798c8f48l79caba49e72306a@mail.gmail.com>
	<8829222570103551382@unknownmsgid>
	<412bdbff0812151512k72f70d70j88427b5761585d16@mail.gmail.com>
	<2944906433286851876@unknownmsgid>
	<412bdbff0812151527l43029409q2dbacce63ea60cc9@mail.gmail.com>
Date: Mon, 15 Dec 2008 20:04:48 -0500
Message-Id: <1229389488.3122.23.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Daniel Perzynski <Daniel.Perzynski@aster.pl>
Subject: Re: [linux-dvb] Avermedia A312 - patch for review
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

On Mon, 2008-12-15 at 18:27 -0500, Devin Heitmueller wrote:
> On Mon, Dec 15, 2008 at 6:23 PM, Daniel Perzynski
> <Daniel.Perzynski@aster.pl> wrote:

> > Devin,
> >
> > The problem is that I'm in Poland and we don't have ATSC here as far as I'm
> > aware but I will try to test it anyway.
> > Could you please look at the wiki for that card and tell me what will be the
> > analog video decoder for that card (I don't have /dev/videoX device).
> 
> Hmm....  It's a cx25843.  I would have to look at the code to see how
> to hook that into the CY7C68013A bridge.  I'll take a look tonight
> when I get home.

The cxusb.[ch] files seem to devoid of analog support.  There's this
comment which sums it up:

* TODO: Use the cx25840-driver for the analogue part


Although the linux/media/video/pvrusb2 driver appears to have at least
two hybrid boards with a cx2584x and an FX2 (WinTV HVR-1900 and HVR-1950
in pvrusb2_devattr.c).  Maybe that driver could help... (or maybe I
haven't got a clue :] )

Regards,
Andy


> Devin
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
