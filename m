Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53323 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0KLPet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 10:34:49 -0500
Date: Fri, 12 Nov 2010 15:34:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Jimmy Rubin <jimmy.rubin@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	linux-fbdev@vger.kernel.org,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/10] MCDE: Add configuration registers
Message-ID: <20101112153423.GC3619@n2100.arm.linux.org.uk>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com> <201011121614.51528.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011121614.51528.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 12, 2010 at 04:14:51PM +0100, Arnd Bergmann wrote:
> Some people prefer to express all this in C instead of macros:
> 
> struct mcde_registers {
> 	enum {
> 		mcde_cr_dsicmd2_en = 0x00000001,
> 		mcde_cr_dsicmd1_en = 0x00000002,
> 		...
> 	} cr;
> 	enum {
> 		mcde_conf0_syncmux0 = 0x00000001,
> 		...
> 	} conf0;
> 	...
> };
> 
> This gives you better type safety, but which one you choose is your decision.

It is a bad idea to describe device registers using C structures, and
especially enums.

The only thing C guarantees about structure layout is that the elements
are arranged in the same order which you specify them in your definition.
It doesn't make any guarantees about placement of those elements within
the structure.

As far as enums go, which type they correspond with is not really
predictable in portable code:

      6.7.2.2 Enumeration specifiers

     Constraints

4    Each enumerated type shall be compatible with char, a signed integer
     type, or an unsigned integer type. The choice of type is implementation-
     defined,108) but shall be capable of representing the values of all
     the members of the enumeration. The enumerated type is incomplete
     until after the } that terminates the list of enumerator declarations.

     108) An implementation may delay the choice of which integer type
          until all enumeration constants have been seen.

So, given your example above, an implementation (or architecture) may
decide that 'cr' is a 'char' represented by 8 bits, while another
implementation may decide that it is an 'int' of 32 bits.
