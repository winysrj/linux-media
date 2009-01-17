Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:50080 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbZAQBNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 20:13:53 -0500
Subject: Re: [linux-dvb] dvb-t config for Ukraine_Kiev (ua)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: vdp <vdp@teletec.com.ua>,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
In-Reply-To: <alpine.DEB.2.00.0901170041060.18012@ybpnyubfg.ybpnyqbznva>
References: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org>
	 <495A0E46.6030903@teletec.com.ua>
	 <alpine.DEB.2.00.0812301329490.29535@ybpnyubfg.ybpnyqbznva>
	 <495A6A08.90909@teletec.com.ua>
	 <alpine.DEB.2.00.0812302005410.29535@ybpnyubfg.ybpnyqbznva>
	 <496617B4.5090508@teletec.com.ua>
	 <alpine.DEB.2.00.0901090924250.26988@ybpnyubfg.ybpnyqbznva>
	 <12410322804.20090114085746@teletec.com.ua>
	 <alpine.DEB.2.00.0901170041060.18012@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 02:14:11 +0100
Message-Id: <1232154851.7588.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry,

Am Samstag, den 17.01.2009, 01:41 +0100 schrieb BOUWSMA Barry:
> Hi Dmitry, thank you for your mail!
> 
> I am posting part of it to the linux-dvb list, in case someone
> there can give more or better information than I do...
> 
> On Wed, 14 Jan 2009, vdp wrote:
> 
> > BB> some random 8-bit chars to make sure this gets tagged as utf-8...
> > sory, it's really Cyrillic - I can read it with
> > code_table_windows_1251, not like UTF-8, but strange and interesting ;-)
> 
> Off-topic here, but to explain --
> In the more-than-ten years since I last used the mail program
> I am using now, the language and multi-lingual support has
> greatly improved -- back then, it would make no effort to try
> and display your Cyrillic characters, be they in KOI8-U, or
> ISO-8859-5, or whatever - if I had selected to display, say
> 8859-1, or 8859-2 for Czech.
> 
> But today, even with my use of the text console and no windowing
> system, I can display Cyrillic, Polish, Slovak, French, Hebrew,
> Greek -- all at the same time.  Yay!
> 
> However, when I sent out a message with Greek characters, I saw
> in my local copy of it, that it was sent as 8859-7.  But I do
> not know if many mailers are able to understand how to convert
> from that and display properly with a Unicode font.
> 
> The same way, when I sent the Ukranian text, it could be that
> some people in western europe, or outside europe entirely, might
> not see the characters correctly, because my mailer was set up
> to use the smallest possible unique character set tagging,
> rather than UTF-8 which has become far more common now (yes,
> I should fix my mailer configuration).
> 
> So, in order to give the message a UTF-8 character set tagging,
> so that it could be displayed simply by any utf-8-aware
> xterm with a -10646 font, or on a text console with Unicode
> enabled and a font that uses as many possible characters in
> the 512 that are available, with a mailer that does not know
> how to convert from 8859-x into Unicode, I needed to insert a
> few German and Greek and Hebrew characters that are not common
> to 8859-5.
> 
> And that is why I did not send only the Cyrillic characters,
> in case some mailer fails, and displays them as western-european
> or something else, the way I used to see things...
> 
> This is easy to set up with X as there are plenty of -10646
> fonts available in the years since I contributed an 8859-2
> font; for the very nice large font of a 25x80 text console on
> a nice large monitor that does not strain my eyes, I like
> SCREEN_FONT=/usr/local/src/fonty-rg-0.5/LatCyrGr-16.psf.gz
> that makes many useful g00gle results readable to me.
> 
> Again, sorry for going off-topic for so long...
> 
> 
> Now, to your question, which maybe some linux-dvb reader can
> offer more help...
> 
> 
> > now work next scheme:
> > I tzap to some channel and read stream with emcast from /dev/dvb/adapter0/dvr0
> > but it is only one channel - I would like stream all transponder
> > 
> > Could you help, with advice - is it possible ? (receive all
> > transponder with several channels simultaneous at the same time)
> 
> Yes, this is very possible.
> 
> The one thing to be certain of, is that you are not using a
> USB-1 device, as the bandwidth of USB 1 is less than most DVB-T
> multiplexes today -- usually you can fit at least two services
> without problems, though, over USB 1.
> 
> 
> The special ``PID'' of 8192 is used by, for example, `dvbstream'
> meaning to send the entire datastream with all PIDs to its
> output.  It will also do all the tuning for you.
> 
> Or, if you know all the PIDs that are used on a particular
> frequency, you can usually list all of them of interest, up
> to the limit of the hardware PID filter, if there is one.
> 
> This can save some space, as PID 8191 usually takes up some
> bandwidth for null packets to fill the available bandwidth,
> and there may be unneeded services, such as data, teletext,
> or whatever, that you do not care about.
> 
> For example, here is what I would use to record three of
> the RTVi services which are sometimes FTA on Hotbirds:
> /home/beer/bin/dvbstream  ${OPERA1}  -T  \
>     -s 27500   -p h   -f 12322   -I 2   -D 2  \
>     -o:${RECROOT:-/opt}/Partial_Transport_Streams/detskii_mir-fs-${DATE}.ts  \
>     0 44  -v 45  -a 46   40 41 42  47 48 49   $*
> 
> (I am actually guessing that the last 6 PIDs are correct,
> as I only recorded the one service...)
> 
> Then you only need to select which programme you wish during
> playback with your media player (you may need to record some
> additional PIDs to see the service name).  Or you can split
> the three services into three separate files.
> 
> 
> I use the `8192' PID when I want the entire stream, but if
> you want to use `tzap' or similar, then whatever program you
> use after that needs to set all the PIDs -- for example,
> `dvbtraffic' after I've tuned to a DVB-H multiplex...
> -PID--FREQ-----BANDWIDTH-BANDWIDTH-
> 0000    20 p/s     3 kb/s    31 kbit        0
> 0011     3 p/s     0 kb/s     5 kbit       17
> 0012    23 p/s     4 kb/s    35 kbit       18
> 0015     1 p/s     0 kb/s     2 kbit       21
> 0020    19 p/s     3 kb/s    29 kbit       32
> [snip]
> 1fff  1533 p/s   281 kb/s  2306 kbit     8191
> 2000  6609 p/s  1213 kb/s  9940 kbit     8192
> 
> 
> Other people would have to suggest programs which are able
> to do this for you, as I only know about `dvbstream' and
> have not tried using anything else...
> 
> 
> barry bouwsma
> (as always, writing too much)
> 

don't take it serious.

I wonder how much longer people will buy shark cadavers produced in the
UK, until they realize that it are only shark cadavers.

Cheers,
Hermann


