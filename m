Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17M8ZKK032262
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 17:08:35 -0500
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17M836b023055
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 17:08:03 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080207173926.53b9e0ce@gaivota>
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
	<20080207173926.53b9e0ce@gaivota>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 23:04:09 +0100
Message-Id: <1202421849.20032.25.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] New card entry (saa7134) and FM support for TNF9835
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

Am Donnerstag, den 07.02.2008, 17:39 -0200 schrieb Mauro Carvalho
Chehab:
> The patch looks sane. A few comments:
> 
> On Thu, 7 Feb 2008 16:09:48 -0200
> "Adrian Pardini" <pardo.bsso@gmail.com> wrote:
> 
> > Hello,
> > This patch brings complete functionality to the "Genius TVGo A11MCE" (saa7130,
> > tuner is TNF9835) proper audio/video routing, fm tunning and remote control.

here a saa7130 is said, and the wrong auto detection is for a saa7130.
Then the TV section with amux = TV is wrong. The saa7130 can't decode
anything from SIF. Only the TV mono section should be correct then.

See the card=3 FlyVideo2000 to which yours is very close anyway,
but else different enough for a new entry.

Please always send relevant "dmesg" for all card/tuner related when
loading the driver.

Did not look up the IR keymap yet, but mask_keydown seems unique.
Can you tell us the name of the IR controller chip?

> > Things I've done:
> >   * New entry for the card.
> >   * New entry for the tuner. It's a TNF9835, as the wiki says it works
> > fine for tv using
> >      tuner=37 but the datasheet specifies different frequency bands and the i2c
> >      command used to tune fm is other.

See comments below please.

> >   * Key mappings for the remote control.
> > 
> > Files changed:
> >   ir-common.h
> >   ir-keymaps.c
> >   saa7134.h
> >   saa7134-cards.c
> >   saa7134-input.c
> >   tuner.h
> >   tuner-simple.c
> >   tuner-types.c
> > 
> > Testing:
> >   I successfully built and tested it ( with the sources from
> > mercurial) using Ubuntu Gutsy(linux 2.6.22, custom) and Musix
> > 1.0r3-test5 (2.6.23-rt1)
> > 
> > Notes:
> >   I get this message from time to time and I don't know what to do:
> >   "saa7130[0]/irq: looping -- clearing PE (parity error!) enable bit"
> > 
> >   I didn't want to mess with the pci ids table.
> >   Without using the card= parameter it is detected as being an
> > "Philips TOUGH DVB-T reference design [card=61,autodetected]".
> >   lspci output:
> > 00:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> > Broadcast Decoder (rev 01)
> >         Subsystem: Philips Semiconductors Unknown device 2004
> >         Flags: bus master, medium devsel, latency 64, IRQ 11
> >         Memory at dffffc00 (32-bit, non-prefetchable) [size=1K]
> >         Capabilities: [40] Power Management version 1
> > 
> > I'm wide open to accept suggestions and corrections.
> > Thanks a lot for your time,
> > Adrian.
> 
> Hmmm... what a big changelog... Better to write it more summarized ;)
> 
> > ---
> > diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/common/ir-keymaps.c
> > v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c
> > --- v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2008-02-06
> > 22:54:07.000000000 -0200
> > +++ v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c	2008-02-07
> > 12:10:06.000000000 -0200
> 
> Your e-mail arrived word-wrapped. Please, don't let your emailer to break lines
> into 80 columns, otherwise, patch won't apply.
> > +	[ 0x48 ] = KEY_0,
> 
> There are CodingStyle violations here (*). The proper way is:
> 	 [0x48] = KEY_0
> 
> (*) yes, I know that this is already present at the current code. However,
> newer patches should bind to CodingStyle. Later, someone may fix the current
> code.
> 
> > +static struct tuner_range tuner_tnf9835_ranges[] = {
> > +	{ 16 * 161.25 /*MHz*/, 0x8e, 0x01, },
> > +	{ 16 * 463.25 /*MHz*/, 0x8e, 0x02, },
> > +	{ 16 * 999.99        , 0x8e, 0x08, },
> > +};
> 
> > +	[TUNER_TNF9835] = {
> > +		.name   = "TNF9835 FM / PAL B-BG / NTSC",
> > +		.params = tuner_tnf9835_params,
> > +		.count = ARRAY_SIZE(tuner_tnf9835_params),
> > +	},
> 
> Hmm... the same tuner works for both PAL and NTSC standards? Are you sure about
> the frequency ranges? I was expecting to have the same frequency for all
> tnfxx35 tuners, although I don't have a datasheet for tnf9835.
> 
> Cheers,
> Mauro
> 


Mauro, this one should be covered by your tuner=69 entry. Might have a
datasheet somewhere, but I think don't need it.

The Tena sheets always have a gap between the end of a band and the
start of the next band. For all what I previously looked up around that
stuff, there is no broadcast in that gap. So it doesn't matter much
where to start and end. Also, a TNF9835 tuner board was within the
TVF58t5-MFF. Except Adrian can show us missing channels, we should drop
the tuner stuff entirely.

Cheers,
Hermann

tuner=69

 /* ------------ TUNER_TNF_xxx5  - Texas Instruments--------- */
/* This is known to work with Tenna TVF58t5-MFF and TVF5835 MFF
 *	but it is expected to work also with other Tenna/Ymec
 *	models based on TI SN 761677 chip on both PAL and NTSC
 */

static struct tuner_range tuner_tnf_5335_d_if_pal_ranges[] = {
	{ 16 * 168.25 /*MHz*/, 0x8e, 0x01, },
	{ 16 * 471.25 /*MHz*/, 0x8e, 0x02, },
	{ 16 * 999.99        , 0x8e, 0x08, },
};

static struct tuner_range tuner_tnf_5335mf_ntsc_ranges[] = {
	{ 16 * 169.25 /*MHz*/, 0x8e, 0x01, },
	{ 16 * 469.25 /*MHz*/, 0x8e, 0x02, },
	{ 16 * 999.99        , 0x8e, 0x08, },
};

static struct tuner_params tuner_tnf_5335mf_params[] = {
	{
		.type   = TUNER_PARAM_TYPE_NTSC,
		.ranges = tuner_tnf_5335mf_ntsc_ranges,
		.count  = ARRAY_SIZE(tuner_tnf_5335mf_ntsc_ranges),
	},
	{
		.type   = TUNER_PARAM_TYPE_PAL,
		.ranges = tuner_tnf_5335_d_if_pal_ranges,
		.count  = ARRAY_SIZE(tuner_tnf_5335_d_if_pal_ranges),
	},
};

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
