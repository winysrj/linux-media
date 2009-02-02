Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZBBQLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 11:11:42 -0500
Date: Mon, 2 Feb 2009 14:09:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] newport: newport_*wait() return 0 on timeout
Message-ID: <20090202140939.2a568e79@caramujo.chehab.org>
In-Reply-To: <25e057c00902020532p7a22f9d6pbfdc4f26c85c4dfd@mail.gmail.com>
References: <49846E63.8070507@gmail.com>
	<20090202100852.733c6c8e@caramujo.chehab.org>
	<25e057c00902020532p7a22f9d6pbfdc4f26c85c4dfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009 14:32:09 +0100
roel kluin <roel.kluin@gmail.com> wrote:

> 2009/2/2 Mauro Carvalho Chehab <mchehab@infradead.org>:
> > Hi Roel,
> >
> > It seems that you've sent this driver to the wrong ML. Video adapters are not handled on those ML's.
> 
> Any idea where it should be sent?

$ git log include/video/newport.h
commit 3f08ff4a4dab1ebef06d154050fb80ce2c13fc9c
Author: Adrian Bunk <bunk@stusta.de>
Date:   Mon Jan 9 20:53:35 2006 -0800

    [PATCH] include/video/newport.h: "extern inline" -> "static inline"
    
    "extern inline" doesn't make much sense.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: "Antonino A. Daplas" <adaplas@pol.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Hmm... this is the only change on this file since -git history. I would forward the patch to Andrew.

Cheers,
Mauro
