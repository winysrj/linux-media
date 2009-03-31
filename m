Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZCaK4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 06:56:20 -0400
Date: Tue, 31 Mar 2009 07:56:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Gabriele Dini Ciacci <dark.schneider@iol.it>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
Message-ID: <20090331075610.53620db8@pedra.chehab.org>
In-Reply-To: <20090329155608.396d2257@gdc1>
References: <20090329155608.396d2257@gdc1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gabriele,

On Sun, 29 Mar 2009 15:56:08 +0200
Gabriele Dini Ciacci <dark.schneider@iol.it> wrote:

> Hello,
> 
> This is a stub patch to make the subjects card work.
> 
> I am using the driver on a pctv60e and it is very stable, I use it
> daily. It should work for pctv200e but not owning the device I cannot
> test it.
> 
> The code need to be cleaned, as I am not an experienced kernel coder.
> The code in mt352.c contains an hard-coded address for the device, while
> Pinnalce devices with that tuner uses a different address. Currently
> the address is "hijacked" to be the correct one. This is a hack, and i
> think that mt352.c should be changed to support multiple addresses,
> selected via params, duplicate code or something.
> 
> Remote support is missing, cause it was not working out of the box. I
> do not use it and so developing it for myself only was not very useful,
> if someone wants it or is interested I can have a look.
> 
> The patch is generally messy, I need help there. I do not know if I
> have to change all the functions to take as parameter an adapter_nr or
> change the caller to continue to pass them a struct dvb_usb_device
> obtained with i2c_get_adapdata(adapter_nr).
> 
> Here is the patch, as an attachment, thanks meanwhile.

Well, let's go by parts. 

It seems that you wrote your driver based on some USB sniffing. Do you know
what are the chipsets present on your driver? Maybe there's another driver
already developed or under development for the same chipset.

In the case of your patch, you should first run checkpatch.pl for it to show you
the non-compliances of your driver and Linux Kernel CodingStyle. checkpatch.pl
is avaliable at kernel tree, under /scripts dir. You'll also find it at v4l-dvb
development tree, at v4l/script/checkpatch.pl.

It is also a good idea to read README.patches at v4l-dvb development tree.

Cheers,
Mauro
