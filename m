Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:34509 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757579AbZE0BtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 21:49:05 -0400
Subject: Re: [ivtv-devel] tveeprom cannot autodetect tuner! (FQ1216LME MK5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Martin Dauskardt <martin.dauskardt@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, linux-media@vger.kernel.org
In-Reply-To: <1243388309.4046.43.camel@palomino.walls.org>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1242901704.3166.8.camel@palomino.walls.org>
	 <1243038686.3164.34.camel@palomino.walls.org>
	 <200905252134.43249.martin.dauskardt@gmx.de>
	 <1243287953.3744.93.camel@pc07.localdom.local>
	 <1243388309.4046.43.camel@palomino.walls.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 03:47:51 +0200
Message-Id: <1243388871.9920.5.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Am Dienstag, den 26.05.2009, 21:38 -0400 schrieb Andy Walls:
> Hi Martin,
> 
> For some reason, I'm not getting any of your replies to the lists.  (I'm
> getting Hermann's posts though)

that is something I have seen since the beginning of changing to vger
too and it is very annoying.

> 
> On Mon, 2009-05-25 at 23:45 +0200, hermann pitton wrote:
> > Hi,
> > 
> > Am Montag, den 25.05.2009, 21:34 +0200 schrieb Martin Dauskardt:
> > > > #define TUNER_PHILIPS_FQ1216ME          24      /* you must actively select 
> > > B/G/D/K, I, L, L` */
> > > > #define TUNER_PHILIPS_FQ1216AME_MK4     56      /* Hauppauge PVR-150 PAL */
> > > > 
> > > > #define TUNER_PHILIPS_FM1216ME_MK3      38
> > > > 
> > > > #define TUNER_PHILIPS_FMD1216ME_MK3     63
> > > > #define TUNER_PHILIPS_FMD1216MEX_MK3    78
> > > > #define TUNER_PHILIPS_FM1216MK5         79
> > > > 
> > > > Could the user try one of those, starting with the FQ1216 tuner numbers
> > > > (24 and 56), to see if one of them works?  For the FQ1261LME MK3,
> > > > tveeprom has the FM1216ME_MK3 tuner number (38).
> > > > 
> > > 
> > > I have this card now at home for testing. First results:
> > > 
> > > #define TUNER_PHILIPS_FQ1216ME		24	/* you must actively select B/G/D/K, I, L, 
> > > Result: only static
> > > 
> > > #define TUNER_PHILIPS_FM1216ME_MK3	38
> > > result: picture + sound o.k.
> > > 
> > > #define TUNER_PHILIPS_FQ1216AME_MK4	56	/* Hauppauge PVR-150 PAL */
> > > result: picture o.k., but no sound
> > > 
> > > #define TUNER_PHILIPS_FMD1216ME_MK3	63
> > > result: picture + sound o.k.
> > > 
> > > #define TUNER_PHILIPS_FMD1216MEX_MK3	78
> > > result: picture + sound o.k.
> > > 
> > > #define TUNER_PHILIPS_FM1216MK5         79
> > > result: picture o.k. , but audio disappears every few seconds (for about 1-2 
> > > seconds, then comes back) 
> > > 
> > > tuner type 63 and 79 are Hybrid tuners. This is fore sure an analogue-only 
> > > tuner. The sticker says "Multi-PAL", and according to VIDIOC_ENUMSTD  it 
> > > supports PAL, PAL-BG and PAL-H. 
> 
> Yes, the hybrid tuners defintions obviously aren't right.  Sorry I
> missed that with my initial suggestions.  I'm not sure that I would
> believe what VIDIOC_ENUMSTD reports without a proper tuner definition (I
> haven't looked up the details on what the ioctl actually does though).
> 
> 
> > > So I think 38 is right. Any suggestions for further tests?
> 
> When you don't specifiy a tuner number at all, does the driver loading
> detect a tda988x chip?
> 
> With tuner type 24, does setting the video standard explicitly with
> 
> 	v4l2-ctl -s pal-B
> 
> or something similar help?
> 
> 
> Anyway, it looks like Hermann has already got a better idea of what the
> tuner definition might be.  (I haven't been keeping up with the
> conversation.  If you and Hermann can figure out something faster,
> off-list using German, I won't be offended by being left out of the
> conversation.)
> 
> Regards,
> Andy

Andy, please stay. You are most welcome.

Sorry, always late looking at this, I don't care much about better
English, but likely should do.

Cheers,
Hermann

> 
> > in my opinion the entry of tuner type 24 is buggy.
> > I posted once about it, but it is long ago.
> > 
> > /* ------------ TUNER_PHILIPS_FQ1216ME - Philips PAL ------------ */
> > 
> > static struct tuner_params tuner_philips_fq1216me_params[] = {
> > 	{
> > 		.type   = TUNER_PARAM_TYPE_PAL,
> > 		.ranges = tuner_lg_pal_ranges,
> > 		.count  = ARRAY_SIZE(tuner_lg_pal_ranges),
> > 		.has_tda9887 = 1,
> > 		.port1_active = 1,
> > 		.port2_active = 1,
> > 		.port2_invert_for_secam_lc = 1,
> > 	},
> > };
> > 
> > At least tuner_lg_pal_ranges must be wrong for an MK3 and UHF should
> > fail, if you can test on that. Switch must be 0x04 and not 0x08.
> > 
> > The hybrid tuners are also not compatible to an FM1216ME/I MK3.
> > They miss some frequencies when used for such an one and some low VHF
> > channels are snowy. The tda9887 is also not visible on them without
> > special initialization in tuner-core.c for them. Likely not the case on
> > yours.
> > 
> > FQ types from Philips are without radio support. FM types have radio.
> > Also the FMD1216MEX_MK3 has a different radio IF, BTW.
> > 
> > Previously I did recommend tuner 56 for them, but now with the more
> > detailed tda988/5/6/7 settings it misses .port2_active = 1.
> > Hans likely knows that it is right and else we would have reports from
> > people using it I guess. Hm.
> > 
> > You could test with tda9887 port2=0, if you get sound on that one too.
> > 
> > If the entry is correct and can't be changed, we likely need a new tuner
> > entry or the TUNER_PHILIPS_FQ1216ME must use mk3 ranges on UHF. But on
> > that one I have some doubts at all. How could it happen, given how old
> > it is and previously without tda9887 at all, that the wrong UHF switch
> > is undiscovered until today?
> > 
> > Hm, the new MK5 has trouble with sound, FM anyway, but
> > TUNER_PHILIPS_FM1216MK5 is a complete clone of the FM1216ME MK3,
> > except for the discussed 1MHz change for UHF beginning and 0xce versus
> > 0x8e. IIRC, 0xce should be even the better choice on tuners without
> > radio, but I need to look it up again or Andy is more aware about the
> > recent discussions. (faster tuning bit)
> > 
> > Maybe Dmitry has a datasheet for that one too.
> > 
> > One question, which might be interesting is the RF loop through.
> > Is it enabled by default or even switchable?
> > 
> > The latter would be reason enough to create a new tuner type I think.
> > 
> > Just some quick ideas. (ivtv will bounce me, not subscribed)
> > 
> > Cheers,
> > Hermann
> 
> 

