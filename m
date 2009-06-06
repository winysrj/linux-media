Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:37786 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZFFRc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 13:32:58 -0400
Date: Sat, 6 Jun 2009 10:32:59 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
 lists on the fly
In-Reply-To: <200906061500.49338.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0906061015421.32713@shell2.speakeasy.net>
References: <200906061500.49338.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Jun 2009, Hans Verkuil wrote:
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

I agree it's better placed with i2c.h.  It's also possible to come up with
a more syntax more variadic function like, which can be called like this:

i2c_new_probed_device(adapter, &info, addr1);

i2c_new_probed_device(adapter, &info, addr1, addr2);


Using a macro like this...

#define i2c_new_probed_device(adap,info,addr,addrs...) ({ \
	const unsigned short _addrs[] = {addr, ## addrs, I2C_CLIENT_END }; \
	_i2c_new_probed_device(adap, info, _addrs); })
