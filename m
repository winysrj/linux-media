Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33632 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZDSJw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 05:52:56 -0400
Received: by fxm2 with SMTP id 2so1492916fxm.37
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2009 02:52:54 -0700 (PDT)
Message-ID: <49EAF472.9010702@googlemail.com>
Date: Sun, 19 Apr 2009 11:52:50 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
MIME-Version: 1.0
To: Kjeld Flarup <kjeld.flarup@liberalismen.dk>
CC: linux-media@vger.kernel.org
Subject: Re: dvbd
References: <49EA7EFA.4030701@liberalismen.dk>
In-Reply-To: <49EA7EFA.4030701@liberalismen.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Kjeld Flarup wrote:

> I've taken some interest in a small piece of software called dvbd.
> http://dvbd.sourceforge.net/
> I really like the concept of this software, because it could be used for
> sharing one DVB card among several different applications.

That's right.

> BUT the software have not been developed since 2004.

And it needs a few tweaks when you're using a more recent C++ compiler
like gcc 4.3.x.

> Is this because it is not so smart anyway, or are there some better
> programs out there?

There is VDR, of course. But I don't like the way it does things.
Therefore, I've been using dvbd for years to handle my small zoo of
DVB-T receivers (I've got four of them running at the moment). It easily
handles several recordings in parallel without using many resources - a
few megabytes of RAM and a few percent of CPU time on an old (2005)
Athlon64. I currently consider moving it to an Intel Atom based system.

dvbd does sometimes have issues with disk writes, though. It doesn't do
much buffering, and if another process is blocking the disk it's writing
to for too long, you may encounter drop-outs. It's best to give it a
disk of its own. Similarly, if dvbd doesn't get scheduled for a while,
it will lose data from the receivers. On a single-core machine that also
does other things (like mine), I recommend to raise its priority with
nice --20, or maybe use a realtime priority level.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
