Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:52361 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0JUM4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 08:56:17 -0400
Date: Thu, 21 Oct 2010 14:56:09 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <008101cb710f$08af85c0$1a0e9140$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <000a01cb711f$5820a390$0861eab0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
 <008101cb710f$08af85c0$1a0e9140$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

> I have some opinion about the usage of
> wait_event_interruptible_timeout()
> 
> 
> k.debski@samsung.com wrote:
> [snip]
> 
> > +
> > diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
> > b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
> > new file mode 100644
> > index 0000000..543f3fb
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
> > @@ -0,0 +1,77 @@
> > +/*
> > + * drivers/media/video/samsung/mfc5/s5p_mfc_intr.c
> > + *
> > + * C file for Samsung MFC (Multi Function Codec - FIMV) driver
> > + * This file contains functions used to wait for command completion.
> > + *
> > + * Kamil Debski, Copyright (c) 2010 Samsung Electronics
> > + * http://www.samsung.com/
> > + *
> > + * This program is free software; you can redistribute it and/or
> modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/wait.h>
> > +#include <linux/sched.h>
> > +#include <linux/io.h>
> > +#include "regs-mfc5.h"
> > +#include "s5p_mfc_intr.h"
> > +#include "s5p_mfc_logmsg.h"
> > +#include "s5p_mfc_common.h"
> > +
> > +int s5p_mfc_wait_for_done_dev(struct s5p_mfc_dev *dev, int command)
> > +{
> > +	if (wait_event_interruptible_timeout(dev->queue,
> > +		(dev->int_cond && (dev->int_type == command
> > +		|| dev->int_type == S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
> > +		msecs_to_jiffies(MFC_INT_TIMEOUT)) == 0) {
> > +		mfc_err("Interrupt (%d dev) timed out.\n", dev->int_type);
> > +		return 1;
> > +	}
> > +	mfc_debug("Finished waiting (dev->queue, %d).\n", dev->int_type);
> > +	if (dev->int_type == S5P_FIMV_R2H_CMD_ERROR_RET)
> > +		return 1;
> > +	return 0;
> > +}
> 
> 
> You used wait_event_interruptible_timeout() in the driver, but this
> function is
> considered not only int. by MFC but also int. by some signal. I'm
> wondering
> whether we have to consider interrupt by signal in the middle of hw
> operation.
> and also I cannot see some operation(handler) in case of wake-up by
> signal.
> So, why don't you remove the interruptible function or add some
> operation
> in case of
> wake-up by signal. (refer to the other driver in the kernel)

I can see a situation when handling a signal might be useful. If for some
reason (corrupt firmware file for example) the MFC fails to initialize then
the
application will seem "frozen" to the user. The user can press Ctrl-C and
expects the app to terminate. This would not happen if the used wait
procedure
was non interruptible.

Therefore I think adding code to handle signal is better than changing this
wait
to non interruptible.

> 
> > +
> > +void s5p_mfc_clean_dev_int_flags(struct s5p_mfc_dev *dev)
> > +{
> > +	dev->int_cond = 0;
> > +	dev->int_type = 0;
> > +	dev->int_err = 0;
> > +}
> > +
> > +int s5p_mfc_wait_for_done_ctx(struct s5p_mfc_ctx *ctx,
> > +				    int command, int interrupt)
> > +{
> > +	int ret;
> > +	if (interrupt) {
> > +		ret = wait_event_interruptible_timeout(ctx->queue,
> > +				(ctx->int_cond && (ctx->int_type == command
> > +			|| ctx->int_type ==
> S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
> > +					msecs_to_jiffies(MFC_INT_TIMEOUT));
> > +	} else {
> > +		ret = wait_event_timeout(ctx->queue,
> > +				(ctx->int_cond && (ctx->int_type == command
> > +			|| ctx->int_type ==
> S5P_FIMV_R2H_CMD_DECODE_ERR_RET)),
> > +					msecs_to_jiffies(MFC_INT_TIMEOUT));
> > +	}
> > +	if (ret == 0) {
> > +		mfc_err("Interrupt (%d ctx) timed out.\n", ctx->int_type);
> > +		return 1;
> > +	}
> > +	mfc_debug("Finished waiting (ctx->queue, %d).\n", ctx->int_type);
> > +	if (ctx->int_type == S5P_FIMV_R2H_CMD_ERROR_RET)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +void s5p_mfc_clean_ctx_int_flags(struct s5p_mfc_ctx *ctx)
> > +{
> > +	ctx->int_cond = 0;
> > +	ctx->int_type = 0;
> > +	ctx->int_err = 0;
> > +}
> 
> [snip]
> 

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

