Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:41431 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeGCXTm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 19:19:42 -0400
Date: Tue, 3 Jul 2018 17:19:38 -0600
From: Rob Herring <robh@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, javierm@redhat.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20180703231938.GA16381@rob-hp-laptop>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-19-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628162054.25613-19-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 06:20:50PM +0200, Marco Felsch wrote:
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
> ---
>  drivers/media/i2c/tvp5150.c         | 141 ----------------------------

>  include/dt-bindings/media/tvp5150.h |   2 -

Acked-by: Rob Herring <robh@kernel.org>

>  2 files changed, 143 deletions(-)
