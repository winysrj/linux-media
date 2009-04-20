Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTSDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:03:40 -0400
Date: Mon, 20 Apr 2009 15:03:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel
 module
Message-ID: <20090420150333.3923d000@pedra.chehab.org>
In-Reply-To: <629811.69312.qm@web110804.mail.gq1.yahoo.com>
References: <629811.69312.qm@web110804.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 04:42:11 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1238756860 -10800
> # Node ID 616e696ce6f0c0d76a1aaea8b36e0345112c5ab6
> # Parent  f65a29f0f9a66f82a91525ae0085a15f00ac91c2
> [PATCH] [0904_14] Siano: assemble all components to one kernel module
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> Previously, the support for Siano-based devices
> has been combined from several kernel modules. 
> This patch assembles all into single kernel module.

Why? It seems better to keep it more modular.

Cheers,
Mauro
