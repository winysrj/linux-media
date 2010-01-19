Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0ASMg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 07:36:29 -0500
Message-ID: <4B55A749.9040407@infradead.org>
Date: Tue, 19 Jan 2010 10:36:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <201001190904.29159.laurent.pinchart@ideasonboard.com> <4B5593BA.9080008@infradead.org> <201001191250.51324.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001191250.51324.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> So am I. I hope the future will prove us right :-)

:)

> How do your new git scripts process commits ? In particular, does the 
> "Priority:" line still applies ?

For patches imported from -hg, the script will handle Priority. For patches
generated against -git, maybe the better is to have separate branches or 
trees: one for fixes and another for new stuff, and an indication, at the
pull request, to what tree the patch will be applied.

We still need some discussions about the process. One of the issues is how
do we'll handle SOB's. My SOB should be added on all patches. Also, sometimes,
patches may need to receive other SOB-like tags, like acked-by. I'm not
sure yet how should we handle it, since a change at the patch description
will change the hash code. -git merge is generally smart enough to not
generate a conflict between two patches with identical diffs, but we need
to do some tests in order to check what would be the better procedure.

Cheers,
Mauro.


