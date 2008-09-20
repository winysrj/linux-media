Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m8KHM7II026444
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 13:22:07 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m8KHLkis018014
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 13:21:47 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
In-Reply-To: <48D4FA9E.6000802@gmail.com>
References: <52E25CB7BF4E483089A488BD33B01059@DadyPC>
	<BLU121-DAV6F8BF57A7A953B8492CD6C2A60@phx.gbl>
	<7E99B38C8E0743AC9433ADCFAE34BC40@DadyPC>
	<BLU121-DAV23EF75E8170A0882139E5C2A60@phx.gbl>
	<5DFFD9161FC443AFB5D747B0EFA48C1A@DadyPC>
	<BLU121-DAV10925F9CFA27DB5428BD48C2A10@phx.gbl>
	<AE5A9016310A49F9902FCA896F18CED1@DadyPC>
	<BLU116-W707A6B2D87B90CC2FB50AC24E0@phx.gbl>
	<48D4FA9E.6000802@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 20 Sep 2008 19:15:05 +0200
Message-Id: <1221930905.2694.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: dabby bentam <db260179@hotmail.com>, linux-dvb@linuxtv.org,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [linux-dvb] FIXME: audio doesn't work on svideo/composite -
	hvr-1110 S-Video and Composite
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

Am Samstag, den 20.09.2008, 15:29 +0200 schrieb tomlohave@gmail.com:
> dabby bentam a écrit :
> > Hi Tom,
> >
> > Sorry to bother you like this in this way. I'm emailing because i have 
> > a Wintv hvr-1110 card. In the kernel sources it has
> >
> > FIXME: audio doesn't work on svideo/composite
> >
> > Do you know what is required to get this to work?
> >
> > Can i help in getting this to work?
> >
> > Thanks for your time
> >
> > David Bentham
> >
> 
> Hi,
> 
> first, sorry for my poor english
> 
> No sorry not sure what to do, i've try many configurations and 
> modifications in order to have svideo/composite audio but no result
> 
> you can try different parameter (see in sources, take example on other 
> cards)
> or ask on linuxtv mailing list
> I forward your precedant mail to this list
> 
> Cheers
> 
> Thomas
> 

there are different models of the HVR-1110 we can see on
hauppauge_eeprom down in saa7134-cards.c.

Some don't even have analog audio in.

In case it is there, if the current LINE2 stereo input pair doesn't
work, then it is LINE1.

If that still does not work, you can expect an external gpio driven mux
chip on the board. On cards with analog audio out it can be fairly easy
tested by unloading the driver. Default is then to loop the sound
through to the analog output of the card to the soundcard, but with the
driver unloaded you can't test, since you need saa7134-alsa for it
without having analog audio out connected on the card.

In that case regspy.exe from DScaler (deinterlace.sf.net) might help.

A work around could be to plug the external analog sound directly into
the sound card/chip and record from there.

Was the radio ever tested? Since the tda8275ac1 has only one RF signal
input pin and the card has two antenna connectors, we usually see that
these inputs are switched on gpio21 including the AutoGainControl and
using the 5.5MHz ceramic filter for radio input.

See the other cards with TUNER_PHILIPS_TDA8290.

Mostly it is high (0x0200000) for the radio switch, only sometimes the
other way round. Then you must set .gpio = 0x0200000 for the TV input
with the same gpio_mask.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
