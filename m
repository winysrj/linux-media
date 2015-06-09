Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39907 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557AbbFIX4i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 19:56:38 -0400
Date: Tue, 9 Jun 2015 20:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] cx24120: Take control of b2c2 receive stream
Message-ID: <20150609205632.007e68d5@recife.lan>
In-Reply-To: <55643B07.9010807@gmail.com>
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
	<1432326508-6825-4-git-send-email-jdenson@gmail.com>
	<20150526110545.32c71335@dibcom294.coe.adi.dibcom.com>
	<55643B07.9010807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 May 2015 10:21:11 +0100
Jemma Denson <jdenson@gmail.com> escreveu:

> Hi Patrick,
> 
> On 26/05/15 10:05, Patrick Boettcher wrote:
> >> Now that b2c2 has an option to allow us to do so, turn off the
> >> flexcop receive stream when we turn off mpeg output whilst tuning.
> > Does this not fix (and your '[PATCH 2/4]') the problem of receiving
> > PAT from the previously tuned transport-stream?
> >
> > Then patch 1 and 4 should not be necessary, should they?!
> 
> Only patch 1 fixes that problem, so out of the 4 here that one is the 
> most necessary. Controlling the flexcop receive stream and/or stopping 
> the cx24120 from sending doesn't actually appear to do much of anything 
> - it doesn't seem any better or worse doing one or the other, both or 
> even neither! (Apart from Patch 4 breaking things, as mentioned).
> 
> I'm including it though because I presume the reference driver advised 
> it was done, and it does tidy up the cx24120 codebase considerably by 
> being able to disable the whole turn off sending the stream whilst 
> tuning feature - I'm envisioning that in the future someone might want 
> to take on the task of merging cx24117 & cx24120 as they're quite 
> similar, and allowing what seems to just be a flexcop oddity to be 
> turned off would make this possible.

Hmm... if patch 1 is enough to fix the issue, and patch 4 may break
things, I'll apply only patch 1/4 for now.

If Patrick agrees, and you find a way to avoid breakages, please
resubmit for me to apply the other ones.

Regards,
Mauro

> 
> 
> Jemma.
