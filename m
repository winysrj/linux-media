Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LDTPA-0004Rj-5l
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 01:39:49 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Robin Perkins <robin.perkins@internode.on.net>
In-Reply-To: <A4711CA1-6F97-4D35-8A67-2BF391D3D1ED@internode.on.net>
References: <A4711CA1-6F97-4D35-8A67-2BF391D3D1ED@internode.on.net>
Date: Fri, 19 Dec 2008 01:33:56 +0100
Message-Id: <1229646836.2561.20.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: LinuxTV-DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Junior Dev Help: Compro VideoMate T220
	driver	questions.
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

Hi,

only at a first look.

Am Donnerstag, den 18.12.2008, 12:54 +1000 schrieb Robin Perkins:
> Hello All, 
> 
> 
> I'm trying to write a driver for my Compro Videomate DVB-T220 card
> (It's a saa7134 based card). I have made a wiki
> page: http://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220 that contains the state of my card from the start. I have created a patch: IncompletePatchVideoMateT220.rtf that produces this output: dmesgOutput.rtf. Basically all the chipsets are identified, I just can't work out the right way to get them to work together. So I have a number of questions about my patch.
> 
> 
> Firstly, in the card configuration file, how do you determine the
> right vmux values to use for your inputs. At the moment I have just
> been attempting to purely guess.

Well done. Start with the most common.

Next could be to look at devices from the same manufacturer.
Also Philips/NXP m$ .inf files can have some hints.

Else, create enough inputs for composite (0-4) and s-video (6-9) and
just test.

> Second, my saa7134-dvb.c init and config functions are guesswork based
> on looking at what other similar cards do in here. Is there any
> insight as to what I need in here ? 

I would hang here the same way. The tuner and demod address seem to be
right for sure.

> Finally, from the RegSpy dump on the wiki I can see changes to a few
> SAA7134 registers. Do I need to worry about integrating these into the
> driver somehow ?

Seems not.

You can consider to derive a gpio_mask from there and set .gpio per
input for what is in the mask. Two pins are, the third and highest is in
off. Only 0-27 are valid.

Cheers,
Hermann




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
