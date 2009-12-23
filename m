Return-path: <linux-media-owner@vger.kernel.org>
Received: from co203.xi-lite.net ([149.6.83.203]:37033 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbZLWQ0G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 11:26:06 -0500
Received: from ONYX.xi-lite.lan (unknown [193.34.35.244])
	by co203.xi-lite.net (Postfix) with ESMTP id 8E0766582B9
	for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 16:01:11 +0000 (GMT)
Message-ID: <4B323EC6.5000204@parrot.com>
Date: Wed, 23 Dec 2009 17:01:10 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: v4l2_linux <linux-media@vger.kernel.org>
Subject: videobuf-dma-contig.c cached user mapping
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I would like to add support for cached user mapping to
videobuf-dma-contig.c.

For enabling this, "vma->vm_page_prot =
pgprot_noncached(vma->vm_page_prot);" line should be removed.

But now we should ensure user mapping cache coherency.
For that, for a camera we should :
- invalidate cache before dma operation (to have not old buffer data in
the cache)
- forbid the user to access the buffer during the dma operation (to not
pollute the cache)

Is it possible ?
How can we achieve that ?

I see sync method, that seems only called after frame capture ?


Thanks,
Matthieu
