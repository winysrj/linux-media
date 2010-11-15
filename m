Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:58336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0KOOZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:25:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 02/10] MCDE: Add configuration registers
Date: Mon, 15 Nov 2010 15:25:54 +0100
Cc: linux-arm-kernel@lists.infradead.org,
	Jimmy Rubin <jimmy.rubin@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	linux-fbdev@vger.kernel.org,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-media@vger.kernel.org
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <201011121614.51528.arnd@arndb.de> <20101112153423.GC3619@n2100.arm.linux.org.uk>
In-Reply-To: <20101112153423.GC3619@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151525.54380.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 12 November 2010, Russell King - ARM Linux wrote:
> On Fri, Nov 12, 2010 at 04:14:51PM +0100, Arnd Bergmann wrote:
> > Some people prefer to express all this in C instead of macros:
> > 
> > struct mcde_registers {
> > 	enum {
> > 		mcde_cr_dsicmd2_en = 0x00000001,
> > 		mcde_cr_dsicmd1_en = 0x00000002,
> > 		...
> > 	} cr;
> > 	enum {
> > 		mcde_conf0_syncmux0 = 0x00000001,
> > 		...
> > 	} conf0;
> > 	...
> > };
> > 
> > This gives you better type safety, but which one you choose is your decision.
> 
> It is a bad idea to describe device registers using C structures, and
> especially enums.
> 
> The only thing C guarantees about structure layout is that the elements
> are arranged in the same order which you specify them in your definition.
> It doesn't make any guarantees about placement of those elements within
> the structure.

Right, I got carried away when seeing the macro overload. My example
would work on a given architecture since the ABI is not changing, but
we should of course not advocate nonportable code.

Normally what I do is to describe the data structure in C and define the
values in a separate enum. The main advantage of using the struct instead
of offset defines is that you have a bit more type safety, i.e. you cannot
accidentally do readw() on a __be32 member.

Using #define for the actual values makes it possible to interleave the
values with the structure definition like 

struct mcde_registers {
 	__le32 cr;
#define MCDE_CR_DSICMD2_EN 0x00000001
#define MCDE_CR_DSICMD1_EN 0x00000002
	__le32 conf0;
 	...
};

whereas the enum has the small advantage of putting the identifiers
into the C language namespace rather than the preprocessor macro
namespace.

	Arnd
