Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbbCEO1k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2015 09:27:40 -0500
Date: Thu, 5 Mar 2015 15:27:35 +0100
From: Jan Kara <jack@suse.cz>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Davidlohr Bueso <dbueso@suse.com>
Subject: Use of mmap_sem in __qbuf_userptr()
Message-ID: <20150305142735.GA16869@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  so after a long pause I've got back to my simplification patches around
get_user_pages(). After the simplification done by commit f035eb4e976ef5
(videobuf2: fix lockdep warning) it seems unnecessary to take mmap_sem
already when calling __qbuf_userptr(). As far as I understand what
__qbuf_userptr() does, the only thing where mmap_sem is needed is for
get_userptr and possibly put_userptr memops. So it should be possible to
push mmap_sem locking down into these memops, shouldn't it? Or am I missing
something in __qbuf_userptr() for which mmap_sem is also necessary?

If I'm right, I can prepare patches to do that (and then on top of those
rebase patches which will make v4l2 core use some mm helper functions so
they don't have to care about details of mm locking, vmas, etc.).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
