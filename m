Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:36228 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0AJHsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 02:48:52 -0500
Subject: Re: Regression - OOPS when connecting devices with IR support
From: Francesco Lavra <francescolavra@interfree.it>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <829197381001091752v239d3514l32969da7e559cf97@mail.gmail.com>
References: <829197381001091752v239d3514l32969da7e559cf97@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 10 Jan 2010 08:49:43 +0100
Message-Id: <1263109783.15453.42.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-01-09 at 20:52 -0500, Devin Heitmueller wrote:
> Hey all,
> 
> This is going to sound like a bit of a silly question.  Has anyone
> tried the current v4l-dvb tip with a device that has IR support?
> 
> I had been working on separate branches for the last few weeks, and
> finally updated to the tip.  I'm seeing the exact same OOPS condition
> for both my em28xx and cx88 based device.
> 
> Did someone break the IR core?  This occurs 100% of the time in my
> environment when loading either cx88 or em28xx based devices that have
> IR support (a stock Ubuntu 9.10 build (2.6.31-17-generic) with the
> current v4l-dvb tip as of tonight.

Yes, the IR core is broken, a patch has been submitted by myself some
time ago (http://patchwork.kernel.org/patch/70126/), but hasn't made it
to v4l-dvb yet.
Regards,
Francesco

