Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbFVWES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 18:04:18 -0400
Date: Mon, 22 Jun 2015 15:04:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/9] Helper to abstract vma handling in media layer
Message-Id: <20150622150417.9328994e4c19916d3a88846f@linux-foundation.org>
In-Reply-To: <cover.1433927458.git.mchehab@osg.samsung.com>
References: <cover.1433927458.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2015 06:20:43 -0300 Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> I received this patch series with a new set of helper functions for
> mm, together with changes for media and DRM drivers.
> 
> As this stuff is actually mm code, I prefer if this got merged via
> your tree.
> 
> Could you please handle it? Please notice that patch 8 actually changes
> the exynos DRM driver, but it misses ack from DRM people.

I'm now getting large rejects from many of these patches.  It seems
that someone has recently removed a patch from linux-next, and that
patch added down_read(mmap_sem) and up_read(mmap_sem) to the same
functions which this patch series is altering.

I started fixing them all up but I got bored, and I'm not very
confident in the end result.

It was a particularly bad time to be making these sorts of changes. 
Does anyone know what's happening?
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
