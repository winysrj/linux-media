Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:46145 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbBUUMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 15:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAO_48GGT6C8-7gnKMcQ+rAQfvkEmyNzUmJAB=uJUJrFZSNo5sg@mail.gmail.com>
References: <CAO_48GGT6C8-7gnKMcQ+rAQfvkEmyNzUmJAB=uJUJrFZSNo5sg@mail.gmail.com>
Date: Sat, 21 Feb 2015 12:12:38 -0800
Message-ID: <CA+55aFxAcq9a+Q6evyPXUf_BOkSUW6oajaz-g+DCDpaaE2wc4w@mail.gmail.com>
Subject: Re: [GIT PULL]: few dma-buf updates for 3.20-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 20, 2015 at 8:27 AM, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>
> Could you please pull a few dma-buf changes for 3.20-rc1? Nothing
> fancy, minor cleanups.

No.

I pulled, and immediately unpulled again.

This is complete shit, and the compiler even tells you so:

    drivers/staging/android/ion/ion.c: In function ‘ion_share_dma_buf’:
    drivers/staging/android/ion/ion.c:1112:24: warning: ‘buffer’ is
used uninitialized in this function [-Wuninitialized]
     exp_info.size = buffer->size;
                            ^

Introduced by "dma-buf: cleanup dma_buf_export() to make it easily extensible".

I'm not taking "cleanups" like this.  And I certainly don't appreciate
being sent completely bogus shit pull requests at the end of the merge
cycle.

                           Linus
