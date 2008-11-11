Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABKGoA0023355
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 15:16:50 -0500
Received: from vms173001pub.verizon.net (vms173001pub.verizon.net
	[206.46.173.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABKGPl6008847
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 15:16:35 -0500
Received: from [192.168.0.100] ([71.162.94.77]) by vms173001.mailsrvcs.net
	(Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
	with ESMTPA id <0KA6007PEQZ765Q7@vms173001.mailsrvcs.net> for
	video4linux-list@redhat.com; Tue, 11 Nov 2008 14:16:21 -0600 (CST)
Date: Tue, 11 Nov 2008 15:16:54 -0500
From: Asher Glaun <asher@glaun.com>
In-reply-to: <1226366807.2493.28.camel@pc10.localdom.local>
To: hermann pitton <hermann-pitton@arcor.de>
Message-id: <1226434614.5955.8.camel@UbuntuAMD>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
References: <20081110214550.M62106@glaun.com>
	<1226366807.2493.28.camel@pc10.localdom.local>
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

SOLVED
Thanks Hermann, I'm not sure if the tuner is different but changing the
card works ...

to play TV
rmmod saa7134_alsa 
rmmod saa7134
modprobe saa7134 card=42 tuner=68   (gives me all 100 channels, audio)

to play radio
rmmod saa7134_alsa 
rmmod saa7134
modprobe saa7134 card=67 radio_nr=0   (radio works beatifully
through /dev/radio0)

I've created 2 launchers on my gnome desktop which run the commands
above and then launch 'radio' or 'tvtime' depending on what I want. 

I works, I'm happy.

Asher.






On Tue, 2008-11-11 at 02:26 +0100, hermann pitton wrote:
> Hi Asher,
> 
> Am Montag, den 10.11.2008, 17:45 -0400 schrieb Asher Glaun:
> > Everything but radio works, i.e. all inputs, TV tuner, audio etc. Command line
> > client “radio” and “gnomeradio” both show signal strength and audio is FM
> > static hiss so I’m sure I’m receiving a signal but cannot tune the card.
> > Changing the frequency in the clients does nothing.
> > 
> > I load modprobe saa7134 card=42 tuner=68 radio_nr=0. This creates /dev/radio0
> > which is where I point “radio” and “gnomeradio”.  Wrote a script to cycle
> > through all the tuners, still the same static. Dual boot machine and radio
> > works flawlessly in MS Vista.
> > 
> > I contacted to Michael Rodríguez-Torrent, an original developer of
> > saa7134-cards.c and he says that the radio was the first thing he got working
> > and that since everything else works he might suspect some changes that are
> > causing problems.  He writes ..
> > 
> > “Your best shot might be a post to the mailing list asking what could have
> > changed with regards to the handling of radios in the module and how the board
> > definition can be updated to reflect that.”
> 
> you most likely have a different tuner on the board.
> 
> On old tin can tuners are only five known different tuner APIs to get
> them into radio mode.
> 
> >From tuner-simple.c.
> 
> static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
> {
> 	struct tuner_simple_priv *priv = fe->tuner_priv;
> 
> 	switch (priv->type) {
> 	case TUNER_TENA_9533_DI:
> 	case TUNER_YMEC_TVF_5533MF:
> 		tuner_dbg("This tuner doesn't have FM. "
> 			  "Most cards have a TEA5767 for FM\n");
> 		return 0;
> 	case TUNER_PHILIPS_FM1216ME_MK3:
> 	case TUNER_PHILIPS_FM1236_MK3:
> 	case TUNER_PHILIPS_FMD1216ME_MK3:
> 	case TUNER_PHILIPS_FMD1216MEX_MK3:
> 	case TUNER_LG_NTSC_TAPE:
> 	case TUNER_PHILIPS_FM1256_IH3:
> 	case TUNER_TCL_MF02GIP_5N:
> 		buffer[3] = 0x19;
> 		break;
> 	case TUNER_TNF_5335MF:
> 		buffer[3] = 0x11;
> 		break;
> 	case TUNER_LG_PAL_FM:
> 		buffer[3] = 0xa5;
> 		break;
> 	case TUNER_THOMSON_DTT761X:
> 		buffer[3] = 0x39;
> 		break;
> 	case TUNER_MICROTUNE_4049FM5:
> 	default:
> 		buffer[3] = 0xa4;
> 		break;
> 	}
> 
> 	return 0;
> }
> 
> And from Documentation/bttv/Tuners.
> 
> 1) Tuner Programming
> ====================
> There are some flavors of Tuner programming APIs.
> These differ mainly by the bandswitch byte.
> 
>     L= LG_API       (VHF_LO=0x01, VHF_HI=0x02, UHF=0x08, radio=0x04)
>     P= PHILIPS_API  (VHF_LO=0xA0, VHF_HI=0x90, UHF=0x30, radio=0x04)
>     T= TEMIC_API    (VHF_LO=0x02, VHF_HI=0x04, UHF=0x01)
>     A= ALPS_API     (VHF_LO=0x14, VHF_HI=0x12, UHF=0x11)
>     M= PHILIPS_MK3  (VHF_LO=0x01, VHF_HI=0x02, UHF=0x04, radio=0x19)
> 
> 
> If the default tuner=17 with old Philips API doesn't work for TV and
> radio, most common for new types is tuner=69 TUNER_TNF_5335MF and
> similar with TI PLLs.
> 
> The Philips MK3 API you currently use expects a tda9887 analog IF
> demodulator with radio support. If that chip exists, it would show up as
> detected in "dmesg" on loading the driver.
> 
> Do you mean you have tested already on tuner=69 too for radio and you
> have TV reception with the UHF=0x04 MK3 switch in that ranges?
> 
> Tuner=68 is very unlikely.
> 
> So, what kind of tuner/components do you have not covered by the
> above ;)
> 
> Cheers,
> Hermann
> 
> 
> 
> 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
