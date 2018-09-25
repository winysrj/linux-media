Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39501 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729517AbeIYV2a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 17:28:30 -0400
Date: Tue, 25 Sep 2018 10:20:24 -0500
From: Rob Herring <robh@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, mark.rutland@arm.com, kernel@pengutronix.de,
        devicetree@vger.kernel.org, p.zabel@pengutronix.de,
        javierm@redhat.com, laurent.pinchart@ideasonboard.com,
        sakari.ailus@linux.intel.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/9] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20180925152024.GA18900@bogus>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
 <20180918131453.21031-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918131453.21031-2-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2018 at 03:14:45PM +0200, Marco Felsch wrote:
> From: Javier Martinez Canillas <javierm@redhat.com>
> 
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
> [m.felsch@pengutronix.de: rm TVP5150_INPUT_NUM define]
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/i2c/tvp5150.c         | 141 ----------------------------
>  include/dt-bindings/media/tvp5150.h |   2 -
>  2 files changed, 143 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
