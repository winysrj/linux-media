Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:47663 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbcFQNEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 09:04:06 -0400
Date: Fri, 17 Jun 2016 15:04:03 +0200
From: Max Kellermann <max@duempel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
Message-ID: <20160617130403.GA9229@swift.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
 <20160617125317.GF24980@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160617125317.GF24980@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016/06/17 14:53, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Jun 15, 2016 at 10:15:07PM +0200, Max Kellermann wrote:
> > media_gobj_destroy() may be called twice on one instance - once by
> > media_device_unregister() and again by dvb_media_device_free().  The
> 
> Is that something that should really happen, and why? The same object should
> not be unregistered more than once --- in many call paths gobj
> unregistration is followed by kfree() on the gobj.

True, it should not happen, and I think the code is currently
misdesigned (or I just don't grasp it correctly; I may be wrong).

The "gobj" is inserted into a linked list, the list's owner
(media_device) feels responsible to free items in that list.  Plus,
the dvb_device instances holds a pointer and also tries to free it.

Usually, dvbdev.c destruction gets called first, which removes the
"gobj" from the linked list, and media_device never sees it during its
own destruction.  But that ordering is all but guaranteed.  It just
happens to be that way under "normal" circumstances.

None of this makes any sense to me.  There appears to be lots of bogus
and unsafe code.  I'm still waiting for somebody with more clue to
enlighten me.

Max
