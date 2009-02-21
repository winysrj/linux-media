Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4641 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZBUMpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:45:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Sat, 21 Feb 2009 13:45:40 +0100
Cc: Jean Delvare <khali@linux-fr.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <200902210828.50666.hverkuil@xs4all.nl> <20090221085801.5954e00b@pedra.chehab.org>
In-Reply-To: <20090221085801.5954e00b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211345.40411.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 February 2009 12:58:01 Mauro Carvalho Chehab wrote:
> On Sat, 21 Feb 2009 08:28:50 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Saturday 21 February 2009 03:13:50 Mauro Carvalho Chehab wrote:
> > > On Sat, 21 Feb 2009 02:12:53 +0100
> > >
> > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > I think that maybe we'll need some legacy-like support for bttv
> > > > > and cx88, since there are some boards that relies on the old i2c
> > > > > method to work. On those boards (like cx88 Pixelview), the same
> > > > > board model (and PCB revision) may or may not have a separate
> > > > > audio decoder. On those devices that have an audio decoder, the
> > > > > widely used solution is to load tvaudio module and let it bind at
> > > > > the i2c bus, on such cases.
> > > >
> > > > That's what the i2c_new_probed_device() call is for (called through
> > > > v4l2_i2c_new_probed_subdev). You pass a list of i2c addresses that
> > > > the i2c core will probe for you: but this comes from the adapter
> > > > driver, not from the i2c module.
> > >
> > > This is a problem. The current procedure used by end users will stop
> > > working. It is a little worse: as the adapter driver has no means to
> > > know that some device could need tvaudio or other similar devices, we
> > > would need some hacking to allow the user to pass a parameter to the
> > > driver in order to test/load such drivers, since there's no
> > > documentation of when such things are needed.
> >
> > No big deal. Yes, we have to add module options for that, and in the
> > parameter description we can point to this list with the request that
> > the fact that you have to set this 'autoload_tvaudio' module option is
> > passed on to us so we can fix our card definitions. Easy to implement
> > and we hopefully get feedback about this.
>
> I think you're underestimating the complexity here.
>
> By adding such options, the effect for a normal user is that they'll
> complain that "after upgrading my distro from FOO to BAR, my board
> broke". Also, since we have 14 different audio modules, adding 14 new
> autoload_foo, this seems too much hacking.
>
> If we take a look on the supported devices, almost all have their own
> (sometimes limited) audio processor. This is not the case for
> bt848/bt878. The conversion of this driver will probably be harder than
> the conversion of the other drivers, since it requires more ancillary
> devices than the others and since the developers have only a very small
> subset of the amount of supported cards. Also, this chip has more than 12
> years of life. It were used with almost all different generations of
> audio (and video, video enhancer, videotext) decoder chips.
>
> On bttv, we can clearly see that several devices rely on the manual
> loading method. For example, this is what we have on bttv Kconfig:
>
>         select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
>         select VIDEO_TVAUDIO if VIDEO_HELPER_CHIPS_AUTO
>         select VIDEO_TDA7432 if VIDEO_HELPER_CHIPS_AUTO
>         select VIDEO_TDA9875 if VIDEO_HELPER_CHIPS_AUTO
>
> This brings the false impression that only 4 audio modules would be
> needed. However, if you take a look on bttv-audio-hook.c, we can see that
> other audio modules are needed, due to a few comments there, like:
>
> <snip>
>  * Looks like it's needed only for the "tvphone", the "tvphone 98"
>  * handles this with a tda9840
> </snip>
>
> tda9840 support is provided by tda9840.ko, but there's no
> request_module() or any other reference (except for the above comment) to
> it at bttv driver. I believe that this is not an isolated case.

The tda9840 is handled by tvaudio. Other than tda9875 and msp3400 all these 
audio variants are all handled by that module. tvaudio was developed at the 
time as a sort of 'catch-all' module and is currently only used by bttv.

If you look at the code you'll se that tda9840.c can only be used with 
saa7146, ditto tea6420.c. So these give no conflicts.

> I suspect that there are other cases where no doc is provided on kernel
> and the only source of information is provided by googling at the net or
> by taking a look on each card at bttv-gallery to see what chips are
> inside of each bttv board.
>
> So, at least for bttv, IMO, we should: do an i2c scan, on bttv driver,
> for tvaudio and the other audio modules. If found, then we load the
> proper driver.
>
> We'll still have another problem: There are conflicting addresses. For
> example, address 0xb0 (8bit notation) is used on tvaudio for tda9874 and
> on tda9875. I have no idea what boards need tvaudio and what boards need
> tda9875 module. So, simply probing for 0xb0 won't be enough.

Luckily the two chips can be told apart from one another. Suggestion: move 
the support for tda9874 from tvaudio.c to tda9875.c and let that one handle 
both. They are very similar and that shouldn't be difficult. That will 
solve this conflict in an elegant manner.

I see one more conflict between msp3400 and tea6300. It should be possible 
to implement i2c detect support in msp3400 since that chip can detect what 
chip it is, and if no msp3400 is found after all we fall back to tvaudio.

> During the conversion of bttv to V4L2, I've mapped the i2c addresses of
> the audio modules I found at:
>
> 	linux/include/media/i2c-addr.h
>
> For cx88, the issue is simpler, since cx88 has its own audio decoder. I
> dunno why some PV boards have a separate audio processor[1]. Anyway, for
> cx88, we can add the autodetection code just for that device, and just
> for tvaudio.

Are you sure cx88 requires that tvaudio is loaded for some cards? There is 
no mention about tvaudio and cx88 anywhere, neither source nor 
documentation, nor google for that matter.

