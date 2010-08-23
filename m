Return-path: <mchehab@pedra>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42844 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0HXACM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 20:02:12 -0400
Subject: Re: patch for lifeview hybrid mini
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C72804F.1090201@gmail.com>
References: <4C67790D.3060600@gmail.com>
	 <1282004685.8749.50.camel@pc07.localdom.local> <4C72804F.1090201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Aug 2010 01:49:21 +0200
Message-Id: <1282607361.15990.41.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


Am Montag, den 23.08.2010, 16:06 +0200 schrieb tomlohave@gmail.com:
> Le 17/08/2010 02:24, hermann pitton a écrit : 
> > Hi,
> > 
> > Am Sonntag, den 15.08.2010, 07:20 +0200 schrieb tomlohave@gmail.com:
> >   
> > > Hi,
> > > 
> > > the proposed patch is 6 month old and the owner of the card does not 
> > > give any more sign of life for the support of the radio.
> > > can someone review it and push it as is?
> > > 
> > > Cheers,
> > > 
> > > Signed-off-by: thomas genty<tomlohave@gmail.com>
> > > 
> > >     
> > Thomas, just some quick notes, since nobody else cares.
> > 
> > The m$ regspy gpio logs do show only gpio22 changing for analog and
> > DVB-T and this should be the out of reference AGC control on a hopefully
> > single hybrid tuner on that device called DUO.
> > 
> > Remember, gpios not set in the mask of the analog part of the device do
> > not change/switch anything, but those set there will change to zero even
> > without explicit gpio define for that specific analog input.
> > 
> > Out of historical reasons, we don't have this in our logs for DVB, also
> > else they would be littered by the changing gpios for the TS/MPEG
> > interface, but should be OK. We don't need to mark DVB related gpio
> > stuff in the analog gpio mask, since we need to use some sort of hack to
> > switch gpios on saa713x in DVB mode.
> > 
> > dvb and v4l still don't know much about what each other subsystem does
> > on that, but we have some progress.
> > 
> > So, for now, I don't know for what gpio21 high in analog TV mode should
> > be good, since the m$ driver seems not to do anything on that one, for
> > what we have so far. Also it is common on later LifeView stuff (arrgh),
> > but always is present in related logs then too.
> > 
> > If ever needed,
> > 
> > despite of that line inputs and muxes are also totally unconfirmed, and
> > radio is plain madness ...
> > 
> > drop the radio support for now, mark the external inputs as untested and
> > I give some reviewed by so far with headaches.
> > 
> > If we can't get more from here anymore, we must let it bounce.
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > 
> >   
> 
> Hi Hermann,
> 
> thanks for you response
> 
> for gpios : there is no software bundled with this card to listen to
> the radio so there is maybe a gpio not showed 
> in regspy when trying to listen music. Is this a bad assumption?
> anyway gpios 22 and 16 are hight in regspy
> with gpiomask 410 000 :
> dvb, analog tv and svideo work fine
> only radio remains :
> you can hear the results for radio here (2 Mo): 
> http://perso.orange.fr/tomlohave/linux/radio.test
> we can clearly hear the sound of a song but it is broken and
> interrupted, the question is why
> have you a suggestion ?
> 
> Cheers
> 
> T.G

Hello Thomas,

the assumption is good then.

Latest revisions of the Lifeview cards do switch to radio mode with
gpio21 high and let it low for TV. (it was the other way round
previously)

I was just wondering, if it might have radio support at all, since
gpio21 is not set in the m$ gpio mask and you say it does not come with
radio software.

The gpio18 and 16 can trigger IRQs and are usually in use on such
remotes for the button up/down signal and related IRQ sampling.

All saa7133/35/31e with tda8275ac and radio IF support use a special
7.5MHz ceramic filter, usually a huge well visible part in blue or
orange color, but on latest designs they are hard to identify, since
they might appear as SMD discrets now too.

The switch to this filter is often related to a an antenna connector RF
input switch triggered by the same gpio, but not necessarily. All sort
of combinations do exist.

Anyway, we demodulate the radio IF from such tuners on the
saa7133/35/31e on the saa chip and do also the stereo separation and
detection there. Hartmut added the needed code in saa7134-tvaudio and it
is valid for all tuner=54.

To achieve that, you need to use amux = TV for radio and likely also
some gpio is involved for the RF routing.

Cheers,
Hermann


