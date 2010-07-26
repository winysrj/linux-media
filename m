Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45429 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0GZTo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:44:56 -0400
From: "Sin, David" <davidsin@ti.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Mon, 26 Jul 2010 14:44:51 -0500
Subject: RE: [RFC 0/8] TI TILER-DMM driver
Message-ID: <513FF747EED39B4AADBB4D6C9D9F9F7903D63B9DF7@dlee02.ent.ti.com>
References: <1279927694-26138-1-git-send-email-davidsin@ti.com>
 <AANLkTinyidvgpE26M=JXjpouoC+mPfehQWyr4L_bQHu_@mail.gmail.com>
In-Reply-To: <AANLkTinyidvgpE26M=JXjpouoC+mPfehQWyr4L_bQHu_@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your feedback, Linus.  I will incorporate an acronym list in the documentation.  TCM stands for TILER container manager, which pretty much represents the interface to the logic which determines the location for a given 2-D area request.  SiTA (Simple TILER algorithm) is the implementation behind that interface.  I will work on revising the acronym to avoid any conflicts.

-David     

-----Original Message-----
From: Linus Walleij [mailto:linus.ml.walleij@gmail.com] 
Sent: Saturday, July 24, 2010 6:48 PM
To: Sin, David
Cc: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 0/8] TI TILER-DMM driver

2010/7/24 David Sin <davidsin@ti.com>:

> TILER is a hardware block made by Texas Instruments.  Its purpose is to
> organize video/image memory in a 2-dimensional fashion to limit memory
> bandwidth and facilitate 0 effort rotation and mirroring.  The TILER
> driver facilitates allocating, freeing, as well as mapping 2D blocks (areas)
> in the TILER container(s).  It also facilitates rotating and mirroring
> the allocated blocks or its rectangular subsections.

Pretty cool hardware!

(...)
> * Add multiple search directions to TCM-SiTA
> * Add 1D block support (including adding 1D search algo to TCM-SiTA)

Spell out these acronyms. I've been writing some code for the ARM
TCM (Tightly Coupled Memory) and often vendors pick up this terminology
and call all on-chip memory "TCM", though it has a specific technical
meaning in ARM context.

What does TCM mean in your case?
And what is SiTA?

Yours,
Linus Walleij
