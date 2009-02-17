Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZBQCPw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 21:15:52 -0500
Date: Tue, 17 Feb 2009 03:15:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: CityK <cityk@rogers.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, mchehab@infradead.org,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] V4L: Storage class should be before const qualifier
In-Reply-To: <4999AAB6.4090904@rogers.com>
Message-ID: <alpine.LNX.1.10.0902170313310.18110@jikos.suse.cz>
References: <20090209210649.GA7378@xenon.distanz.ch> <alpine.LNX.1.10.0902161353150.18110@jikos.suse.cz> <4999AAB6.4090904@rogers.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009, CityK wrote:

> >> .... [inline patch] ....
> > This doesn't seem to be picked by anyone for current -next/-mmotm, I have
> > applied it to trivial tree. Thanks,
> Will this create any complication? As it is indeed queued in our
> patchwork: http://patchwork.kernel.org/project/linux-media/list/

Hmm, patchwork ... did this land in any actual code tree? It has been 
submitted by Tobias on 9th Feb and I was not able to find it in any tree 
today, so I applied to to trivial tree (to which the patch has been 
originally CCed).

If you guys actually have queued in some tree, please let me know and I 
will drop it.

-- 
Jiri Kosina
SUSE Labs
