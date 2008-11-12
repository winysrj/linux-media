Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACNNfIa013586
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 18:23:41 -0500
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACNNRMh028044
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 18:23:27 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Asher Glaun <asher@glaun.com>
In-Reply-To: <1226434614.5955.8.camel@UbuntuAMD>
References: <20081110214550.M62106@glaun.com>
	<1226366807.2493.28.camel@pc10.localdom.local>
	<1226434614.5955.8.camel@UbuntuAMD>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Nov 2008 00:21:04 +0100
Message-Id: <1226532064.3996.19.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134  Sabrent TVFM. Changes to radio?
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

Hi,

Am Dienstag, den 11.11.2008, 15:16 -0500 schrieb Asher Glaun:
> SOLVED
> Thanks Hermann, I'm not sure if the tuner is different but changing the
> card works ...
> 
> to play TV
> rmmod saa7134_alsa 
> rmmod saa7134
> modprobe saa7134 card=42 tuner=68   (gives me all 100 channels, audio)
> 
> to play radio
> rmmod saa7134_alsa 
> rmmod saa7134
> modprobe saa7134 card=67 radio_nr=0   (radio works beatifully
> through /dev/radio0)
> 
> I've created 2 launchers on my gnome desktop which run the commands
> above and then launch 'radio' or 'tvtime' depending on what I want. 
> 
> I works, I'm happy.
> 
> Asher.

in this case I would assume you have a saa7130 device with one of the
more recent TCL tuners with tda9887. At least 0x19 should be the radio
mode switch.

You could try to use tuner=43 in compatibility mode on card=42, since
else the tda9887 will not be initialized, and see If you can get TV and
radio at once. On card=67 the TV audio mux would be wrong for a saa7130
device. That one else uses tuner=38 by default.

On such TCL and similar tuners the original manufacturer sticker should
be under the Sabrent sticker close to the TV antenna connector.

Please consider to post relevant "dmesg" output on loading the saa7134
driver and tuner modules. It might be helpful for others to identify
their problems.

Cheers,
Hermann

> 
> 
> 
> 
> On Tue, 2008-11-11 at 02:26 +0100, hermann pitton wrote:
> > Hi Asher,
> > 
> > Am Montag, den 10.11.2008, 17:45 -0400 schrieb Asher Glaun:
> > > Everything but radio works, i.e. all inputs, TV tuner, audio etc. Command line
> > > client “radio” and “gnomeradio” both show signal strength and audio is FM
> > > static hiss so I’m sure I’m receiving a signal but cannot tune the card.
> > > Changing the frequency in the clients does nothing.
> > > 
> > > I load modprobe saa7134 card=42 tuner=68 radio_nr=0. This creates /dev/radio0
> > > which is where I point “radio” and “gnomeradio”.  Wrote a script to cycle
> > > through all the tuners, still the same static. Dual boot machine and radio
> > > works flawlessly in MS Vista.
> > > 
> > > I contacted to Michael Rodríguez-Torrent, an original developer of
> > > saa7134-cards.c and he says that the radio was the first thing he got working
> > > and that since everything else works he might suspect some changes that are
> > > causing problems.  He writes ..
> > > 
> > > “Your best shot might be a post to the mailing list asking what could have
> > > changed with regards to the handling of radios in the module and how the board
> > > definition can be updated to reflect that.”
> > 
> > you most likely have a different tuner on the board.
> > 
> > On old tin can tuners are only five known different tuner APIs to get
> > them into radio mode.
> > 
> > >From tuner-simple.c.
> > 
> > static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
> > {
> > 	struct tuner_simple_priv *priv = fe->tuner_priv;
> > 
> > 	switch (priv->type) {
> > 	case TUNER_TENA_9533_DI:
> > 	case TUNER_YMEC_TVF_5533MF:
> > 		tuner_dbg("This tuner doesn't have FM. "
> > 			  "Most cards have a TEA5767 for FM\n");
> > 		return 0;
> > 	case TUNER_PHILIPS_FM1216ME_MK3:
> > 	case TUNER_PHILIPS_FM1236_MK3:
> > 	case TUNER_PHILIPS_FMD1216ME_MK3:
> > 	case TUNER_PHILIPS_FMD1216MEX_MK3:
> > 	case TUNER_LG_NTSC_TAPE:
> > 	case TUNER_PHILIPS_FM1256_IH3:
> > 	case TUNER_TCL_MF02GIP_5N:
> > 		buffer[3] = 0x19;
> > 		break;
> > 	case TUNER_TNF_5335MF:
> > 		buffer[3] = 0x11;
> > 		break;
> > 	case TUNER_LG_PAL_FM:
> > 		buffer[3] = 0xa5;
> > 		break;
> > 	case TUNER_THOMSON_DTT761X:
> > 		buffer[3] = 0x39;
> > 		break;
> > 	case TUNER_MICROTUNE_4049FM5:
> > 	default:
> > 		buffer[3] = 0xa4;
> > 		break;
> > 	}
> > 
> > 	return 0;
> > }
> > 
> > And from Documentation/bttv/Tuners.
> > 
> > 1) Tuner Programming
> > ====================
> > There are some flavors of Tuner programming APIs.
> > These differ mainly by the bandswitch byte.
> > 
> >     L= LG_API       (VHF_LO=0x01, VHF_HI=0x02, UHF=0x08, radio=0x04)
> >     P= PHILIPS_API  (VHF_LO=0xA0, VHF_HI=0x90, UHF=0x30, radio=0x04)
> >     T= TEMIC_API    (VHF_LO=0x02, VHF_HI=0x04, UHF=0x01)
> >     A= ALPS_API     (VHF_LO=0x14, VHF_HI=0x12, UHF=0x11)
> >     M= PHILIPS_MK3  (VHF_LO=0x01, VHF_HI=0x02, UHF=0x04, radio=0x19)
> > 
> > 
> > If the default tuner=17 with old Philips API doesn't work for TV and
> > radio, most common for new types is tuner=69 TUNER_TNF_5335MF and
> > similar with TI PLLs.
> > 
> > The Philips MK3 API you currently use expects a tda9887 analog IF
> > demodulator with radio support. If that chip exists, it would show up as
> > detected in "dmesg" on loading the driver.
> > 
> > Do you mean you have tested already on tuner=69 too for radio and you
> > have TV reception with the UHF=0x04 MK3 switch in that ranges?
> > 
> > Tuner=68 is very unlikely.
> > 
> > So, what kind of tuner/components do you have not covered by the
> > above ;)
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > 
> > 
> > 
> > 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
