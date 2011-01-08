Return-path: <mchehab@pedra>
Received: from smtp23.services.sfr.fr ([93.17.128.21]:35204 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1AHMMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:12:23 -0500
Received: from smtp23.services.sfr.fr (msfrf2306 [10.18.27.20])
	by msfrf2310.sfr.fr (SMTP Server) with ESMTP id 7E29170002AE
	for <linux-media@vger.kernel.org>; Sat,  8 Jan 2011 13:12:22 +0100 (CET)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2306.sfr.fr (SMTP Server) with ESMTP id 4CC197000091
	for <linux-media@vger.kernel.org>; Sat,  8 Jan 2011 13:09:21 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (163.247.194-77.rev.gaoland.net [77.194.247.163])
	by msfrf2306.sfr.fr (SMTP Server) with SMTP id 01AE1700008C
	for <linux-media@vger.kernel.org>; Sat,  8 Jan 2011 13:09:20 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.194.247.163] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 13:09:10 +0100
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294094056.10094.41.camel@morgan.silverblock.net>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Jan 2011 13:09:10 +0100
Message-ID: <1294488550.9475.20.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-03 at 17:34 -0500, Andy Walls wrote:
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

Oh dear, you leave the ranch for 5 minutes to a place without email and
all hell breaks loose.  Didn't anyone think that New Year is a time for
holidays?

So, for a minor niggle, which is trivially sorted, you pull almost the
whole patch leaving the only bit that causes problems for the Nova-S
(for which the patch was intended).  The remnant,
drivers/media/video/cx88/cx88-cards.c line 970, adds wm8775 baseband
audio-in which is horribly distorted without the patch.  So I suggest it
too is removed.

Now, if someone can direct me to a full hardware description for the
PVR-150 and datasheets for the components connected to the wm8775 then
I'll endeavour to provide a solution compatible with both.  If anyone
can loan me a PVR-150 then so much the better, but it's not essential if
the full docs are available.

-- Lawrence


