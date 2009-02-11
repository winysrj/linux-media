Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:52663 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbZBKB33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 20:29:29 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, V4L <video4linux-list@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Borke <joshborke@gmail.com>, David Lonie <loniedavid@gmail.com>,
	David Engel <david@istwok.net>, linux-media@vger.kernel.org
In-Reply-To: <20090210041925.6190e59f@pedra.chehab.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	 <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
	 <20090202235820.GA9781@opus.istwok.net> <4987DE4E.2090902@rogers.com>
	 <20090209004343.5533e7c4@caramujo.chehab.org>
	 <1234226235.2790.27.camel@pc10.localdom.local>
	 <1234227277.3932.4.camel@pc10.localdom.local>
	 <1234229460.3932.27.camel@pc10.localdom.local>
	 <20090210003520.14426415@pedra.chehab.org>
	 <1234235643.2682.16.camel@pc10.localdom.local>
	 <20090210041925.6190e59f@pedra.chehab.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 02:30:29 +0100
Message-Id: <1234315829.4463.64.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 10.02.2009, 04:19 -0200 schrieb Mauro Carvalho Chehab:
> On Tue, 10 Feb 2009 04:14:03 +0100
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > 
> > Am Dienstag, den 10.02.2009, 00:35 -0200 schrieb Mauro Carvalho Chehab:
> > > On Tue, 10 Feb 2009 02:31:00 +0100
> > > hermann pitton <hermann-pitton@arcor.de> wrote:
> > > 
> > > > > > Mauro, I know you are waiting for CityK, but I can report so far that I
> > > > > > never did see that black screen going away by adjusting the controls and
> > > > > > never had that black screen.
> > > > > > 
> > > > > > Tvtime and xawtv were always working under my conditions so far.
> > > 
> > > Good to know.
> > > 
> > > > > > The very old troubles, like tda9887 not present after boot on my md7134
> > > > > > devices with FMD1216ME MK3 hybrid, and the even unrelated issue with the
> > > > > > tda10046 not properly controlled anymore after suspend/resume,
> > > > > > are unchanged on your current saa7134 attempt, but also no new issues
> > > > > > visible so far.
> > > 
> > > Ok, let's go by parts:
> > > 
> > > 1) We need to know the sequence that enables tda9887 on md7134/fmd1216me, in
> > > order to fix it. If someone has fmd1216me, please write me in priv or help us
> > > to fix the code for it.
> > > 
> > > 2) I bet that the issue with tda10046 is related to firmware loading. I made
> > > some tests with a TV @nyware cardbus device that has a tda10046 + tda8290/tda8975.
> > > 
> > > What happens is that this device supports two type of firmware loads. The first
> > > one requires an i2c eeprom with the firmware inside. The driver just writes
> > > 0x04 at register 0x07 and waits for some time. The hardware does the firmware load.
> > > 
> > > On the second mode, firmware bytes are transferred from the driver into the tda10046 memory.
> > > 
> > > At the tests I made here, on both modes, the i2c bus can't have any other
> > > traffic during the firmware load. Otherwise, an invalid firmware will be loaded
> > > and tda10046 will hangup.
> > > 
> > > I've started to implement some locks at saa7134 driver (on my saa7134
> > > experimental tree), but it is not finished yet. I didn't touch at the sleep code yet.
> > > 
> > > > > > 
> > > > > 
> > > > > BTW, just to remember.
> > > > > 
> > > > > Tvtime with signal detection on shows a blue screen without signal.
> > > > > With signal detection off, just good old snow.
> > > 
> > > So, the tda9887 or the PLL are configured wrongly.
> > > 
> > > > > The tda8275/75a shows a black screen without having lock, not even snow,
> > > > > if it should be related.
> > > > 
> > > > Sorry, to add one more about "black" screens :)
> > > > 
> > > > Without the tda9887 loaded, the FMD1216ME MK3 hybrid also shows a black
> > > > screen, but it is slightly different from the fully black screen of the
> > > > tda8275, which is in fact an overlay like the blue screen on tvtime. It
> > > > has some white points visible and on some channels even _very_ decent
> > > > ghosting of TV.
> > > 
> > > Probably, tda9887 is configured for STD/M, instead of STD/BG. Fixing tda9887
> > > will also fix this issue.
> > > 
> > > > The status of the tda9885/6/7 on the TUV1236D is still not clear to me,
> > > > until I see debug enabled on it for switching TV standards and just
> > > > nothing ever changes.
> > > 
> > > Sorry but I didn't understand what you're meaning with your TUV1236D-based device.
> > 
> > Just for that one for now, I'll try on the other subjects later.
> > 
> > I don't have any TUV1236D based device, but CityK and maybe Michael on
> > the Kworld _ATSC_ ! 110/15.
> > 
> > >From the photo provided by CityK, there is clearly a 24pin Philips
> > device within the IF section of this tuner, which I guess is a tda9885
> > NTSC only and nothing else.
> > 
> > As mentioned before, they can be strapped on one pin to be NTSC
> > (System-M) only without needing _any_ i2c programming according to the
> > data sheets.
> > 
> > With the reports so far, after years, either the tda9887 module is just
> > fake loaded, even that fails, or nothing ever happens, or something
> > happens on i2c we don't have clear.
> > 
> > So I would like to see if there is ever valid i2c traffic to that
> > tda988x device on that tuner or never...
> 
> Maybe we don't need any extra programming for tda9885, but it won't hurt to
> reprogram it to the right state. 

Mauro, for the record, it is about chapter 8.16 on page 13 in the
current tda9885/6 datasheet and the voltage delay in that case on page
14. It is the same for tda9887.
http://www.nxp.com/#/pip/pip=[pip=TDA9885_TDA9886_3]|pp=[t=pip,i=TDA9885_TDA9886_3]

Here is a link to the early discussions by Curt and CityK.
http://lists.zerezo.com/video4linux/msg09088.html

This has also the link to the high resolution photograph of the open
tuner. We see a video IF and sound IF SAW filter and can assume it has
OSS sound. No tda7040 radio stereo separator is visible so far.
(on your CTX925 it is too)
http://www.nxp.com/#/pip/pip=[pip=TDA7040T_CNV_2]|pp=[t=pip,i=TDA7040T_CNV_2]

The third SAW filter is for ATSC.

Let's keep in mind, the tda9887 on the md7134 devices with FMD1216ME MK3
hybrid it not loaded and uninitialized after boot and it needs a driver
reload.

Cheers,
Hermann




