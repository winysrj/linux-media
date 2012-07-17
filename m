Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm129.target-host.de ([188.72.225.129]:47538 "EHLO
	ffm129.target-host.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GQUQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 16:16:07 -0400
Date: Tue, 17 Jul 2012 22:15:57 +0200
From: Nikolaus Schulz <schulz@macnetix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jonathan Nieder <jrnieder@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Andreas Oberritter <obi@linuxtv.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb: push down ioctl lock in dvb_usercopy
Message-ID: <20120717201557.GA18369@pcewns01.macnetix.de>
References: <1340300655-17696-1-git-send-email-schulz@macnetix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340300655-17696-1-git-send-email-schulz@macnetix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I don't want to press or annoy anybody, but may I ask what's the status
of this patch[1]?

On Thu, Jun 21, 2012 at 07:44:15PM +0200, schulz@macnetix.de wrote:
> Since most dvb ioctls wrap their real work with dvb_usercopy, the static mutex
> used in dvb_usercopy effectively is a global lock for dvb ioctls.
> Unfortunately, frontend ioctls can be blocked by the frontend thread for
> several seconds; this leads to unacceptable lock contention.  Mitigate that by
> pushing the mutex from dvb_usercopy down to the individual, device specific
> ioctls.

On our systems, this patch has a great effect in terms of scalability
when operating multiple DVB tuners.

Is it going to be considered?

Thanks,
Nikolaus

[1] http://patchwork.linuxtv.org/patch/12989/
