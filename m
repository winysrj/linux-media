Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1Ki2Vh-0000uA-4U
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 09:40:37 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 23 Sep 2008 09:39:57 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAANaAFVszeqk6rYggku+N2CQEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0809222133560.25926@ybpnyubfg.ybpnyqbznva>
Subject: [linux-dvb] RE :  DVB-H support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> On Mon, 22 Sep 2008, Javier G=E1lvez Guerrero wrote:

> If I understand what you are asking, as far as I know in the
> area where I am, all DVB-H services are broadcast with
> modulation parameters that makes it possible to receive them
> with any DVB-T device that can be used with Linux-DVB, so
> you do not need to search for a specific receiver.  Any will
> work, and I deliberately chose *not* to use my TerraTec to
> verify that I could tune DVB-H on something else not specifically
> intended for that as well as DVB-T.

> I do not know (without looking) if this is always the case,
> that DVB-H modulation can always be received by DVB-T --
> just as I don't know what is the difference between a DVB-H-
> capable receiver used with Linux-DVB and today's DVB-T devices.
> Someone else would have to clarify that, if it's important.

I think that the preferred transmission mode for DVB-H is 4K
while many (most? all?) DVB-T receivers can do 2K and 8K only.
The current Linux DVB API does not even have a definition for 4K.

>From ETSI EN 300 744 ("DVB; Framing structure, channel coding and
modulation for digital terrestrial television"):

  Exclusively for use in DVB-H systems, a third transmission mode the
  "4K mode" is defined in annex F, addressing the specific needs of
  Handheld terminals. The "4K mode" aims to offer an additional
  trade-off between transmission cell size and mobile reception
  capabilities, providing an additional degree of flexibility for
  DVB-H network planning.

See also ETSI EN 302 304 ("DVB; Transmission System for Handheld
Terminals (DVB-H)").

Here, in France, we won't see DVB-H until next year so I cannot
tell. There was a field test two or three years ago in the Paris
area. At that time, I did receive DVB-H on an Hauppauge PCI DVB-T
receiver in a Linux box but the field test used 2K, not 4K
(modulator availability issue at this time maybe).

But if your receiver can do 4K or your DVB-H network uses 2K or 8K,
you can receive DVB-H on a DVB-T receiver device.

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
