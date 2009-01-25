Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753061AbZAYQaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 11:30:05 -0500
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Sun, 25 Jan 2009 17:29:59 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0901250654l49b419dcw2327b1cfb0ebe0dc@mail.gmail.com>
Message-ID: <20090125162959.86940@gmx.net>
MIME-Version: 1.0
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
	<c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
	<20090125144112.86930@gmx.net>
 <c74595dc0901250654l49b419dcw2327b1cfb0ebe0dc@mail.gmail.com>
Subject: Re: [linux-dvb] How to use scan-s2?
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Sun, Jan 25, 2009 at 4:41 PM, Hans Werner <HWerner4@gmx.de> wrote:
> 
> > > If you have a stb0899 device, don't forget to add "-k 3".
> >
> > Oh. Can someone say what's different about the stb0899 here,
> > and how -k 3 helps ?
> 
> 
> Since I've added it, I'll try to defend it :)
> 
> stb0899 driver (or maybe the chip?) has some buffers inside that are not
> reset between tunnings.
> In that case messages from *previous* channel will arrive after the
> tunning
> to new channel is complete.
> Those messages will create a big mess in the results, such as channels
> without names, duplicate channels on different transponders.
> -k option specifies how many messages should be ignored before processing
> it. I couldn't think of a more elegant way to ignore messages from
> previously tuned channel. I use "-k 3" by myself, but after playing around
> with "-k 2" saw that its also working. "-k 1" was still not enough.
> 
> The proper way is to have an option to reset that buffer in the driver
> after
> tunning.
> Since I don't know how it can be done and how it will affect tunning of
> channels for viewing, I didn't want to go that way and solve it in
> scan-s2.
> 
> Regards,
> Alex.

OK, thanks, I will check if I see that problem. Which card(s)
did you see this with?
Hans
-- 
Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
