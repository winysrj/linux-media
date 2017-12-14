Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdLNRCk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:02:40 -0500
Date: Thu, 14 Dec 2017 15:02:35 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [RESEND PATCH] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20171214150235.1d3abc8f@vento.lan>
In-Reply-To: <20171206003305.22895-1-javierm@redhat.com>
References: <20171206003305.22895-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Dec 2017 01:33:05 +0100
Javier Martinez Canillas <javierm@redhat.com> escreveu:

> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
> added input signals support for the tvp5150, but the approach was found
> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
> ("[media] tvp5150: document input connectors DT bindings") was reverted.
> 
> This left the driver with an undocumented (and wrong) DT parsing logic,
> so lets get rid of this code as well until the input connectors support
> is implemented properly.
> 
> It's a partial revert due other patches added on top of mentioned commit
> not allowing the commit to be reverted cleanly anymore. But all the code
> related to the DT parsing logic and input entities creation are removed.
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> ---
> 
> This patch was posted about a year ago but was never merged:
> 
> https://patchwork.kernel.org/patch/9472623/

It was a RFT, on that time.

I guess I told that before. Maybe not. Anyway, reverting it doesn't seem 
to be the proper fix, as it will break support for existing devices, by
removing functionality from tvp5150 driver. You should remind that, since
the code was added, someone could be already using it, as all it is
needed is to have some dtb. Also, it gets rid of a lot of good work for
no good reason. Reinserting them later while preserving the code
copyrights could be painful.

IMHO, the best here is to move ahead, agreeing with a DT structure
that represents the connectors and then change the driver to
implement it, if needed.

Thanks,
Mauro
