Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38320 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbaI2CjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:39:03 -0400
Date: Sun, 28 Sep 2014 23:38:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140928233853.72a1d106@recife.lan>
In-Reply-To: <20140928115405.GA30490@linuxtv.org>
References: <20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<20140926152228.GA21876@linuxtv.org>
	<20140926124309.558c8682@recife.lan>
	<20140928105540.GA28748@linuxtv.org>
	<20140928081211.4b26aa18@recife.lan>
	<20140928115405.GA30490@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Sep 2014 13:54:05 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Sun, Sep 28, 2014 at 08:12:11AM -0300, Mauro Carvalho Chehab wrote:
> > Em Sun, 28 Sep 2014 12:55:40 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> > 
> > > I tried again both with and without the patch.  The issue above
> > > odesn't reproduce, but after hibernate it fails to tune
> > > (while it works after suspend-to-ram).  Restarting dvbv5-zap
> > > does not fix it.  All I get is:
> > > 
> > > [  500.299216] drxk: Error -22 on dvbt_sc_command
> > > [  500.301012] drxk: Error -22 on set_dvbt
> > > [  500.301967] drxk: Error -22 on start
> > 
> > Just to be 100% sure if I understood well: you're having exactly
> > the same behavior with and without my patch, right?
> 
> Yes, no observable difference in my tests.
> 
> > I'll see if I can work on another patch for you today. If not,
> > I won't be able to touch on it until the end of the week, as I'm
> > traveling next week.
> 
> no need to hurry
> 
Johannes,

Resuming from suspend to disk is really hard with em28xx/drx-k. 
Not sure why, but the drx-k doesn't let the firmware to be reloaded
at resume. Once the firmware is loaded, any trial to reload it makes
the device to misfunction.

Also, re-sending the init sequence that it is there at em28xx also
makes it unstable.

I suspect that a certain specific shutdown sequence would be needed
for it to work, but I was unable to reproduce it.

Perhaps the issue is related to either some I2C gateway at the analog
demod (we don't have a driver for it) or some GPIO sequence is needed
to reset it.

So, I'm giving up for it for today. I may give a second trial if I
won't be side-tracked by some other issue.

Regards,
Mauro