> for the other drivers, I suspect we don't have such issues, since the
> audio decoder became part of the design of the modern chips[2].
>
> > Not converting is not an option as the
> > autoprobe behavior will be removed by Jean (and good riddance). This is
> > unrelated with backwards compatibility issues, this is a fact of life.
>
> Before removing, we need to solve the above cases to avoid regression on
> the existing drivers.
>
> > > I've seen models of PV ultra with Philips 1236 tuners, with Tena
> > > tuners, with TI-based tuners, with tvaudio and without tvaudio chips,
> > > with tea5767, without tea5767... There's no external indication about
> > > what's inside the device. All of them are branded with the same name
> > > and the same model number.
> >
> > If you know it is this card, then you can try to probe for all of these
> > devices.
>
> In this specific case, I know, since I own one of those PV boards, and
> I'm the one that added support for it. So, sometimes people talk with me
> in priv about this specific device. I don't have any list of what other
> devices need this kind of approach.
>
> > The good think about the new approach is that you can do these
> > probes safely since they will only happen on the i2c adapter of the
> > card in question, so you can make sure that no eeprom or other
> > important devices are being probed that shouldn't have. In other words:
> > you get deterministic behavior and control over what you are doing.
>
> With the current way, it works fine, since:
> 	- tea5767 is auto-detected;
> 	- different tuners are passed via modprobe option by the user;
> 	- tvaudio is loaded via modprobe.
>
> For sure for this board, we can automate the autoload of tvaudio, for the
> ones that need it. This will be a good improvement.
>
> We'll still need to use the modprobe options for tuner (and for board,
> since it uses the generic Conexant PCI ID's).
>
> > > IMO, we should first focus on removing the legacy code. Even on
> > > v4l2-common.c, we have some tricks due to legacy support. After
> > > removing the legacy code, I suspect that the code will be simpler to
> > > understand the code and to find other ways to preserve compatibility
> > > if needed. I suspect that just removing 2.6.22 or lower support is
> > > not enough to remove v4l2-i2c-drv.h.
> >
> > OK, once more: there are two types of legacy code: one is that drivers
> > have to be switched to use the new i2c API. That's what I've been
> > working on all these months since Plumbers 2008. When all drivers that
> > use i2c modules have been converted, then we can drop
> > v4l2-i2c-drv-legacy.h and Jean can drop the autoprobing code in the i2c
> > core.
>
> This will be great, provided that we can do the autoprobing for the audio
> modules as required by a few drivers like bttv.

You cannot expect that a user can modprobe an i2c driver and it will 
magically appear. That's going away. You can change the driver so that it 
will load the module and let it probe for a series of i2c addresses. There 
is also an option to let the i2c driver do additional checks (Jean knows 
more about the details).

> > The second type of legacy code is that if we want to support kernels
> > older than 2.6.22, then we STILL have to support the old autoprobing
> > model. That's what v4l2-i2c-drv.h and v4l2_i2c_legacy_find_client() and
> > v4l2_i2c_attach() in v4l2-common.c are for. And there is no easy
> > solution for this.
>
> The easiest solution would be to just add a large series of #ifs (sigh!).
> I'm sure we'll find other ways if we still need it, by the time we finish
> porting all drivers to the new i2c methods.
>
> > And yes, when support for kernels pre-2.6.22 is dropped, then all of
> > this can disappear. There are still a few #ifs, but those are for the
> > more 'normal' datastructure changes that happened in 2.6.26. In my
> > reply to this thread on Wednesday I showed how an i2c module would look
> > if we can drop support for these older kernels. Perfectly acceptable
> > IMHO.
>
> On that code, you've considered that all the legacy code were removed and
> that we dropped support for kernels older than 2.6.26.

??? No, the checks for kernel 2.6.26 are still there in the code. I do not 
advocate dropping support for kernels < 2.6.26.

> Before removing the legacy code and support between 2.6.22 and 2.6.26,
> you'll need more compat bits.
>
> > > Eventually, things could be easier if we found better model. For
> > > example, a configure script could seek for a particular string on a
> > > kernel header. If not found, it may apply a patch, or run a parser to
> > > replace one code into another.
> > >
> > > This way, the development code won't have any #if's or compat code.
> > > I'm afraid that just using patches may also bring another range of
> > > troubles of needing to periodically maintain the backports. On the
> > > other hand, a syntax/semantic parser would be much more complex to
> > > develop.
> >
> > I saw an article on lwn about the Coccinelle tool:
> > http://lwn.net/Articles/315069/
> >
> > I very much doubt this will be any help with this i2c problem, but for
> > other transformations it may very well be useful. Unfortunately it is
> > written in OCaml, in the best tradition of universities of developing a
> > great idea but implementing it in an obscure programming language :-(
>
> Being dependent of OCaml practically avoids its usage by normal users.
> Maybe we could try to use a lexical analyser like flex (that it is more
> commonly installed on distros, since several packages require it on their
> autoconf environments to compile some code), or see if there are some
> other tools that we could maybe bind together with a backport tarball.
>
> Yet, Coccinelle seems to be very handful. There are several janitor
> contributions using it to re-write code.
>
> [1] In a matter of fact, there are 4 different cx88 chips: cx23880,
> cx23881, cx23882 and cx23883. The difference between those chips is on
> the supported audio standards. Probably they decided to buy just one
> model (to reduce prices), or they got out of stock of the proper cx2388x
> device and had some spare low-cost audio processors. Who knows?

cx2584x does the same: four variants of the same chip.

Regards,

	Hans

> [2] AFAIK, em28xx doesn't have an audio decoder. The first models came
> with a msp3400. The newer ones are using xc3028 with MTS firmware. We
> recently discovered one variant of an existing card that uses an
> unsupported audio decoder.
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
