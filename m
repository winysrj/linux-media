Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2IYSkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 14:40:35 -0400
Date: Tue, 25 Sep 2012 15:40:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, jwilson@redhat.com, sean@mess.org
Subject: Re: [PATCH 4/8] rc-core: don't throw away protocol information
Message-ID: <20120925154022.0d6b44c4@redhat.com>
In-Reply-To: <20120825214708.22603.30247.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
	<20120825214708.22603.30247.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Aug 2012 23:47:08 +0200
David Härdeman <david@hardeman.nu> escreveu:


Pathes 1 to 3 are OK. Applied, thanks!

...

> +#define RC_SCANCODE_UNKNOWN(x) (x)
> +#define RC_SCANCODE_OTHER(x) (x)
> +#define RC_SCANCODE_NEC(addr, cmd) (((addr) << 8) | (cmd))
> +#define RC_SCANCODE_NECX(addr, cmd) (((addr) << 8) | (cmd))
> +#define RC_SCANCODE_NEC32(data) ((data) & 0xffffffff)
> +#define RC_SCANCODE_RC5(sys, cmd) (((sys) << 8) | (cmd))
> +#define RC_SCANCODE_RC5_SZ(sys, cmd) (((sys) << 8) | (cmd))
> +#define RC_SCANCODE_RC6_0(sys, cmd) (((sys) << 8) | (cmd))
> +#define RC_SCANCODE_RC6_6A(vendor, sys, cmd) (((vendor) << 16) | ((sys) << 8) | (cmd))


Huh? You're defining the same code for NEC, NECX, RC5, ...

Why? It seems better to have one macro for (up to) 16 bit protocols,
and another one for the two 32 bit ones.

Btw, on several drivers, you're using the wrong macro name. It doesn't seem
fine to miss-use it.

For example, see the generic I2C driver: several of the remote controllers
there are NEC[1]. Yet, you're using there the RC5 variant.

[1] Currently, they're using "other" because we don't have that IR's or the
devices that use it here, in order to make it scan the full NEC (or NEC
variant) code.

-- 
Regards,
Mauro
