Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48846 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603AbbLNWi5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 17:38:57 -0500
Date: Mon, 14 Dec 2015 20:38:52 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] media-entity: protect object creation/removal using
 spin lock
Message-ID: <20151214203852.5fbeef16@recife.lan>
In-Reply-To: <20151214200434.GF5177@mwanda>
References: <20151214195053.GA15098@mwanda>
	<20151214180052.4262a0a8@recife.lan>
	<20151214200434.GF5177@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Dec 2015 23:04:34 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> On Mon, Dec 14, 2015 at 06:00:52PM -0200, Mauro Carvalho Chehab wrote:
> > I guess gcc optimizer actually does the right thing, but we should
> > fix it to remove the static analyzer warnings.
> 
> It probably crashes if you enable poisoning freed memory?  (I haven't
> tested).

I tested with KASAN: when I made such patch: it worked fine.
I suspect that gcc optimized the code to cache the value. Anyway, 
this should be fixed.

Thanks for pointing the issue!

Regards,
Mauro
