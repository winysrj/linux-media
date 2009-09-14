Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbZINXYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 19:24:01 -0400
Date: Mon, 14 Sep 2009 20:23:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alexander.koenig@koenig-a.de, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14174] New: floppy drive not usable more than
 one time after reboot - kernel panic with active DVB
Message-ID: <20090914202326.0eaa0542@pedra.chehab.org>
In-Reply-To: <20090914151340.428fa07c.akpm@linux-foundation.org>
References: <bug-14174-10286@http.bugzilla.kernel.org/>
	<20090914151340.428fa07c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Sep 2009 15:13:40 -0700
Andrew Morton <akpm@linux-foundation.org> escreveu:

> Dunno about the floppy problem but this photo you took:
> https://bugzillafiles.novell.org/attachment.cgi?id=318005
> shows a good solid oops in dvb_dmx_memcopy().

I suspect that this is a bug caused by the lack of a memory barrier,
already corrected by dda06a8e4610757def753ee3a541a0b1a1feb36b.
