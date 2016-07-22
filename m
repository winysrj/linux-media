Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:58160 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbcGVVhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 17:37:19 -0400
Date: Fri, 22 Jul 2016 15:37:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: kernel-doc: fix handling of address_space tags
Message-ID: <20160722153716.7ac9a4b6@lwn.net>
In-Reply-To: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
References: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 Jul 2016 11:46:36 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The RST cpp:function handler is very pedantic: it doesn't allow any
> macros like __user on it:
> [...]
> So, we have to remove it from the function prototype.

Sigh, this is the kind of thing where somehow there's always more moles
to whack.  I feel like there must be a better fix, but I don't know what
it is, so I've applied this, thanks.

I'm trying to get my act together so that the pull request can go in
right away once the merge window opens.  If there's anything else you
think really needs to be there, please do let me know.

jon
