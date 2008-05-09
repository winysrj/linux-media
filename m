Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4915Yge027075
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 21:05:34 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4915K0e000644
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 21:05:20 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1210293148.10112.7.camel@palomino.walls.org>
References: <482370FD.7000001@users.sourceforge.net>
	<1210292031.4565.26.camel@palomino.walls.org>
	<1210293148.10112.7.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 09 May 2008 03:04:20 +0200
Message-Id: <1210295060.2541.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: cx88 driver: Help needed to add radio support on Leadtek
	WINFAST DTV 2000 H (version J)
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


Am Donnerstag, den 08.05.2008, 20:32 -0400 schrieb Andy Walls:
> On Thu, 2008-05-08 at 20:13 -0400, Andy Walls wrote:
> > On Thu, 2008-05-08 at 23:30 +0200, Andre Auzi wrote:
> > > Hello list,
> > > 
> > > I've started the task to add support of the board mentionned above.
> > > 
> > > So far I've got analog TV, Composite and Svideo inputs working OK with 
> > > IR as well.
> > > 
> > > Unfortunately, my area does not have DVB-T yet, but from the scans I've 
> > > made, I'm confident DVB support is on good tracks.
> > > 
> > > Nevertheless, I cannot achieve to have the radio input working.
> > > 
> > > The gpio values were captured with regspy on a working windows installation.
> > 
> > With the ivtv driver, I helped debug the LG TAPE-H series tuner on the
> > PVR-150MCE not demodulating FM radio.  (Hans actually got the fix put
> > in.)  The problem turned out to be the incorrect "bandswitch byte" being
> > set in tuner-simple.c.  AFAICT, the gpio values for the CX23416 aren't
> > used to set the FM radio on the PVR-150MCE.
> > 
> > There is a "bandswitch byte" in the synthesizer/1st mixer chip (probably
> > a tua603x chip) in the tuner that controls some gpio pins.  These gpio
> > pins setup the tuner's preselector by switching in the proper bandpass
> > filter for the Low VHF, FM, High-VHF, or UHF bands
> > 
> > For the FM1216ME_MK3 tuner (not the FMD1216ME_MK3) this bandswitch byte
> > needs to be set to 0x98 for FM stereo or 0x9a for FM mono.
> 
> Correction, I read the datasheet wrong.  It should be 0x19 or 0x59.  I
> reversed the bits.  (The data sheet had the LSB in the left column of
> the table and the MSB in the right column of the table for some reason.)
> 
> > 
> > I notice in tuner-simple.c:simple_radio_bandswitch(), that for both the
> > FM1216ME_MK3 and the FMD1216ME_MK3, the bandswitch byte for FM is coded
> > as 0x19.  This is a bit-reversal of 0x98.  This seems wrong according to
> > the FM1216ME_MK3 tuner datasheet here:
> > 
> > http://dl.ivtvdriver.org/datasheets/tuners/FM1216ME_MK3.pdf
> 
> Again correction: I was the one who was wrong.  The code for the
> FM1216ME_MK3 bandswitch to radio matches the datasheet.
> 
> 
> > I can't find the FMD1216ME_MK3 datasheet with some quick google
> > searches.  I cannot conclusively say the coded bandswitch byte of 0x19
> > is wrong for the FMD1216ME_MK3, but I think it's worth some
> > investigation/experimentation.
> 
> This I still think is worth verification for the FMD1216ME_MK3.  But
> given that the Phillips designs and the LG rebranded Phillips designs
> all seem to follow this pattern, I suspect it is correct.
> 
> > 
> > You might also want to check/fix the tuner-simple.c:tuner_stereo()
> > function while you're at it.
> 
> The FMD1216ME_MK3 is missing from this function.  Once you can here
> stereo and mono stations, it is worth checking if this function is
> correct for the FMD1216ME_MK3

No! ;)

Cheers,
Hermann


