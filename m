Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34157 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbbKQOod (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 09:44:33 -0500
Date: Tue, 17 Nov 2015 07:44:31 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	LMML <linux-media@vger.kernel.org>, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 2/4] scripts/kernel-doc: Replacing highlights hash by
 an array
Message-ID: <20151117074431.01338392@lwn.net>
In-Reply-To: <20151117084046.5c911c6a@recife.lan>
References: <1438112718-12168-1-git-send-email-danilo.cesar@collabora.co.uk>
	<1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
	<20151117084046.5c911c6a@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2015 08:40:46 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> The above causes some versions of perl to fail, as keys expect a
> hash argument:
> 
> Execution of .//scripts/kernel-doc aborted due to compilation errors.
> Type of arg 1 to keys must be hash (not private array) at .//scripts/kernel-doc line 2714, near "@highlights) "
> 
> This is happening at linuxtv.org server, with runs perl version 5.10.1.

OK, that's not good.  But I'm not quite sure what to do about it.

Perl 5.10.1 is a little over six years old.  Nobody else has complained
(yet) about this problem.  So it might be best to "fix" this with a
minimum version added to the Changes file.

Or maybe we need to revert the patch.

So I'm far from a Perl expert, so I have no clue what the minimum version
would be if we were to say "5.10.1 is too old."  I don't suppose anybody
out there knows?

Thanks,

jon
