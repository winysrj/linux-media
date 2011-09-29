Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:35173 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab1I2GKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 02:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <1317221368-3301-3-git-send-email-archit@ti.com>
References: <1317221368-3301-1-git-send-email-archit@ti.com> <1317221368-3301-3-git-send-email-archit@ti.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Thu, 29 Sep 2011 11:40:21 +0530
Message-ID: <CAB2ybb-XPK-v4DqhjrNirqK+2osRSHSr5DRPAi_djsNG3XBYwg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
To: Archit Taneja <archit@ti.com>
Cc: hvaibhav@ti.com, tomi.valkeinen@ti.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 28, 2011 at 8:19 PM, Archit Taneja <archit@ti.com> wrote:
> Currently, there is a lot of redundant code is between DPI and VENC panels, this
> can be made common by moving out field/interlace specific code to a separate
> function called omapvid_handle_interlace_display(). There is no functional
> change made.
>
> Signed-off-by: Archit Taneja <archit@ti.com>
Reviewed-by: Sumit Semwal <sumit.semwal@ti.com>
<snip>
