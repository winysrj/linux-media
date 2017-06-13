Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62934 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdFMD5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 23:57:46 -0400
Date: Tue, 13 Jun 2017 12:57:43 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Anton Blanchard <anton@ozlabs.org>
Cc: mchehab@kernel.org, sean@mess.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] ir-spi: Fix issues with lirc API
Message-id: <20170613035743.cf6bvdiuxxonfg4d@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <20170507010011.2786-1-anton@ozlabs.org>
References: <CGME20170507010024epcas1p34864c073092a997d8941f58cc41b17b6@epcas1p3.samsung.com>
        <20170507010011.2786-1-anton@ozlabs.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anton,

On Sun, May 07, 2017 at 11:00:11AM +1000, Anton Blanchard wrote:
> From: Anton Blanchard <anton@samba.org>
> 
> The ir-spi driver has 2 issues which prevents it from working with
> lirc:
> 
> 1. The ir-spi driver uses 16 bits of SPI data to create one cycle of
> the waveform. As such our SPI clock needs to be 16x faster than the
> carrier frequency.
> 
> The driver is inconsistent in how it currently handles this. It
> initializes it to the carrier frequency:
> 
> But the commit message has some example code which initialises it
> to 16x the carrier frequency:
> 
> 	val = 608000;
> 	ret = ioctl(fd, LIRC_SET_SEND_CARRIER, &val);
> 
> To maintain compatibility with lirc, always do the frequency adjustment
> in the driver.
> 
> 2. lirc presents pulses in microseconds, but the ir-spi driver treats
> them as cycles of the carrier. Similar to other lirc drivers, do the
> conversion with DIV_ROUND_CLOSEST().
> 
> Fixes: fe052da49201 ("[media] rc: add support for IR LEDs driven through SPI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anton Blanchard <anton@samba.org>

Thanks for fixing it.

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

Andi
