Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:39192 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3AVOTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 09:19:51 -0500
Date: Tue, 22 Jan 2013 07:20:00 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 04/24] use IS_ENABLED() macro
Message-ID: <20130122072000.15efd64c@lwn.net>
In-Reply-To: <1358613206-4274-4-git-send-email-peter.senna@gmail.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
	<1358613206-4274-4-git-send-email-peter.senna@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 19 Jan 2013 14:33:07 -0200
Peter Senna Tschudin <peter.senna@gmail.com> wrote:

> replace:
>  #if defined(CONFIG_VIDEOBUF2_VMALLOC) || \
>      defined(CONFIG_VIDEOBUF2_VMALLOC_MODULE)
> with:
>  #if IS_ENABLED(CONFIG_VIDEOBUF2_VMALLOC)
> 
> This change was made for: CONFIG_VIDEOBUF2_VMALLOC,
> CONFIG_VIDEOBUF2_DMA_CONTIG, CONFIG_VIDEOBUF2_DMA_SG

That's something I'd meant to do to this driver for a while, thanks.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
