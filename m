Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZBIQfd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 11:35:33 -0500
Date: Mon, 9 Feb 2009 14:34:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
	jkosina@suse.cz, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] use the new request_module_nowait() in
 drivers/media
Message-ID: <20090209143456.1c5d7f0b@pedra.chehab.org>
In-Reply-To: <20090208110052.6f3deafc@infradead.org>
References: <20090208104201.6124ab6a@infradead.org>
	<20090208104314.4e74e6a8@infradead.org>
	<20090208110052.6f3deafc@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 8 Feb 2009 11:00:52 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 8 Feb 2009 10:43:14 -0800
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> blargh I sent an older version of this patch
> I meant to send this one
> 
> From 2311993ceed96ec0bb023419120d9aeada205242 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] use the new request_module_nowait() in drivers/media
> 
> Several drivers/media/video drivers use keventd to load modules
> to avoid the "load a module from the module init code" deadlock.
> 
> Now that we have request_module_nowait() this can be simplified
> greatly.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
