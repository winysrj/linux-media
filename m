Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43801 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab1EXM5I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:57:08 -0400
Received: by eyx24 with SMTP id 24so2132159eyx.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 05:57:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDB9CA6.6040208@wic.co.nz>
References: <885931.85151.qm@web28303.mail.ukl.yahoo.com>
	<4DDB9CA6.6040208@wic.co.nz>
Date: Tue, 24 May 2011 08:57:06 -0400
Message-ID: <BANLkTi=bWpBKe9j9HH_=Y-dUaJwvBi40Nw@mail.gmail.com>
Subject: Re: [linux-dvb] build.sh fails on kernel 2.6.38
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 24, 2011 at 7:55 AM, Stu Fleming <stewart@wic.co.nz> wrote:
> I note that the cx88 bug that affects HVR3000 and HVR4000 is still in this
> build
> https://lists.launchpad.net/mythbuntu-bugs/msg03390.html
>
> I would hugely appreciate the latter bug being fixed!!

Hmm, I just looked at this now.  I appreciate why they patch in the
ticket *appears* to fix the problem, but nonetheless it's not the
correct fix.

This is basically a race condition related to teardown of the DVB
frontend thread.  The function used to take over the DVB bus strobes
the reset pin on the demodulator, but there is no guarantee that the
demod's init function will subsequently get called.  In particular if
you rapid close then reopen the DVB device, the demod will get reset
but the init will not get called (since the thread wasn't torn down in
time and the init() call is only made on thread creation), resulting
in subsequent tuning requests failing.

Unfortunately, failing to strobe the reset (which is what the patch
does) will result in the chip potentially being in an unknown state,
which would intermittent result in tuning failure.  And you are also
very likely to have problems switching between DVB-T and DVB-S/S2.

This does explain though why an HVR-4000 user who came to me about a
year ago complaining of the DVB-T channel scanner not working in
MythTV, and the problem went away when I suggested he jam a sleep(1)
between the close() and open() calls to the DVB frontend.  Adding the
sleep ensured that the dvb frontend went away, which ensured that the
init call on the demod was always getting called when it got reopened.

In short, the patch is wrong but the problem is much more complicated
than simply removing the routine that strobes the reset.  Likely the
way bus acquire in the cx88 driver would have to be reworked to fix it
properly.  There may also need to be a fix to dvb_frontend.c as well.

This is one of those cases where a rather insidious problem has been
found with the framework, and the fix is both going to be complicated
and run a very real risk of causing breakage in other boards relying
on implicit behavior.

I wonder if we can just get the MythTV developers to stick a 0.1
second sleep in between closing and opening the frontend.  That would
be *much* safer at least in the short term.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
