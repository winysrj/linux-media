Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39519 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeEDOoi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:44:38 -0400
Message-ID: <1525445066.17782.38.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: imx: add support for RGB565_2X8 on parallel
 bus
From: Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        slongerbeam@gmail.com, p.zabel@pengutronix.de
Date: Fri, 04 May 2018 16:44:26 +0200
In-Reply-To: <201805041304.nDtDGKOf%fengguang.wu@intel.com>
References: <20180503164120.9912-3-jlu@pengutronix.de>
         <201805041304.nDtDGKOf%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-04 at 13:07 +0800, kbuild test robot wrote:
>    drivers/staging/media/imx/imx-media-csi.c: In function
> 'csi_setup':
> >> drivers/staging/media/imx/imx-media-csi.c:652:8: warning:
> assignment discards 'const' qualifier from pointer target type [-
> Wdiscarded-qualifiers]
>      outcc = priv->cc[priv->active_output_pad];
>            ^

I've fixed this and the unneeded semicolon for the next round.

Regards,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
