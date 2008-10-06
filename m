Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Kmni4-0006PK-8f
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 12:53:05 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1048769nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 06 Oct 2008 03:53:00 -0700 (PDT)
Date: Mon, 6 Oct 2008 12:52:36 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Olivier Mueller <om-lists-linux@omx.ch>
In-Reply-To: <1223288468.4776.42.camel@frosch.local>
Message-ID: <alpine.DEB.2.00.0810061228250.12701@ybpnyubfg.ybpnyqbznva>
References: <1223288468.4776.42.camel@frosch.local>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org, em28xx@mcentral.de
Subject: Re: [linux-dvb] Miglia Eyetv Hybrid 2008?
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

Gruezi...

On Mon, 6 Oct 2008, Olivier Mueller wrote:

> Then I hoped it would be the same for a brand new "Elgato EyeTV
> Hybrid" (dvb-T + analog,

> Just in case, here the information told under OS X's Eyetv.app: 

> USB Controller:  Empia EM2884
> Stereo A/V Decoder:  Micronas AVF 49x0B
> Hybrid Channel Decoder:  Micronas DRX-K DRX3926K:A1 0.8.0

These seem to be the same chips that are used in a tuner which
I have -- the TerraTec Cinergy HTC USB XS -- apart from the
tuner, which is found at i2c address 0x60, making me think it
might be an MT2060, maybe.

The Empia cards are in part being worked on at Markus Rechberger's
mcentral.de, where I expect you will first see support added.

There's a mailing list, which I've added to the cc: header, in
case you want to follow that for latest updates.  Not sure if
you need to subscribe first; gmane has handy archives.

Of course, there could be independent support being written for
inclusion into the v4l-dvb source tree, but neither the Empia
chip nor the two demodulators are presently supported by any
other existing driver.


I could give you a couple of lines of source that do little
more than identifying your card and giving you access to the
i2c bus with the demodulators et al, but that's pretty useless.


As I understand it, proper support (with help of the chipset
manufacturers) is in the pipeline, so keep an eye on em28xx-new
at mcentral.de as well as linuxtv.org for your card.


merci,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
