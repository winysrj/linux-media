Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1224 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1ADHKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 02:10:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit fcb9757333df37cf4a7feccef7ef6f5300643864
Date: Tue, 4 Jan 2011 08:10:38 +0100
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org,
	ivtv-devel@ivtvdriver.org
References: <1293843343.7510.23.camel@localhost> <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com> <1294094056.10094.41.camel@morgan.silverblock.net>
In-Reply-To: <1294094056.10094.41.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101040810.39092.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, January 03, 2011 23:34:16 Andy Walls wrote:
> On Sun, 2011-01-02 at 23:00 -0500, Eric Sharkey wrote:
> > On Fri, Dec 31, 2010 at 7:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > > Mauro,
> > >
> > > Please revert at least the wm8775.c portion of commit
> > > fcb9757333df37cf4a7feccef7ef6f5300643864:
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864
> > >
> > > It completely trashes baseband line-in audio for PVR-150 cards, and
> > > likely does the same for any other ivtv card that has a WM8775 chip.
> > 
> > Confirmed.  I manually rolled back most of the changes in that commit
> > for wm8775.c, leaving all other files alone, and the audio is now
> > working correctly for me.  I haven't yet narrowed it down to exactly
> > which changes in that file cause the problem.  I'll try and do that
> > tomorrow if I have time.
> 
> This might help then:
> 
> 	http://dl.ivtvdriver.org/datasheets/audio/WM8775.pdf
> 
> I don't have time to look, but I'm hoping it is just the initialization
> in wm8775_probe().
> 
> Without both a PVR-150 card and a Nova-S-plus DVB-S with which to test
> you are unlikely to get an initialization that works for both the Nova-S
> Plus and PVR-150.  Even if you did, such a configuration would be
> "fragile" in that it will be hard to tweak in the future for one card
> without breaking the other.  (Code reuse doesn't work out too well for
> setting up hardware parameters.)
> 
> The fix will probably have to use some context sensitive initialization
> in wm8775_probe(): "Am I being called by ivtv for a PVR-150 or cx88 for
> a Nova-S plus?"
> 
> Which probably means:
> 
> 1. adding a ".s_config" method to the "wm8775_core_ops"
> See:
> http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/v4l2-framework.txt;h=f22f35c271f38d34fda0c19d8942b536e2fc95d9;hb=staging/for_v2.6.38#l206
> http://git.linuxtv.org/media_tree.git?a=blob;f=include/media/v4l2-subdev.h;h=b0316a7cf08d21f2ac68f1dc452894441948c155;hb=staging/for_v2.6.38#l109
> http://git.linuxtv.org/media_tree.git?a=blob;f=include/media/v4l2-subdev.h;h=b0316a7cf08d21f2ac68f1dc452894441948c155;hb=staging/for_v2.6.38#l141

Don't use .s_config! That will be removed soon.

Use platform_data and v4l2_i2c_new_subdev_board instead.

Regards,

	Hans

> 
> 
> 2. developing a "struct wm8775_platform_data" type that can be used to
> indicate the needs for the Nova-S versus the PVR-150 and any other
> legacy boards that use the wm8775 module
> 
> That structure should probably be defined here:
> http://git.linuxtv.org/media_tree.git?a=blob;f=include/media/wm8775.h;h=a1c4d417dfa205e8d5c2cf1d4f9d6bbd7a6ec419;hb=staging/for_v2.6.38
> 
> 
> 3. writing the corresponding "wm8775_s_config" function in wm8775.c to
> setup the WM8775 based on the arguments passed in the "platform_data".
> Note that this function may get called at least once initially by the
> v4l2 infrastructure with "irq" set to 0 and "platform_data" set to NULL.
> 
> See:
> http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/v4l2-framework.txt;h=f22f35c271f38d34fda0c19d8942b536e2fc95d9;hb=staging/for_v2.6.38#l399
> 
> 4. Fixing the wm8775_probe() function to do something sensible, knowing
> that the .s_config method may get called once by the infrastructure,
> and/or once again by the cx88 driver or the ivtv driver.
> 
> 5. Searching through the video drivers to see if any other drivers may
> use the wm8775 module, and validating that your changes won't break
> them.
> 
> All I see with a quick grep is cx88, ivtv, and pvrusb2
> 
> 6. Testing with real hardware....
> 
> 
> Regards,
> Andy
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
