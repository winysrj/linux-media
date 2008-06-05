Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K4NFI-0005UK-Ok
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 23:43:45 +0200
From: Andy Walls <awalls@radix.net>
To: Mark A Jenks <Mark.Jenks@nsighttel.com>
In-Reply-To: <E90972B408355145B0D256944398F80516F6@exchange01.nsighttel.com>
References: <E90972B408355145B0D256944398F80516F6@exchange01.nsighttel.com>
Date: Thu, 05 Jun 2008 17:42:59 -0400
Message-Id: <1212702179.3173.8.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Best card right now for Mythtv?
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

On Thu, 2008-06-05 at 06:28 -0500, Mark A Jenks wrote:
> I am about to build a new Myth box.  It's been about 4 months since I
> did the last one, and I used the HVR-1250 for it since I don't need
> analog.
>  
> The next box I am going to build is going to record HD from
> Timewarner, and DTV from OTA (usa).  
>  
> I would like to have a dual tuner in it also if possible.
>  
> What is everyone out there using?

I'm using an HVR-1600 for OTA ATSC and OTA NTSC in the US.

With MythTV you set up the analog side of the card as you would a
CX23415/6 based card (i.e. tell myth it's an ivtv PVR-xx0 MPEG encoder
card as the cx18 driver is extremely similar).  You set up the digital
side of the card as you would any other dvb device in MythTV.  You can
do simultaneous digital and analog capture (e.g. Picture in Picture).


>    Which has the most complete mod support right now?

The cx18 driver is beta quality.  The most annoying problems are:

1. The first analog capture after modprobe doesn't work right.  Stop
that capture and every subsequent one will be fine.

2. Mono audio only, at a fairly soft level.

3. I2C bus initialization problems which essentially make the card
useless for some people.

4. No working VBI support yet.

Regards,
Andy




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
