Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65212 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab2INJXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:23:13 -0400
Received: by ieje11 with SMTP id e11so6441089iej.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 02:23:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120913122738.04eaceb3.akpm@linux-foundation.org>
References: <1347504057-5612-1-git-send-email-lliubbo@gmail.com>
	<20120913122738.04eaceb3.akpm@linux-foundation.org>
Date: Fri, 14 Sep 2012 17:23:12 +0800
Message-ID: <CAHG8p1CJ7YizySrocYvQeCye4_63TkAimsAGU1KC5+Fn0wqF8w@mail.gmail.com>
Subject: Re: [PATCH] nommu: remap_pfn_range: fix addr parameter check
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
	bhupesh.sharma@st.com, laurent.pinchart@ideasonboard.com,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org, dhowells@redhat.com,
	geert@linux-m68k.org, gerg@uclinux.org, stable@kernel.org,
	gregkh@linuxfoundation.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Yes, the MMU version of remap_pfn_range() does permit non-page-aligned
> `addr' (at least, if the userspace maaping is a non-COW one).  But I
> suspect that was an implementation accident - it is a nonsensical thing
> to do, isn't it?  The MMU cannot map a bunch of kernel pages onto a
> non-page-aligned userspace address.
>
> So I'm thinking that we should declare ((addr & ~PAGE_MASK) != 0) to be
> a caller bug, and fix up this regrettably unidentified v4l driver?

I agree. This should be fixed in videobuf.

Hi sharma, what's your kernel version? It seems videobuf2 already
fixed this bug in 3.5.
