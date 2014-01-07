Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53848 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAGExR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 23:53:17 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so3652349wib.15
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 20:53:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
Date: Mon, 6 Jan 2014 23:53:15 -0500
Message-ID: <CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Mester <ttmesterr@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I suspect this is actually a different problem which out of dumb luck
> gets "fixed" by resetting the chip.  Without more details on the
> specific behavior you are seeing though I cannot really advise on what
> the correct change is.

Tim,

It might be worth trying out the following patch series and see if it
addresses the problem you're seeing.  There was a host of problems
with the clock management on the device which could result in the
various sub-blocks getting wedged.  The TS output block was just one
of those cases.

http://git.kernellabs.com/?p=dheitmueller/linuxtv.git;a=shortlog;h=refs/heads/950q_improv

I'm not against the hack you've proposed if it's really warranted, but
a reset is really a last resort and I'm very concerned it's masking
over the real problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
