Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:42075 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZBRP3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:29:25 -0500
Date: Wed, 18 Feb 2009 09:29:23 -0600
From: David Engel <david@istwok.net>
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: V4L <video4linux-list@redhat.com>, linux-media@vger.kernel.org
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090218152923.GB15359@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net> <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net> <1234945507.3870.204.camel@belgarion.romunt.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234945507.3870.204.camel@belgarion.romunt.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:25:07AM +0100, Rudy Zijlstra wrote:
> > It then dawned on my why the 115-only results were so bad.  I had left
> > the 4-way splitter output used for the x50s unterminated.  Sure
> > enough, if I disconnected the x50s, I reproduced the severe errors.  I
> > didn't tear everything back apart to verify it, but I believe the 115s
> > would work fine by themselves if I terminated the cables properly.
> > 
> 
> Have you ever checked signal levels? May sound strange, but too high
> signal levels also cause this type of problems.

No.  On multiple occasions, though, I have tried adjusting the
amplification on the splitter from min to max and multiple settings in
between.  It never made any difference as far as I could see.

David
-- 
David Engel
david@istwok.net
