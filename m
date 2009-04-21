Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:37333 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZDUDRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 23:17:44 -0400
Date: Mon, 20 Apr 2009 20:17:43 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Uri Shkolnik <urishk@yahoo.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_14] Siano: assemble all components to one kernel
 module
In-Reply-To: <933650.33930.qm@web110816.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.58.0904202014590.22095@shell2.speakeasy.net>
References: <933650.33930.qm@web110816.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009, Uri Shkolnik wrote:
>
> "better to have the BUS configurable, e. g. just because you have USB interface, it doesn't mean that you want siano for USB, instead of using SDIO."
>
> Since the module is using dynamic registration, I don't find it a problem.
> When the system has both USB and SDIO buses, both USB and SDIO interface driver will be compiled and linked to the module. When a Siano based device (or multiple Siano devices) will be connected, they will be register internally in the core and activated. Any combination is allow (multiple SDIO, multiple USB and any mix).

This is not the way linux drivers normally work.  Usually there are
multiple modules so that only the ones that need to be loaded are loaded.
It sounds like you are designing this to be custom compiled for each
system, but that's not usually they way things work.
