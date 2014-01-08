Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:34907 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaAHFDl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 00:03:41 -0500
Received: by mail-qc0-f179.google.com with SMTP id i8so1057643qcq.24
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 21:03:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
	<1389068966-14594-3-git-send-email-tmester@ieee.org>
	<CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
Date: Tue, 7 Jan 2014 22:03:41 -0700
Message-ID: <CAEEHgGWO0iLP2fCf4QD0sBQT9p6WqZM748cTduaWKaMHEn74dA@mail.gmail.com>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
From: Tim Mester <tmester@ieee.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 9:45 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
>
> On Mon, Jan 6, 2014 at 11:29 PM, Tim Mester <ttmesterr@gmail.com> wrote:
> > The demodulator can get in a state in ATSC mode where just
> > restarting the feed alone does not correct the corrupted stream.  The
> > demodulator reset in addition to the feed restart seems to correct
> > the condition.
> >
> > The au8522 driver has been modified so that when set_frontend() is
> > called with the same frequency and modulation mode, the demodulator
> > will be reset.  The au0282 drives uses this feature when it attempts
> > to restart the feed.
>
> What is the actual "corruption" that you are seeing?  Can you describe
> it in greater detail?  The original fix was specifically related to
> the internal FIFO on the au0828 where it can get shifted by one or
> more bits (i.e. the leading byte is no longer 0x47 but 0x47 << X).
> Hence it's an issue unrelated to the actual au8522.
>
> I suspect this is actually a different problem which out of dumb luck
> gets "fixed" by resetting the chip.  Without more details on the
> specific behavior you are seeing though I cannot really advise on what
> the correct change is.
>
> This patch should not be accepted upstream without more discussion.
>
> Regards,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com


The patch really address two issues:

1) The driver reports that the TS sync byte has not been found (the
0x47), and that it is attempting to restart streaming. However, this
message gets repeated indefinitely, and the streaming can never begin.
Eventually, Mythtv gives up on the recoding.  When I reset the
demodulator, the streaming immediately starts. I have not examined the
data to see if it is a shifted sync byte or not, but the symptom seems
similar.

2) Occasionally, the au8522 report that it lost lock, and the TS
stream stops flowing.  The au8522_set_frontend(), gets called, but
because we are already tuned to the same frequency, nothing happens,
and lock is never  re-established until we tune to a different
channel, then back to the original one where lock was lost.

I have only seen this behavior in ATSC mode. Back when I was using the
device in QAM256 mode, I did not observe the Lock lost or the unable
to start streaming issues.


Thanks,

Tim