> 
> -Andy
> 
> > Good luck,
> > Andy
> > 
> > 
> > > 
> > > Here are my additions in cx88-cards.c:
> > > 
> > > diff -r 0a072dd11cd8 linux/drivers/media/video/cx88/cx88-cards.c
> > > --- a/linux/drivers/media/video/cx88/cx88-cards.c    Wed May 07 15:42:54 
> > > 2008 -0300
> > > +++ b/linux/drivers/media/video/cx88/cx88-cards.c    Thu May 08 23:07:36 
> > > 2008 +0200
> > > @@ -1300,6 +1300,52 @@
> > >          }},
> > >          .mpeg           = CX88_MPEG_DVB,
> > >      },
> > > +    [CX88_BOARD_WINFAST_DTV2000H_VERSION_J] = {
> > > +        /* Radio still in testing */
> > > +        .name           = "WinFast DTV2000 H (version J)",
> > > +        .tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
> > > +        .radio_type     = UNSET,
> > > +        .tuner_addr     = ADDR_UNSET,
> > > +        .radio_addr     = ADDR_UNSET,
> > > +        .tda9887_conf   = TDA9887_PRESENT,
> > > +        .input          = {{
> > > +            .type   = CX88_VMUX_TELEVISION,
> > > +            .vmux   = 0,
> > > +            .gpio0  = 0x00013700,
> > > +            .gpio1  = 0x0000a207,
> > > +            .gpio2  = 0x00013700,
> > > +            .gpio3  = 0x02000000,
> > > +        },{
> > > +            .type   = CX88_VMUX_CABLE,
> > > +            .vmux   = 0,
> > > +            .gpio0  = 0x0001b700,
> > > +            .gpio1  = 0x0000a207,
> > > +            .gpio2  = 0x0001b700,
> > > +            .gpio3  = 0x02000000,
> > > +        },{
> > > +            .type   = CX88_VMUX_COMPOSITE1,
> > > +            .vmux   = 1,
> > > +            .gpio0  = 0x00013701,
> > > +            .gpio1  = 0x0000a207,
> > > +            .gpio2  = 0x00013701,
> > > +            .gpio3  = 0x02000000,
> > > +        },{
> > > +            .type   = CX88_VMUX_SVIDEO,
> > > +            .vmux   = 2,
> > > +            .gpio0  = 0x00013701,
> > > +            .gpio1  = 0x0000a207,
> > > +            .gpio2  = 0x00013701,
> > > +            .gpio3  = 0x02000000,
> > > +        } },
> > > +        .radio = {
> > > +            .type   = CX88_RADIO,
> > > +            .gpio0  = 0x00013702,
> > > +            .gpio1  = 0x0000a207,
> > > +            .gpio2  = 0x00013702,
> > > +            .gpio3  = 0x02000000,
> > > +        },
> > > +    },
> > >      [CX88_BOARD_GENIATECH_DVBS] = {
> > >          .name          = "Geniatech DVB-S",
> > >          .tuner_type    = TUNER_ABSENT,
> > > @@ -1957,6 +2003,10 @@
> > >          .subdevice = 0x665e,
> > >          .card      = CX88_BOARD_WINFAST_DTV2000H,
> > >      },{
> > > +        .subvendor = 0x107d,
> > > +        .subdevice = 0x6f2b,
> > > +        .card      = CX88_BOARD_WINFAST_DTV2000H_VERSION_J,
> > > +    },{
> > >          .subvendor = 0x18ac,
> > >          .subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
> > >          .card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
> > > 
> > > 
> > > Would there be someone in the list with cx88 driver knowledge who 
> > > already achieved this for another board and could hint me on things to 
> > > look for?
> > > 
> > > I kindof reached the limits of my imagination and would really 
> > > appreciate a help.
> > > 
> > > So far my modprobe.conf reads:
> > > 
> > > options tda9887 debug=1
> > > options cx22702 debug=1
> > > options cx88xx i2c_debug=1 i2c_scan=1 audio_debug=1
> > > options cx8800 video_debug=1
> > > 
> > > and I would join the dmesg output if I did not care to flood the list.
> > > 
> > > Just let me know if it could help.
> > > 
> > > Thanks in advance
> > > Andre
> > 
> > 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
