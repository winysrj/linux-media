Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Arlott <simon@fire.lp0.eu>
In-Reply-To: <24484.simon.1216035632@5ec7c279.invalid>
References: <4878F314.6090608@simon.arlott.org.uk>
	<1215919227.2662.3.camel@pc10.localdom.local>
	<487A4A3D.9040809@simon.arlott.org.uk>
	<1216003710.2649.24.camel@pc10.localdom.local>
	<24484.simon.1216035632@5ec7c279.invalid>
Date: Tue, 15 Jul 2008 04:09:37 +0200
Message-Id: <1216087777.2681.17.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, Linux DVB <linux-dvb@linuxtv.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Am Montag, den 14.07.2008, 12:40 +0100 schrieb Simon Arlott:
> On Mon, July 14, 2008 03:48, hermann pitton wrote:
> >
> > Am Sonntag, den 13.07.2008, 19:32 +0100 schrieb Simon Arlott:
> >> >From cde790c56ffe76f3d0bf6f38d89f4e671a5218c6 Mon Sep 17 00:00:00 2001
> >> From: Simon Arlott <simon@redrum.invalid>
> >> Date: Sun, 13 Jul 2008 19:24:53 +0100
> >> Subject: [PATCH] V4L: Link tuner before saa7134
> >>
> >> If saa7134_init is run before v4l2_i2c_drv_init (tuner),
> >> then saa7134_board_init2 will try to set the tuner type
> >> for devices that don't exist yet. This moves tuner to
> >> before all of the device-specific drivers so that it's
> >> loaded early enough on boot.
> >>
> >> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> >> ---
> >>  drivers/media/video/Makefile |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> >> index ecbbfaa..6b0af12 100644
> >> --- a/drivers/media/video/Makefile
> >> +++ b/drivers/media/video/Makefile
> >> @@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
> >>    obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
> >>  endif
> >>
> >> +obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> >> +
> >>  obj-$(CONFIG_VIDEO_BT848) += bt8xx/
> >>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
> >>  obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
> >> @@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
> >>  obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
> >>  obj-$(CONFIG_TUNER_3036) += tuner-3036.o
> >>
> >> -obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> >> -
> >>  obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
> >>  obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
> >>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
> >> --
> >> 1.5.6.2
> >>
> >
> > Thanks a lot for working on it!
> >
> > I must admit that I have not tested it yet.
> >
> > Remaining issues are.
> >
> > #1 users can't set the tuner type anymore,
> >    but the few cases of tuner detection from eeprom we have should
> >    work again for that price.
> There are already module parameters to do that... they can be used
> from the kernel command line too.

They are broken for what I do say during the last three months and a
build just now tells the same.

> >
> > #2 We still don't have any sufficient HDTV support in the kernel ;)
> >
> DVB-T2? Why is that relevant to this change? My card doesn't even support
> it.

Sorry for abusing the thread a little, I plan some vacations and try to
dump what I have left in mind.

Your card should at least support Australian DVB-T HDTV.

We have some new support for DVB-S in 2.6.26, mostly triple or quad
capable cards, using the dual isl6405 as LNB supply. I would love to see
more feedback here for HDTV usage. (not S2, but for example BBC HD
1080i, works flawlessly somewhere else ...)

> > #0 On 2.6.25, without dedicated TV subnorm selection possible anymore
> >    and known auto detection flaws, fixed now, folks should have
> >    complained about it.
> >
> >    Interestingly nothing like that happened.
> >
> >    What could that mean?
> >
> I'm not sure what you're asking, but not many people appear to compile
> v4l/dvb into the kernel. Lots of function calls still work on
> uninitialised modules so ordering problems can easily be missed.
> 

We have much less testers than previously I believe.

The tda827x still seems not to compile, if tuner customization is not
selected. Likely the isl6405 under frontend customization needs to be
checked too.

Thanks again.

Cheers,
Hermann




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
