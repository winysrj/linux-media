Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:60708 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZCXVjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:39:33 -0400
Received: by gxk4 with SMTP id 4so6960258gxk.13
        for <linux-media@vger.kernel.org>; Tue, 24 Mar 2009 14:39:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
	 <1237689919.3298.179.camel@palomino.walls.org>
	 <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com>
Date: Tue, 24 Mar 2009 17:39:31 -0400
Message-ID: <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 22, 2009 at 9:00 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> Wow, well this literally kept me up all night pondering the various options.
>
> Manu's idea has alot of merit - providing a completely new API that
> provides the "raw data without translation" as well as a way to query
> for what that format is for the raw data, provides a great deal more
> flexibility for applications that want to perform advanced analysis
> and interpretation of the data.
>
> That said, the solution takes the approach of "revolutionary" as
> opposed to "evolutionary", which always worries me.  While providing a
> much more powerful interface, it also means all of the applications
> will have to properly support all of the various possible
> representations of the data, increasing the responsibility in userland
> considerably.
>
> Let me ask this rhetorical question: if we did nothing more than just
> normalize the SNR to provide a consistent value in dB, and did nothing
> more than normalize the existing strength field to be 0-100%, leaving
> it up to the driver author to decide the actual heuristic, what
> percentage of user's needs would be fulfilled?
>
> I bet the answer would be something like 99%.
>
> I can see the value in an "advanced API" that could provide the
> underlying raw data, but I feel like this could be provided in the
> future at any point that someone cares enough to do the work.
>
> We can spend weeks debating and trying to design the "perfect
> interface" (and possibly never come to an agreement as has gone on for
> years), or we can just make a decision on how to represent the two
> values that is "good enough", and we can have 99% of the population
> satisfied virtually overnight (with the ability to provide an advanced
> API to get the raw data in the future if there is ever sufficient
> need).
>
> I'm willing to submit the patches for all the ATSC demods to conform
> to the final API if the experts can just decide on what the format
> should be.
>
> Devin

Any other demod authors want to weigh in on this matter?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
