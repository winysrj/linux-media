Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2G0VgtS009270
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 20:31:42 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2G0VAR3020657
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 20:31:10 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
In-Reply-To: <47DC6303.2040802@rogers.com>
References: <47DC4331.7040100@rogers.com>
	<1205622683.4814.13.camel@pc08.localdom.local>
	<47DC6303.2040802@rogers.com>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 01:22:51 +0100
Message-Id: <1205626971.5479.10.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: ATI "HDTV Wonder" audio
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

Am Samstag, den 15.03.2008, 20:00 -0400 schrieb CityK:
> Hi Hermann
> 
> hermann pitton wrote:
> > for sure blame me not being up to date on this and I am not even sure,
> > what it is all about. 
> >
> > For example, since the using of cx88-alsa seems to be intended, analog
> > NTSC with picture, but no sound from tuner is reported (?) 
> >
> > Or like you pointed now, likely analog video from an external input and
> > then missing the specific ADC support for external analog audio input?
> >
> > ...
> >
> > Is it at all about analog NTSC-M video working from the tuner?
> > But no sound, hrmm ;)
> >   
> Oops ... umm, its not that I  failed to take broadcast audio into 
> consideration (as I wasn't sure if Bill was talking about broadcast 
> audio too), its just that I was hell bent on talking about the external 
> audio problem :P 
> 
> So now, for a more complete picture:
> IIRC, the HDTV Wonder lacks any sort of audio out (via either an 
> internal loop back cable to the sound card or similarly an external out 
> on the riser).  Therefore, while the cx88 will perform ADC for analog 
> broadcast audio, you would indeed need to use cx88-alsa, as quite 
> correctly alluded to by Hermann.  In the more limited case (which I had 
> wrongly only took into consideration) one will be unable to receive 
> external audio for the reasons I specified -- i.e. cx88 doesn't do ADC 
> for external audio; need a driver for the AK5355 for that, and then 
> correctly code for the GPIO pins for the cx88 as used on the HDTV Wonder.
> 
> > Without looking any deeper back, but slightly wondering, why has the
> > TUV1236D the TDA9887_PRESENT on the saa7134 cards, but not on this one?
> 
> Just a mistake on my part lead to the confusion.  TDA9887 present in all 
> cases of TUV1236D.

Had the _pleasure_ to help to get audio on the previous Wonder Pro, so
first thought it was about this one with the broken tda9887 config
options from the cards recently, but is not and on the hdtv wonder the
entry is missing.

	[CX88_BOARD_ATI_HDTVWONDER] = {
		.name           = "ATI HDTV Wonder",
		.tuner_type     = TUNER_PHILIPS_TUV1236D,
		.radio_type     = UNSET,
		.tuner_addr	= ADDR_UNSET,
		.radio_addr	= ADDR_UNSET,
		.input          = {{
			.type   = CX88_VMUX_TELEVISION,
			.vmux   = 0,
			.gpio0  = 0x00000ff7,
			.gpio1  = 0x000000ff,
			.gpio2  = 0x00000001,
			.gpio3  = 0x00000000,
		},{
			.type   = CX88_VMUX_COMPOSITE1,
			.vmux   = 1,
			.gpio0  = 0x00000ffe,
			.gpio1  = 0x000000ff,
			.gpio2  = 0x00000001,
			.gpio3  = 0x00000000,
		},{
			.type   = CX88_VMUX_SVIDEO,
			.vmux   = 2,
			.gpio0  = 0x00000ffe,
			.gpio1  = 0x000000ff,
			.gpio2  = 0x00000001,
			.gpio3  = 0x00000000,
		}},
		.mpeg           = CX88_MPEG_DVB,
	},

However, Mike could have it in tuner-types. But is not there.

/* ------------ TUNER_PHILIPS_TUV1236D - Philips ATSC ------------ */

static struct tuner_range tuner_tuv1236d_ntsc_ranges[] = {
	{ 16 * 157.25 /*MHz*/, 0xce, 0x01, },
	{ 16 * 454.00 /*MHz*/, 0xce, 0x02, },
	{ 16 * 999.99        , 0xce, 0x04, },
};

static struct tuner_range tuner_tuv1236d_atsc_ranges[] = {
	{ 16 * 157.25 /*MHz*/, 0xc6, 0x41, },
	{ 16 * 454.00 /*MHz*/, 0xc6, 0x42, },
	{ 16 * 999.99        , 0xc6, 0x44, },
};

static struct tuner_params tuner_tuv1236d_params[] = {
	{
		.type   = TUNER_PARAM_TYPE_NTSC,
		.ranges = tuner_tuv1236d_ntsc_ranges,
		.count  = ARRAY_SIZE(tuner_tuv1236d_ntsc_ranges),
	},
	{
		.type   = TUNER_PARAM_TYPE_DIGITAL,
		.ranges = tuner_tuv1236d_atsc_ranges,
		.count  = ARRAY_SIZE(tuner_tuv1236d_atsc_ranges),
		.iffreq = 16 * 44.00,
	},
};

As said, not in details yet, but seems there is some pain.

The tda9887 can be configured for NTSC, and only for that, to be
hardwired without needing any i2c programming, but then I would expect
not only "picture", but also functional audio.

We need better reports with debug options enabled I guess.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
