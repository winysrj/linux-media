Return-path: <mchehab@pedra>
Received: from smtp22.services.sfr.fr ([93.17.128.13]:20222 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1BCMwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 07:52:07 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2217.sfr.fr (SMTP Server) with ESMTP id 5C8A5700009F
	for <linux-media@vger.kernel.org>; Thu,  3 Feb 2011 13:52:05 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (22.242.194-77.rev.gaoland.net [77.194.242.22])
	by msfrf2217.sfr.fr (SMTP Server) with SMTP id 17D9A7000088
	for <linux-media@vger.kernel.org>; Thu,  3 Feb 2011 13:52:04 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.194.242.22] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Thu, 03 Feb 2011 13:51:47 +0100
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Eric Sharkey <eric@lisaneric.org>, auric <auric@aanet.com.au>,
	David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <4D482B93.7010602@redhat.com>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost>
	 <1294512347.16924.28.camel@gagarin>  <4D482B93.7010602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 13:51:46 +0100
Message-ID: <1296737506.11582.14.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-01 at 13:49 -0200, Mauro Carvalho Chehab wrote:
> Hi Lawrence,
> 
> Em 08-01-2011 16:45, Lawrence Rust escreveu:
> > Thanks for the info on the PVR-150.  It largely confirmed what I had
> > surmised - that the two cards disagree about serial audio data format.
> > Before my patch, the wm8775 was programmed for Philips mode but the
> > CX25843 on the PVR-150 is setup for Sony I2S mode!!  On the Nova-S, the
> > cx23883 is setup (in cx88-tvaudio.c) for Philips mode.  The patch
> > changed the wm8775 to Sony I2S mode because the existing setup gave
> > noise, indicative of a mismatch.
> > 
> > It is my belief that either the wm8775 datasheet is wrong or there are
> > inverters on the SCLK lines between the wm8775 and cx25843/23883. It is
> > also plausible that Conexant have it wrong and both their datasheets are
> > wrong.
> > 
> > Anyway, I have revised the patch (attached) so that the wm8775 is kept
> > in Philips mode (to please the PVR-150) and the cx23883 on the Nove-S is
> > now switched to Sony I2S mode (like the PVR-150) and this works fine.
> > The change is trivial, just 2 lines, so they're shouldn't be any other
> > consequences.  However, could this affect any other cards? 
> > 
> > NB I have only tested this patch on my Nova-S, no other.
> 
> As it was pointed, your patch affects other boards with wm8775. In order
> to avoid it, you need to use platform_data to pass nova_s specific parameters,
> and be sure that other boards won't be affected by your changes.
> 
> As you might not be able to see how this should be written, I modified your
> patch in a way that, hopefully, it won't affect PVR-150. Please test.

Many thanks for doing this.  I appreciate the guidance and effort.  I'll
test it and report back this weekend.

-- Lawrence


