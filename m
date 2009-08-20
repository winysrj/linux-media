Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:56767 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbZHTHDG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 03:03:06 -0400
Date: Thu, 20 Aug 2009 09:01:44 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Andy Walls <awalls@radix.net>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: suspend tree build warnings
In-Reply-To: <1250729056.2716.37.camel@morgan.walls.org>
Message-ID: <alpine.LRH.1.10.0908200859060.7249@pub3.ifh.de>
References: <20090819172419.2cf53008.sfr@canb.auug.org.au>  <200908192338.03910.rjw@sisk.pl>  <20090819233601.GA2875@kroah.com> <1250729056.2716.37.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 19 Aug 2009, Andy Walls wrote:
>> Ick.  struct device should _never_ be on the stack, why would this code
>> want to do such a thing?

When you are doing a thing it does not necessarily you know that you're 
doing it.

> It appears that the state object is a dummy being used to detect and
> twiddle some identical chips on the i2c bus.  The functions called only
> use the "i2c_adapter" and "cfg" member of the dummy state object, but
> those functions want that state object as an input argument.
>
> <obvious>
> The simplest fix is dynamic allocation of the dummy state object with
> kmalloc() and then to free it before exiting the function.
> </obvious>

Even more obvious: Fix the function with simpler code to do the same 
thing.

I will try to fetch some time from somewhere to work on it.

--

Patrick 
http://www.kernellabs.com/
