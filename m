Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4995 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZBRIfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 03:35:05 -0500
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Reply-To: Rudy@grumpydevil.homelinux.org
To: David Engel <david@istwok.net>
Cc: Steven Toth <stoth@linuxtv.org>, V4L <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <20090218051945.GA12934@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net>
	 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
	 <499B1E19.80302@linuxtv.org>  <20090218051945.GA12934@opus.istwok.net>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 09:25:07 +0100
Message-Id: <1234945507.3870.204.camel@belgarion.romunt.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> It then dawned on my why the 115-only results were so bad.  I had left
> the 4-way splitter output used for the x50s unterminated.  Sure
> enough, if I disconnected the x50s, I reproduced the severe errors.  I
> didn't tear everything back apart to verify it, but I believe the 115s
> would work fine by themselves if I terminated the cables properly.
> 

Have you ever checked signal levels? May sound strange, but too high
signal levels also cause this type of problems.

> So what does all of this indicate?  My original hunch was that it's a
> problem with the x50 hardware or driver (at least in combination with
> my motherboard).  I think I'm back to that conclusion.
> 
> BTW, in my testing last night, I tried changing the PCI latency timer
> on the x50 cards.  I thought maybe it was holding off access to the
> 115 cards.  Changing that had no effect.
> 
> David
-- 
Cheers,


Rudy

