Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35605 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3HWJyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:54:33 -0400
Message-id: <52173155.9090902@samsung.com>
Date: Fri, 23 Aug 2013 11:54:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [media] s5p-csis: Add support for non-image data packets capture
References: <20130823093504.GJ31293@elgon.mountain>
In-reply-to: <20130823093504.GJ31293@elgon.mountain>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2013 11:35 AM, Dan Carpenter wrote:
> Hello Sylwester Nawrocki,
> 
> I had a question about 36fa80927638: "[media] s5p-csis: Add support for
> non-image data packets capture" from Sep 21, 2012.
> 
> S5PCSIS_INTSRC_NON_IMAGE_DATA is defined in mipi-csis.c:
> 
> #define S5PCSIS_INTSRC_NON_IMAGE_DATA   (0xff << 28)

This is supposed to be a mask for bits [31:28], so (0xf << 28)

> And it's only used in one place.
> 
> drivers/media/platform/exynos4-is/mipi-csis.c
>    692          u32 status;
>    693  
>    694          status = s5pcsis_read(state, S5PCSIS_INTSRC);
>    695          spin_lock_irqsave(&state->slock, flags);
>    696  
>    697          if ((status & S5PCSIS_INTSRC_NON_IMAGE_DATA) && pktbuf->data) {
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> "status" is a u32 so 0xff0000000 is 4 bits too much.  In other words,
> the mask is effectively "(0xf << 28)".  Was that intended or should it
> be (0xff << 24)?

It should be (0xf << 28). Thanks for looking into this.
