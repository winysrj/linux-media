Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:53127 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530AbZINX4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 19:56:01 -0400
Subject: saa7134 - radio broken for v4l1 apps - was - Re: Problems with
	Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Avl Jawrowski <avljawrowski@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <200909140824.17591.hverkuil@xs4all.nl>
References: <loom.20090718T135733-267@post.gmane.org>
	 <loom.20090913T115105-855@post.gmane.org>
	 <1252881736.4318.48.camel@pc07.localdom.local>
	 <200909140824.17591.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Sep 2009 01:50:32 +0200
Message-Id: <1252972232.3250.43.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 14.09.2009, 08:24 +0200 schrieb Hans Verkuil:
> On Monday 14 September 2009 00:42:16 hermann pitton wrote:
> > Hi,
> > 
> > Am Sonntag, den 13.09.2009, 12:02 +0000 schrieb Avl Jawrowski:
> > > Hi,
> > > 
> > > hermann pitton <hermann-pitton <at> arcor.de> writes:
> > > 
[snip]
> > 
> > > > The only other issue I'm aware of is that radio is broken since guessed
> > > > 8 weeks on my tuners, only realized when testing on enabling external
> > > > active antenna voltage for DVB-T on a/some 310i.
> > > > 
> > > > Might be anything, hm, hopefully I should not have caused it ;)
> > > 
> > > The radio works for me, even if there's much noise (I don't usually use it).
> > > I'm using the internal audio cable.
> > 
> > The radio is broken for all tuners, you must be on older stuff.
> > 
> > I finally found the time to do the mercurial bisect today.
> > 
> > It is broken since Hans' changeset 12429 on seventh August.
> 
> What are the symptoms? What application do you use to test the radio?
> I don't immediately see why that changeset would break radio support as
> it only affects VIDIOC_G_STD and VIDIOC_G_PARM.
> 
> Regards,
> 
> 	Hans

Hans, it are indeed only the v4l1 apps like radio, qtradio, gnomeradio
and fm from fmtools. Avl is right, mplayer does still work and also
kradio.

So the trouble happens in the v4l1 compat layer.

Symptoms are, that you just have loud static noise and tuning has not
any effect. Also no signal and/or stereo detection.

"fm" gives now "ioctl VIDIOCGTUNER: Invalid argument".

qtradio
Using v4l
Video4Linux detected
87 - 108
SIGNAL = 0
SIGNAL = 0
VIDIOCGAUDIO: Ungültiger Dateideskriptor
VIDIOCSAUDIO: Ungültiger Dateideskriptor
VIDIOCGAUDIO: Ungültiger Dateideskriptor
VIDIOCSAUDIO: Ungültiger Dateideskriptor

Tested on old style simple tuners, some tda9887 stuff and
tda8275a/tda8290/saa7131e, on both x86 and x86_64, with some 2.6.29 and
some 2.6.30.

Cheers,
Hermann


