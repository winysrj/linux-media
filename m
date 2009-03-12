Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZCLJTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:19:50 -0400
Date: Thu, 12 Mar 2009 06:19:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: SDIO stack patch
Message-ID: <20090312061923.3bfcfba5@pedra.chehab.org>
In-Reply-To: <84881.14337.qm@web110815.mail.gq1.yahoo.com>
References: <84881.14337.qm@web110815.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009 02:00:34 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> Hi,
> 
> I have a question regarding patching kernel files which reside outside the 'drivers/media' scope.
> 
> The SMS device can use SPI and SDIO host interfaces (among others).
> 
> Both those drivers' sources require some patching.
> 
> The SDIO stack has been patched by Pierre Ossman himself (maintainer of MMC/SD/SDIO stack) back in summer 2008. 
> Pierre asked that those patches will be committed via the LinuxTV's path.
> 
> The SPP patches had been written in Siano (very small patch).
> 
> 
> My questions:
> 
> 1) When re-creating the patches (both are quite old, and probably outdated regarding the kernel version which has been used back then), which kernel version should I use for the diff?

The last one: 2.6.29-rc*-git*

> 2) Since the V4L hg does not contain those files, should I supply -
> 	A) The entire updated sources files (only)
> 	B) Only the patches (like it done with v4l's files)
> 	C) Both

The easiest way, is just to specify at v4l/versions.txt what's the
minimal version for it to compile (2.6.29, for example). Then, you just send us
the v4l stuff, and be sure that it will compile fine against that version.


Cheers,
Mauro
