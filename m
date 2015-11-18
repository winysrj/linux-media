Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60867 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbbKRJOU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 04:14:20 -0500
Date: Wed, 18 Nov 2015 07:14:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
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
Message-ID: <20151118071412.5a2d8258@recife.lan>
In-Reply-To: <20151117172132.3e647979@lwn.net>
References: <1438112718-12168-1-git-send-email-danilo.cesar@collabora.co.uk>
	<1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
	<20151117084046.5c911c6a@recife.lan>
	<20151117074431.01338392@lwn.net>
	<20151117132949.2c70d92f@recife.lan>
	<20151117172132.3e647979@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Nov 2015 17:21:32 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 17 Nov 2015 13:29:49 -0200
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > The enclosed patch should do the trick. I tested it with perl 5.10 and 
> > perl 5.22 it worked fine with both versions.
> 
> Indeed it seems to work - thanks!  Applied to the docs tree, I'll get it
> upstream before too long.

Thanks, Jon!

Regards,
Mauro
