Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.crowfest.net ([52.42.241.221]:42932 "EHLO gw.crowfest.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdA2OWr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jan 2017 09:22:47 -0500
Message-ID: <1485699123.2075.1.camel@crowfest.net>
Subject: Re: [PATCH 3/6] staging: bcm2835-v4l2: Add a build system for the
 module.
From: Michael Zoran <mzoran@crowfest.net>
To: Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Sun, 29 Jan 2017 06:12:03 -0800
In-Reply-To: <20170127215503.13208-4-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
         <20170127215503.13208-4-eric@anholt.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-27 at 13:55 -0800, Eric Anholt wrote:
> This is derived from the downstream tree's build system, but with
> just
> a single Kconfig option.
> 
> For now the driver only builds on 32-bit arm -- the aarch64 build
> breaks due to the driver using arm-specific cache flushing functions.
> 
> 

If you are referring to this:
/* enqueue a bulk receive for a given message context */
static int bulk_receive(struct vchiq_mmal_instance *instance,
			struct mmal_msg *msg,
			struct mmal_msg_context *msg_context)
...

	// only need to flush L1 cache here, as VCHIQ takes care of the
L2
	// cache.
	__cpuc_flush_dcache_area(msg_context->u.bulk.buffer->buffer,
rd_len);


It should be possible to simply remove the __cpuc_flash_dcache_area
call as VCHIQ should now be flushing all the needed caches.  This is
due to the DMA API clean that was necessary to make it multiplatform.

The driver does have a few nasty issues with stuffing callback pointers
into fixed 32 bit sized integers that would need to be fixed to make it
work on 64 bit.




