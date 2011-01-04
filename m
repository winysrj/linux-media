Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25946 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab1ADNKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 08:10:00 -0500
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <201101040810.39092.hverkuil@xs4all.nl>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <201101040810.39092.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 08:09:51 -0500
Message-ID: <1294146591.2107.2.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 2011-01-04 at 08:10 +0100, Hans Verkuil wrote:
> On Monday, January 03, 2011 23:34:16 Andy Walls wrote:
> > On Sun, 2011-01-02 at 23:00 -0500, Eric Sharkey wrote:
> > > On Fri, Dec 31, 2010 at 7:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > > > Mauro,
> > > >
> > > > Please revert at least the wm8775.c portion of commit
> > > > fcb9757333df37cf4a7feccef7ef6f5300643864:
> > > >
> > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864
> > > >
> > > > It completely trashes baseband line-in audio for PVR-150 cards, and
> > > > likely does the same for any other ivtv card that has a WM8775 chip.
> > > 
> > > Confirmed.  I manually rolled back most of the changes in that commit
> > > for wm8775.c, leaving all other files alone, and the audio is now
> > > working correctly for me.  I haven't yet narrowed it down to exactly
> > > which changes in that file cause the problem.  I'll try and do that
> > > tomorrow if I have time.
> > 
> > This might help then:
> > 
> > 	http://dl.ivtvdriver.org/datasheets/audio/WM8775.pdf
> > 
> > I don't have time to look, but I'm hoping it is just the initialization
> > in wm8775_probe().
> > 
> > Without both a PVR-150 card and a Nova-S-plus DVB-S with which to test
> > you are unlikely to get an initialization that works for both the Nova-S
> > Plus and PVR-150.  Even if you did, such a configuration would be
> > "fragile" in that it will be hard to tweak in the future for one card
> > without breaking the other.  (Code reuse doesn't work out too well for
> > setting up hardware parameters.)
> > 
> > The fix will probably have to use some context sensitive initialization
> > in wm8775_probe(): "Am I being called by ivtv for a PVR-150 or cx88 for
> > a Nova-S plus?"
> > 
> > Which probably means:
> > 
> > 1. adding a ".s_config" method to the "wm8775_core_ops"
> > See:
> > http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/v4l2-framework.txt;h=f22f35c271f38d34fda0c19d8942b536e2fc95d9;hb=staging/for_v2.6.38#l206
> > http://git.linuxtv.org/media_tree.git?a=blob;f=include/media/v4l2-subdev.h;h=b0316a7cf08d21f2ac68f1dc452894441948c155;hb=staging/for_v2.6.38#l109
> > http://git.linuxtv.org/media_tree.git?a=blob;f=include/media/v4l2-subdev.h;h=b0316a7cf08d21f2ac68f1dc452894441948c155;hb=staging/for_v2.6.38#l141
> 
> Don't use .s_config! That will be removed soon.
> 
> Use platform_data and v4l2_i2c_new_subdev_board instead.

Gah! Sorry.

I knew that .init had been deprecated.  The comments in v4l2_subdev.h
indicate that .init is deprecated, but do not do the same for .s_config.

Regards,
Andy


