Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:54269 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758638AbZJLXfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 19:35:15 -0400
Subject: Re: em28xx mode switching
From: hermann pitton <hermann-pitton@arcor.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
References: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 01:33:20 +0200
Message-Id: <1255390400.3294.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 12.10.2009, 18:12 -0400 schrieb Devin Heitmueller:
> I was debugging an issue on a user's hybrid board, when I realized
> that we are switching the em28xx mode whenever we start and stop dvb
> streaming.  We already have the ts_bus_ctrl callback implemented which
> puts the device into digital mode and puts it back into suspend
> whenever the frontend is opened/closed.
> 
> This call seems redundant, and in fact can cause problems if the
> dvb_gpio definition strobes the reset pin, as it can put the driver
> out of sync with the demodulator's state (in fact this is what I ran
> into with the zl10353 - the reset pin got strobed when the streaming
> was started but the demod driver's init() routine was not being run
> because it already ran when the frontend was originally opened).
> 
> The only case I can think of where toggling the device mode when
> starting/stopping dvb streaming might be useful is if we wanted to
> support being able to do an analog tune while the dvb frontend was
> still open but not streaming.  However, this seems like this could
> expose all sorts of bugs, and I think the locking would have to be
> significantly reworked if this were a design goal.
> 
> Thoughts anybody?
> 
> Devin
> 

Hi,

on dvb were some telling us previously, by far not all, but the loudest,
all the hybrid stuff will soon vanish and it is not even worth to look
closer into it.

This is years back, and the problem is still there.

But, these days you can discuss it more relaxed and despite of all, we
have lots of improvements now.

See Mike's latest compromising about who has the gpio pins.

Even only thinking about such in public

was a crime previously ... (and heavily punished ;) 

Cheers,
Hermann




