Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:64299 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZLKUr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 15:47:29 -0500
Received: by ywh3 with SMTP id 3so1282614ywh.22
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 12:47:36 -0800 (PST)
Date: Fri, 11 Dec 2009 12:42:07 -0800
From: Brandon Philips <brandon@ifup.org>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, stable@kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [stable] [PATCH] ov511: fix probe() hang due to double
 mutex_lock
Message-ID: <20091211204206.GB29049@jenkins.home.ifup.org>
References: <20091211010449.GV3387@jenkins>
 <20091211033225.GA2596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211033225.GA2596@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19:32 Thu 10 Dec 2009, Greg KH wrote:
> On Thu, Dec 10, 2009 at 05:04:49PM -0800, Brandon Philips wrote:
> > Commit 163fe744c3283fd267268629afff4cfc846ed0e0 added a double
> > mutex_lock which hangs ov51x_probe(). This was clearly a typo.
> > 
> > Change final mutex_lock() -> mutex_unlock()
> > 
> > Signed-off-by: Brandon Philips <bphilips@suse.de>
> 
> Brandon, when you want patches to be added to the stable tree, just add
> a:
> 	Cc: stable <stable@kernel.org>
> to the signed-off-by area of the patch.  That way, when they get merged
> into Linus's tree eventually, they will be automagically sent to the
> stable@kernel.org alias, so I know to add it to the tree at that time.
> 
> It saves you time, and me time, so I don't have to go hunt for this
> upstream sometime in the future.

That is a handy feature. It might be nice to document it in the
-stable documentation. See patch below for an attempt.

I will ping stable again on this patch once this reaches Linus's tree
so you don't need to track it. Sorry for messing up the stable
procedure. :D

Thanks,

	Brandon

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index a452227..5d24504 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -36,6 +36,23 @@ Procedure for submitting patches to the -stable tree:
  - Security patches should not be sent to this alias, but instead to the
    documented security@kernel.org address.
 
+Submitting to -stable automatically upon reaching Linus's tree:
+
+ - As mentioned above, patches must be merged into Linus's tree before being
+   considered for -stable. But, if you are sending a patch for inclusion
+   into Linus's tree that you know you will eventually submit to -stable when
+   it is merged then you can save yourself the trouble of tracking the patch by
+   adding:
+
+     Cc: stable <stable@kernel.org>
+
+   in the signed-off-by area of the patch. Then once it is merged with Linus
+   an email with the patch will be sent to stable@kernel.org automatically.
+
+   This only works for patches that are for both -stable and Linus's tree at
+   the time of submission. If a fix has already made its way into Linus's tree
+   or a maintainer's queue for Linus's tree then follow the regular submission
+   rules outlined above.
 
 Review cycle:
 
