Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail10.svc.cra.dublin.eircom.net ([159.134.118.26]:41362 "HELO
	mail10.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603AbZEHHeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2009 03:34:23 -0400
Subject: Re: CX24123 no FE_HAS_LOCK/tuning failed.
From: John Donoghue <jdonog01@eircom.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 08 May 2009 08:34:22 +0100
Message-Id: <1241768062.6347.35.camel@john-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My apologies to Rex and to those contributing to the XC5000 thread for
having caused the two threads to become mixed - very sorry!

Rex, this message should effectively start a new thread, so that
hopefully your problem becomes more visible to those who may be able to
help further.  For my part, I am at a loss on how to proceed.  3 people
have e-mailed me in the last 6 months to indicate that my "patch" fixed
their problems.  However, one guy could not get his setup working, but
I'm not convinced it was the card which was at fault.  The various debug
outputs you have posted are very similar to mine, except for the
parameter differences between Optus D1 and Astra 2.  At least they are
indicating that the 22kHz tone is now being generated.  I don't think
the numbers for signal strength, S/N ratio and ber have any meaning,
except when the tuner is locked.

Have you any way of monitoring the input/output of the Nova S Plus?  I
use a cheap "Satellite Finder" which I leave permanently in-line in the
coax.  It indicates the presence of the 22kHz tone and the 13V/18V
signals, as well as an uncalibrated signal strength.  Also, feel free to
dismiss this and it is a long-shot, but are you absolutely sure that you
are pointing at Optus D1 and not C1?  They are fairly close.  It should
be very easy to check by trying to szap 12407 V, srate 30000, fec 2/3,
which is on Optus C1 and which seems to be beamed at New Zealand.

Best of luck,
John


