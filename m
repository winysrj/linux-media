Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1OEecCI031547
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 09:40:38 -0500
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1OEeKKs028911
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 09:40:20 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20090224213058.13cd1737@glory.loctelecom.ru>
References: <20090224160642.2200eb25@glory.loctelecom.ru>
	<1235477424.3334.15.camel@pc10.localdom.local>
	<20090224213058.13cd1737@glory.loctelecom.ru>
Content-Type: text/plain
Date: Tue, 24 Feb 2009 15:41:26 +0100
Message-Id: <1235486486.6929.2.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: new tuner
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


Am Dienstag, den 24.02.2009, 21:30 +0900 schrieb Dmitri Belimov: 
> Hi hermann
> 
> > Hi Dmitry,
> > 
> > on a first look.
> > 
> > Am Dienstag, den 24.02.2009, 16:06 +0900 schrieb Dmitri Belimov:
> > > Hi All.
> > > 
> > > How I can add new type of tuner to video4linux??
> > > 
> > > I add new definition into  linux/include/media/tuner.h
> > > #define TUNER_PHILIPS_FM1216MK5		79
> > > 
> > > add some data to
> > > /linux/drivers/media/common/tuners/tuner-types.c
> > > 
> > > /* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------
> > > */
> > > 
> > > static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
> > > 	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> > > 	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> > > 	{ 16 * 999.99        , 0x8e, 0x04, },
> > > };
> > 
> > This is wrong, since you only duplicate fm1216me_mk3_pal_ranges which
> > you should just use instead.
> 
> Yes, I know. My first step is duplicate all function of mk3 in new tuner. When all is build done and work
> without regression I add special part for MK5.
>  
> > > static struct tuner_params tuner_fm1216mk5_params[] = {
> > > 	{
> > > 		.type   = TUNER_PARAM_TYPE_PAL,
> > > 		.ranges = tuner_fm1216mk5_pal_ranges,
> > > 		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
> > >  		.cb_first_if_lower_freq = 1,
> > >  		.has_tda9887 = 1,
> > >  		.port1_active = 1,
> > >  		.initdata = tua603x_agc112,
> > >  		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
> > >  	},
> > 
> > Since you do not send a diff, I assume you are not in struct tunertype
> > tuners[] here. Also initdata and sleepdata should be there
> > 
> > > 		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
> > > 		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
> > > 		.params = tuner_fm1216mk5_params,
> > > 		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
> > > 	},
> > > 
> > > But when I change type of tuner to new model build exit with error.
> > > Incorrect tuner name.
> > > 
> > > What is wrong??
> > > 
> > > With my best regards, Dmitry.
> > > 
> > 
> > You also miss to set it up for the radio mode switch in tuner-simple
> > and did not look into tveeprom.c, where you can see that we use the 
> > TUNER_PHILIPS_FM1216ME_MK3 for it since long without complaints. MK4
> > is also the same.
> > 
> > If you don't have the detailed programming tables for every supported
> > TV standard and detailed instructions for radio mode, I would assume
> > that you reduce the quality of support for that tuner a lot with your
> > current attempt.
> 
> I have all documentation to this tuner under NDA. I want add support of MK5 to v4l.
> MK3 and MK5 has some incompatible registers and control messages.

OK, that's fine then, but for now it is all the same like FM1216ME MK3.

> Some of our TV card has two different tuners: MK3 and MK5. Some customers can has
> some problem with one model of TV card with different tuners.
> 
> See attache. I split our card to different types and add new tuner.
> 
> > For example SECAM-L would not work without port2=0 and radio without
> > high sensitivity set is also very poor.
> > 
> > Cheers,
> > Hermann
> 
> With my best regards, Dmitry.

It does compile here without errors.

There is an offset in tuner-simple.c and you must have something
different there.

patch -p1 < mk5_01.diff
patching file linux/drivers/media/common/tuners/tuner-simple.c
Hunk #2 succeeded at 510 (offset -2 lines).
patching file linux/drivers/media/common/tuners/tuner-types.c
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
patching file linux/drivers/media/video/saa7134/saa7134-input.c
patching file linux/drivers/media/video/saa7134/saa7134.h
patching file linux/include/media/tuner.h

Run make checkpatch and add the commas, there is one tab too much at the
end of tuner-types.c. Sorry, no time until weekend.

If you in the end really improve and change something for the FM1216ME
MK5, it likely should be reflected in tveeprom.c too. Currently it is
only duplication.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
