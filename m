Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MNGRWj015763
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 19:16:27 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8MNGD7t011971
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 19:16:14 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: dabby bentam <db260179@hotmail.com>
In-Reply-To: <BLU116-W22ED124457AE21528EA59BC24B0@phx.gbl>
References: <BLU116-W45ED43A6BD49AF4EF5916AC24B0@phx.gbl>
	<1222117083.2983.14.camel@pc10.localdom.local>
	<BLU116-W22ED124457AE21528EA59BC24B0@phx.gbl>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 01:11:26 +0200
Message-Id: <1222125086.2983.59.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: RE: [linux-dvb] FIXME: audio doesn't work on svideo/composite -
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


Am Montag, den 22.09.2008, 21:54 +0000 schrieb dabby bentam:
> Yipee...
> 
> I've attached a working saa7134-cards.c from an ubuntu 2.6.24-19.36
> kernel. Not sure the mask setting is correct? as v4ctl -list comes up
> as television on all three inputs, but as soon as you switch via
> tvtime, it comes up correctly?
> 
> Also its LINE1 not LINE2!
> 
> You still have to redirect the sound via sox or arecord - pci dma i
> guess? and unmute it. But its a start.
> 
> Radio is not tested!
> 
> Anymore suggestions on tweaking this. Both S-video and Composite have
> sound now!!!
> 

Fine!

You still top post and the only attachment I have is your html email :)

Please test the radio next and then we will bake something ;)

Cheers,
Hermann
> 
> ______________________________________________________________________
> > Subject: RE: [linux-dvb] FIXME: audio doesn't work on
> svideo/composite - hvr-1110 S-Video and Composite
> > From: hermann-pitton@arcor.de
> > To: db260179@hotmail.com
> > CC: tomlohave@gmail.com
> > Date: Mon, 22 Sep 2008 22:58:03 +0200
> > 
> > Hi,
> > 
> > Am Montag, den 22.09.2008, 18:03 +0000 schrieb dabby bentam:
> > > Here is the log.
> > > 
> > > >>>
> > > >>> If you use the supplied m$ app, not DScaler, and save the logs
> for the
> > > >>> card in status unused, TV, composite/s-video and radio, we
> will see the
> > > >>> gpio mask in use there and likely changing gpio pins.
> > > >>>
> > > >>> They often have more pins in the mask and also more that
> change,
> > > >>> but usually one of them will be what we need to add to the
> mask.
> > > >
> > 
> > 6 states dumped
> > 
> >
> ----------------------------------------------------------------------------------
> > 
> > SAA7133 Card - State 0:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000)
> > SAA7134_GPIO_GPSTATUS: 06400100 (00000110 01000000 00000001
> 00000000)
> > 
> > SAA7133 Card - State 1:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000)
> > SAA7134_GPIO_GPSTATUS: 06400100 (00000110 01000000 00000001
> 00000000)
> > 
> > SAA7133 Card - State 2:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000)
> > SAA7134_GPIO_GPSTATUS: 06400100 * (00000110 01000000 00000001
> 00000000)
> > 
> > SAA7133 Card - State 3:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000) 
> > SAA7134_GPIO_GPSTATUS: 06400000 (00000110 01000000 00000000
> 00000000) (was: 06400100)
> > 
> > SAA7133 Card - State 4:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000)
> > SAA7134_GPIO_GPSTATUS: 06400000 * (00000110 01000000 00000000
> 00000000)
> > 
> > 
> > SAA7133 Card - Register Dump:
> > SAA7134_GPIO_GPMODE: 02600100 (00000010 01100000 00000001 00000000) 
> > SAA7134_GPIO_GPSTATUS: 06400100 (00000110 01000000 00000001
> 00000000) (was: 06400000)
> > SAA7134_ANALOG_IN_CTRL1: 83 (10000011) (was: c8) 
> > 
> > 
> > If state 3 and 4 are composite and s-video, the audio swithc could
> be on
> > gpio8. There are 28 gpio pins (0-27).
> > 
> > This would mean gpio mask 0x0100 and gpio 0x0100 for TV and radio
> and
> > 0x000 for composite and s-video. LINE2 or LINE1.
> > 
> > As expected the usual gpio21 switch pin for radio is set in the m$
> mask,
> > but always stays at 0.
> > 
> > Was radio used at all or is it even working like it is now?
> > Very unusual...
> > 
> > If radio needs gpio21 = 1, the gpio mask could be 0x0200100 and
> radio
> > gpio should be 0x0200100.
> > 
> > I did not look up the gpio init data of the board yet,
> > but would expect gpio9 is strapped high (output/1) and gpio21 is 0
> > there.
> > 
> > Good Luck,
> > Hermann
> > 
> > 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
