Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50056 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933959AbeFGPgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Jun 2018 11:36:47 -0400
Date: Thu, 7 Jun 2018 17:36:46 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: "media: ov5640: Add horizontal and vertical totals" regression
 issue on i.MX6QDL
Message-ID: <20180607153646.jlif4hukbyfkvjfx@flea>
References: <CAMty3ZCjNHUeHAJCDjoTHh_w1nNkUFTLjbp1=sYuF2DRiz-E-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAMty3ZCjNHUeHAJCDjoTHh_w1nNkUFTLjbp1=sYuF2DRiz-E-g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 07, 2018 at 08:02:28PM +0530, Jagan Teki wrote:
> Hi,
> 
> ov5640 camera is breaking with below commit on i.MXQDL platform.
> 
>     commit 476dec012f4c6545b0b7599cd9adba2ed819ad3b
>     Author: Maxime Ripard <maxime.ripard@bootlin.com>
>     Date:   Mon Apr 16 08:36:55 2018 -0400
> 
>     media: ov5640: Add horizontal and vertical totals
> 
>     All the initialization arrays are changing the horizontal and vertical
>     totals for some value.
> 
>     In order to clean up the driver, and since we're going to need that value
>     later on, let's introduce in the ov5640_mode_info structure the horizontal
>     and vertical total sizes, and move these out of the bytes array.
> 
>     Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>     Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> We have reproduced as below [1] and along with ipu1_csi0 pipeline. I
> haven't debug further please let us know how to move further.
> 
> media-ctl --links "'ov5640 2-003c':0->'imx6-mipi-csi2':0[1]"
> media-ctl --links "'imx6-mipi-csi2':1->'ipu1_csi0_mux':0[1]"
> media-ctl --links "'ipu1_csi0_mux':2->'ipu1_csi0':0[1]"
> media-ctl --links "'ipu1_csi0':2->'ipu1_csi0 capture':0[1]"
> 
> media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/640x480 field:none]"
> media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY2X8/640x480 field:none]"
> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/640x480 field:none]"
> media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:AYUV32/640x480 field:none]"
> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/640x480 field:none]"
> 
> [1] https://lkml.org/lkml/2018/5/31/543

Yeah, this has already been reported as part as this serie:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg131655.html

and some suggestions have been done here:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg132570.html

Feel free to help debug this.

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
