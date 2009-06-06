Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48877 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbZFFViP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 17:38:15 -0400
Date: Sat, 6 Jun 2009 18:38:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
 lists on the fly
Message-ID: <20090606183811.7e1d727c@pedra.chehab.org>
In-Reply-To: <200906061500.49338.hverkuil@xs4all.nl>
References: <200906061500.49338.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 6 Jun 2009 15:00:48 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> For video4linux we sometimes need to probe for a single i2c address. 
> Normally you would do it like this:
> 
> static const unsigned short addrs[] = {
> 	addr, I2C_CLIENT_END
> };
> 
> client = i2c_new_probed_device(adapter, &info, addrs);
> 
> This is a bit awkward and I came up with this macro:
> 
> #define V4L2_I2C_ADDRS(addr, addrs...) \
>         ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> 
> This can construct a list of one or more i2c addresses on the fly. But this 
> is something that really belongs in i2c.h, renamed to I2C_ADDRS.
> 
> With this macro we can just do:
> 
> client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
> 
> Comments?

Seems fine for me, but Your define has V4L2_foo.

Since this has nothing to do with V4L2, IMO, it is better to declare it as:

#define I2C_ADDRS(addr, addrs...) \
	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })



Cheers,
Mauro
