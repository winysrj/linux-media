Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57647 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934320AbcIFJ25 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 05:28:57 -0400
Message-ID: <1473154130.2805.92.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: add missing header dependencies
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Baoyou Xie <baoyou.xie@linaro.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        xie.baoyou@zte.com.cn
Date: Tue, 06 Sep 2016 11:28:50 +0200
In-Reply-To: <17845866.BEgCsGq73Z@wuerfel>
References: <1473148256-25347-1-git-send-email-baoyou.xie@linaro.org>
         <17845866.BEgCsGq73Z@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 06.09.2016, 11:21 +0200 schrieb Arnd Bergmann:
> On Tuesday, September 6, 2016 3:50:56 PM CEST Baoyou Xie wrote:
> >  #include <linux/kernel.h>
> >  #include <linux/string.h>
> > +#include <coda.h>
> > 
> 
> by convention, we tend to write this as
> 
> #include "coda.h"
> 
> otherwise the patch looks good to me,
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Same here, make that

+
+#include "coda.h"

and feel free to add
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

