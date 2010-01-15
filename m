Return-path: <linux-media-owner@vger.kernel.org>
Received: from co203.xi-lite.net ([149.6.83.203]:37457 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0AOPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 10:02:13 -0500
Received: from ONYX.xi-lite.lan (unknown [193.34.35.244])
	by co203.xi-lite.net (Postfix) with ESMTP id 8AA0B658345
	for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 15:02:11 +0000 (GMT)
Message-ID: <4B508372.6070608@parrot.com>
Date: Fri, 15 Jan 2010 16:02:10 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: v4l2_linux <linux-media@vger.kernel.org>
Subject: videobuf cached user mapping
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Is that possible to have user mapping cached in Memory Mapping mode ?

This means buffer allocated by mmap in userspace, will have cache
support, and it will be faster to work on it.

But how the cache coherency can be done ?

For a camera we should :
- invalidate cache before dma operation (to have not old buffer data in
the cache)
- forbid the user to access the buffer during the dma operation (to not
pollute the cache)

Is it possible ?
How can we achieve that ?

I see sync method, that seems only called after frame capture ?


Or user "User Pointers" is the solution ?
But they should have the same problems. Is there some documentation of
how "user pointer" are synchronised with dma ?

Thanks,
Matthieu


