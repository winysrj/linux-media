Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62516 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbZJLWNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 18:13:13 -0400
Received: by fxm27 with SMTP id 27so9671911fxm.17
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 15:12:36 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 18:12:35 -0400
Message-ID: <829197380910121512y62a90cdcs49a0aa9606e8a588@mail.gmail.com>
Subject: em28xx mode switching
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was debugging an issue on a user's hybrid board, when I realized
that we are switching the em28xx mode whenever we start and stop dvb
streaming.  We already have the ts_bus_ctrl callback implemented which
puts the device into digital mode and puts it back into suspend
whenever the frontend is opened/closed.

This call seems redundant, and in fact can cause problems if the
dvb_gpio definition strobes the reset pin, as it can put the driver
out of sync with the demodulator's state (in fact this is what I ran
into with the zl10353 - the reset pin got strobed when the streaming
was started but the demod driver's init() routine was not being run
because it already ran when the frontend was originally opened).

The only case I can think of where toggling the device mode when
starting/stopping dvb streaming might be useful is if we wanted to
support being able to do an analog tune while the dvb frontend was
still open but not streaming.  However, this seems like this could
expose all sorts of bugs, and I think the locking would have to be
significantly reworked if this were a design goal.

Thoughts anybody?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
