Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:52518 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbcFPSnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 14:43:55 -0400
Date: Thu, 16 Jun 2016 20:43:53 +0200
From: Max Kellermann <max@duempel.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
Message-ID: <20160616184353.GB3727@swift.blarg.de>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
 <5762D2A0.605@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5762D2A0.605@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016/06/16 18:24, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 06/15/2016 02:15 PM, Max Kellermann wrote:
> > media_gobj_destroy() may be called twice on one instance - once by
> > media_device_unregister() and again by dvb_media_device_free().  The
> > function media_remove_intf_links() establishes and documents the
> > convention that mdev==NULL means that the object is not registered,
> > but nobody ever NULLs this variable.  So this patch really implements
> > this behavior, and adds another mdev==NULL check to
> > media_gobj_destroy() to protect against double removal.
> 
> Are you seeing null pointer dereference on gobj->mdev? In any case,
> we have to look at if there is a missing mutex hold that creates a
> race between media_device_unregister() and dvb_media_device_free()
> 
> I don't this patch will solve the race condition.

I think we misunderstand.  This is not about a race condition.  And
the problem cannot be a NULL pointer dereference.

That's because nobody NULLs the pointer!

Pointer NULLing is what my patch adds, and AFTER my patch, there may
be NULL pointer dereferences (if there are more previously existing
bugs, which we should fix as well).  I added this NULL assignment
because there are NULL checks - and if nobody NULLs the pointer, that
check doesn't make any sense!

Max
