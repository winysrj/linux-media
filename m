Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:59051 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbcCWQ7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 12:59:01 -0400
Message-ID: <56F2CB4D.4030104@lysator.liu.se>
Date: Wed, 23 Mar 2016 17:58:53 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] si2168: use i2c controlled mux interface
References: <1452058920-9797-1-git-send-email-crope@iki.fi>
In-Reply-To: <1452058920-9797-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-01-06 06:42, Antti Palosaari wrote:
> Recent i2c mux locking update offers support for i2c controlled i2c
> muxes. Use it and get the rid of homemade hackish i2c adapter
> locking code.

[actual patch elided]

I had a 2nd look and it seems that the saa7164 driver has support for
a HVR2055 card with dual si2168 chips. These two chips appear to sit
on the same i2c-bus with different i2c-addresses (0x64 and 0x66) and
with gates (implemented as muxes) to two identical tuners with the
same i2c-address (0x60). Do I read it right?

With the current i2c-mux-locking (parent-locked muxes), this works
fine as an access to one of the tuners locks the root i2c adapter
and thus the other tuner is also locked out. But with the upcoming
i2c-mux-locking for i2c-controlled muxes (self-locked muxes), the
root i2c adapter would no longer be locked for the full transaction
when one of the tuners is accessed. This means that accesses to the
two tuners may interleave and cause all kinds of trouble, should
both gates be open at the same time. So, is it really correct and
safe to change the si2168 driver to use a self-locked mux?

Unless there is some other mechanism that prevents the two tuners
from being accessed in parallel, I think not. But maybe there is such
a mechanism?

Cheers,
Peter
