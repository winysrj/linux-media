Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40364 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAGEpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 23:45:11 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so16681750wgh.14
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 20:45:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389068966-14594-3-git-send-email-tmester@ieee.org>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
Date: Mon, 6 Jan 2014 23:45:05 -0500
Message-ID: <CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Mester <ttmesterr@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 11:29 PM, Tim Mester <ttmesterr@gmail.com> wrote:
> The demodulator can get in a state in ATSC mode where just
> restarting the feed alone does not correct the corrupted stream.  The
> demodulator reset in addition to the feed restart seems to correct
> the condition.
>
> The au8522 driver has been modified so that when set_frontend() is
> called with the same frequency and modulation mode, the demodulator
> will be reset.  The au0282 drives uses this feature when it attempts
> to restart the feed.

What is the actual "corruption" that you are seeing?  Can you describe
it in greater detail?  The original fix was specifically related to
the internal FIFO on the au0828 where it can get shifted by one or
more bits (i.e. the leading byte is no longer 0x47 but 0x47 << X).
Hence it's an issue unrelated to the actual au8522.

I suspect this is actually a different problem which out of dumb luck
gets "fixed" by resetting the chip.  Without more details on the
specific behavior you are seeing though I cannot really advise on what
the correct change is.

This patch should not be accepted upstream without more discussion.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
