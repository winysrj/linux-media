Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45285 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbeEROTC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:19:02 -0400
Received: by mail-wr0-f196.google.com with SMTP id w3-v6so1688620wrl.12
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 07:19:02 -0700 (PDT)
References: <20180518092806.3829-1-rui.silva@linaro.org> <20180518092806.3829-2-rui.silva@linaro.org> <1526639561.3948.2.camel@pengutronix.de>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v5 01/12] media: staging/imx: refactor imx media device probe
In-reply-to: <1526639561.3948.2.camel@pengutronix.de>
Date: Fri, 18 May 2018 15:18:57 +0100
Message-ID: <m3k1s1rqr2.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
Thanks for the quick review.

On Fri 18 May 2018 at 10:32, Philipp Zabel wrote:
> Hi Rui,
>
> thank you for refactoring, I think this is much better than 
> having the
> pretend capture-subsytem device in the DT.
>
> I would like to get rid of the ipu_present flag, if it can be 
> done
> reasonably. For details, see below.

Yes, I will try to come with something that will play along with 
your
comments. will be in v6.

---
Cheers,
	Rui
