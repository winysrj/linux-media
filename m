Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZCNLIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 07:08:01 -0400
Date: Sat, 14 Mar 2009 08:07:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS
 based cards
Message-ID: <20090314080730.2c716e8a@pedra.chehab.org>
In-Reply-To: <541911.18449.qm@web110813.mail.gq1.yahoo.com>
References: <541911.18449.qm@web110813.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Mar 2009 07:25:29 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> Mauro and all,
> 
> I submitted 3 patches, two modifications for the SDIO generic stack, and one new high level SDIO interface driver for Siano based devices.
> 
> This concludes SDIO related changes, with one exception, which is explained below.
> 
> However this explanation requires some overview about Siano's module inner architecture.
> 
> The Siano kernel module architecture is composed from:
> 1) SMS "Core" - This main component holds all Siano's host-device protocol logic, and any logic needed to bind the other module's components, interface and adapters.
> 2) Interfaces drivers (SDIO, USB, TS, SPP, HIF, ...) - At lease one interface driver must be compiled and linked, but multiple interfaces are supported. This feature enables platforms like the Asus UMPC series to use SMS based USB dongle and SMS based SDIO dongle simultaneously. 
> 3) Client adapters (DVB API v3, DVB API v5, others) - Similar to the interfaces drivers, at least one client adapter must be linked, but multiple are supported.
> 4) SMS "cards" - This component contains any hardware target specific information (like LEDs locations, antenna configuration, alternative firmware names, and much more), leaving any other component target-independent.

Ok, now I have some info about the architecture. Unfortunately, it is still not
clear to me how the different interfaces will work together with the DVB API.

What I'm trying to understand is: what the Siano devices are? They are a DVB
demod, a memory card, a usb bridge, ..., so we need different interfaces
because the chip has completely different functions inside?

Or it is a bridge to DVB functions, where the bridge can use different buses?

> And now back to SDIO....
> 
> True all SDIO related sources files are now updated (after these 3 patches), but since the build system (Kconfig & Makefile) and "smscore" component are yet to be updated, the SDIO interface driver can not be linked into the module.

Yes. I've sent an email to Pierre to be sure about the better way for we handle
it. After having his return, I'll do the adjustments at the building system to
allow us to build it inside the tree.

> The option to link and use the SDIO interface driver, will be available after those files will be updated (hope it'll happen shortly).
> 
> 
> One question: Should I continue submit patches (I have them ready), or should I wait till the 3 previous submission will be reviewed and committed?

Better to hold them for a while, until I get a better picture.

Cheers,
Mauro
