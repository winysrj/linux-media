Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:56305 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbbEJKxf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2015 06:53:35 -0400
Date: Sun, 10 May 2015 12:53:21 +0200
From: Felix Janda <felix.janda@posteo.de>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/4] Use off_t and off64_t instead of __off_t and
 __off64_t
Message-ID: <20150510105321.GA28886@euler>
References: <20150125203557.GA11999@euler>
 <20150505093657.43acf519@recife.lan>
 <20150505190223.GA4948@euler>
 <554E7360.9060301@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554E7360.9060301@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Gregor Jasny wrote:
> Hello,
> 
> Due to complete lack of unit / integration tests I feel uncomfortable
> merging this patch without the ACK of Hans de Goede.

Thanks for merging the other patches. Sorry for them having been
dependent on this patch.

> On 05/05/15 21:02, Felix Janda wrote:
> > Since _LARGEFILE64_SOURCE is 1, these types coincide if defined.
> 
> This statement is only partially true:
> 
> $ git grep _LARGEFILE64_SOURCE
> lib/libv4l1/v4l1compat.c:#define _LARGEFILE64_SOURCE 1
> lib/libv4l2/v4l2convert.c:#define _LARGEFILE64_SOURCE 1
> 
> So LARGEFILE64_SOURCE will be only defined within the wrappers.
> But libv4lsyscall-priv.h / SYS_MMAP is also used elsewhere.

Actually, I think _LARGEFILE64_SOURCE does not influence whether _off_t
is off_t (on 32bit) or not. What is rather needed is that
_FILE_OFFSET_BITS is not 64. See e.g.

http://www.freecode.com/articles/largefile-support-problems

On the hand, I think that it would actually be benificial to have
_FILE_OFFSET_BITS=64 globally so that on 32bit (glibc) systems all of
v4l2-utils can deal with files >2GB. In the LD_PRELOAD libraries the
special casing for glibc on linux would need to be changed. I'm
preparing a patch for discussion.

> But I wonder why SYS_MMAP is there in the first place? Maybe because in
> the LD_PRELOAD case the default mmap symbol resolves to our wrapper?

Exactly. First, syscall was used directly and later SYS_MMAP was
introduced to compile on FreeBSD.

> But in that case can't we gently ask the loader to give us the next
> symbol in the chain via dlsym(RTLD_NEXT, "mmap")?

This seems preferable to having to deal with the differences between
Linux/FreeBSD and mmap/mmap2. For glibc on linux we should make sure
that "mmap64" is used instead. We could use in the mmap wrapper a
static variables to detect whether we should call v4l*_mmap or the
mmap from libc.

Felix
