Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52092 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751824AbcBURUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:20:30 -0500
Date: Sun, 21 Feb 2016 18:00:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] media: Always keep a graph walk large enough
 around
Message-ID: <20160221160009.GT32612@valkosipuli.retiisi.org.uk>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
 <1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
 <20160219120341.076478ef@recife.lan>
 <20160219144046.GQ32612@valkosipuli.retiisi.org.uk>
 <20160219141423.56264355@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160219141423.56264355@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 19, 2016 at 02:14:23PM -0200, Mauro Carvalho Chehab wrote:
...
> > > As kbuildtest also didn't like this patch, I'm not applying it
> > > for now.  
> > 
> > For missing KernelDoc documentation for a struct field.
> > 
> > Other fields in the struct don't have KernelDoc documentation either, and I
> > didn't feel it'd fit well for this patch. I can add a patch to change the
> > field documentation to the set if you like.
> 
> Ok, it could be done on a separate patch. Feel free to submit it.

I noticed the struct had KernelDoc comments but I missed them.

I'll update the patch accordingly. If you still think it'd be a good idea to
move the graph initialisation elsewhere, let me know. In the meantime I'll
send v3.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
