Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52375 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab1I2F7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 01:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <1317221368-3301-4-git-send-email-archit@ti.com>
References: <1317221368-3301-1-git-send-email-archit@ti.com> <1317221368-3301-4-git-send-email-archit@ti.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Thu, 29 Sep 2011 11:29:31 +0530
Message-ID: <CAB2ybb9OLHt=Z9s7s=V+46G_WWT5YbPAxFr6Ju8HS5owZb9CbA@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
To: Archit Taneja <archit@ti.com>
Cc: hvaibhav@ti.com, tomi.valkeinen@ti.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 28, 2011 at 8:19 PM, Archit Taneja <archit@ti.com> wrote:
> Currently, in omap_vout_isr(), if the panel type is DPI, and if we
> get either VSYNC or VSYNC2 interrupts, we proceed ahead to set the
> current buffers state to VIDEOBUF_DONE and prepare to display the
> next frame in the queue.
>
> On OMAP4, because we have 2 LCD managers, the panel type itself is not
> sufficient to tell if we have received the correct irq, i.e, we shouldn't
> proceed ahead if we get a VSYNC interrupt for LCD2 manager, or a VSYNC2
> interrupt for LCD manager.
>
> Fix this by correlating LCD manager to VSYNC interrupt and LCD2 manager
> to VSYNC2 interrupt.
>
> Signed-off-by: Archit Taneja <archit@ti.com>
Reviewed-by: Sumit Semwal <sumit.semwal@ti.com>
<snip>
