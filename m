Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36103 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbbKRAVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 19:21:34 -0500
Date: Tue, 17 Nov 2015 17:21:32 -0700
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
Message-ID: <20151117172132.3e647979@lwn.net>
In-Reply-To: <20151117132949.2c70d92f@recife.lan>
References: <1438112718-12168-1-git-send-email-danilo.cesar@collabora.co.uk>
	<1438112718-12168-3-git-send-email-danilo.cesar@collabora.co.uk>
	<20151117084046.5c911c6a@recife.lan>
	<20151117074431.01338392@lwn.net>
	<20151117132949.2c70d92f@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2015 13:29:49 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> The enclosed patch should do the trick. I tested it with perl 5.10 and 
> perl 5.22 it worked fine with both versions.

Indeed it seems to work - thanks!  Applied to the docs tree, I'll get it
upstream before too long.

jon
