Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:25178 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZFHMiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 08:38:55 -0400
Date: Mon, 8 Jun 2009 14:39:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
 lists on the fly
Message-ID: <20090608143932.36cd1b4f@hyperion.delvare>
In-Reply-To: <200906061500.49338.hverkuil@xs4all.nl>
References: <200906061500.49338.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, 6 Jun 2009 15:00:48 +0200, Hans Verkuil wrote:
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

I'm not a big fan of macros which hide how things work, but if this
makes your life easier, why not. Just send a patch and I'll queue it up
for 2.6.31.

-- 
Jean Delvare
