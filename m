Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35237 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbDCDoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2015 23:44:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4] v4l: mt9v032: Add OF support
Date: Fri, 03 Apr 2015 06:43:54 +0300
Message-ID: <21661171.kVBHEenSxY@avalon>
In-Reply-To: <1427814533.2969.61.camel@pengutronix.de>
References: <1426685926-22946-1-git-send-email-laurent.pinchart@ideasonboard.com> <1427814533.2969.61.camel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the review.

On Tuesday 31 March 2015 17:08:53 Philipp Zabel wrote:
> Am Mittwoch, den 18.03.2015, 15:38 +0200 schrieb Laurent Pinchart:
> > Parse DT properties into a platform data structure when a DT node is
> > available.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > ---
> > 
> > Changes since v3:
> > 
> > - Use /bits/ 64 in the DT bindings example
> > - Remove the parent I2C master node from the DT bindings example
> > - Use devm_kcalloc() to allocate array
> > 
> > Changes since v2:
> > 
> > - Use of_graph_get_next_endpoint()
> > 
> > Changes since v1:
> > 
> > - Add MT9V02[24] compatible strings
> > - Prefix all compatible strings with "aptina,"
> > - Use "link-frequencies" instead of "link-freqs"
> > ---
> > 
> >  .../devicetree/bindings/media/i2c/mt9v032.txt      | 39 ++++++++++++
> >  MAINTAINERS                                        |  1 +
> >  drivers/media/i2c/mt9v032.c                        | 69 ++++++++++++++++-
> >  3 files changed, 108 insertions(+), 1 deletion(-)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/i2c/mt9v032.txt

[snip]

> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 255ea91..697be25 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -17,6 +17,8 @@
> >  #include <linux/i2c.h>
> >  #include <linux/log2.h>
> >  #include <linux/mutex.h>
> > +#include <linux/of.h>
> > +#include <linux/of_gpio.h>
> 
> I think of_gpio is not needed in mt9v032.c. Otherwise,
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

You're right. The bad news is that the patch has been merged already. The good 
news is that you can submit a patch to fix this ;-) I can also fix it myself 
if you prefer.

-- 
Regards,

Laurent Pinchart

