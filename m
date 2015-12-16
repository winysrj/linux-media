Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57260 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966302AbbLPRjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:39:47 -0500
Date: Wed, 16 Dec 2015 15:39:36 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, javier@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 00/23] Unrestricted media entity ID range support
Message-ID: <20151216153936.0227d179@recife.lan>
In-Reply-To: <20151216140301.GO17128@valkosipuli.retiisi.org.uk>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
	<20151216140301.GO17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Dec 2015 16:03:01 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Javier,
> 
> On Wed, Dec 16, 2015 at 03:32:15PM +0200, Sakari Ailus wrote:
> > This is the third version of the unrestricted media entity ID range
> > support set. I've taken Mauro's comments into account and fixed a number
> > of bugs as well (omap3isp memory leak and omap4iss stream start).

Patches merged on my experimental tree:

	ssh://linuxtv.org/git/mchehab/experimental.git

branch media-controller-rc4

I had to do some rebase, as you were using some older changeset.
Also, several documentation tags were with troubles (renamed
vars not renamed there).

Next time, please check the documentation with:
	make DOCBOOKS=device-drivers.xml htmldocs 2>&1

> Javier: Mauro told me you might have OMAP4 hardware. Would you be able to
> test the OMAP4 ISS with these patches?

As Sakari patches were rebased, it would be good to test them again
on omap3.

Regards,
Mauro
