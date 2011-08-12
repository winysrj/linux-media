Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47817 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HLUjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 16:39:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ravi, Deepthy" <deepthy.ravi@ti.com>
Subject: Re: [QUERY] Inclusion of isp.h in board-omap3evm-camera.c
Date: Fri, 12 Aug 2011 22:39:16 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Koyamangalath, Abhilash" <abhilash.kv@ti.com>
References: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907CF@dbde03.ent.ti.com>
In-Reply-To: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907CF@dbde03.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108122239.17315.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ravi,

On Friday 12 August 2011 09:35:16 Ravi, Deepthy wrote:
> I need to use some isp structures ( isp_v4l2_subdevs_group,
> isp_platform_data ,isp_subdev_i2c_board_info etc.) in 
> board-omap3evm-camera.c. For that header file isp.h has to be included .
> Currently I am including it in this way:
> 
> #include <../drivers/media/video/omap3isp/isp.h>

OMAP3 ISP platform data should be split from isp.h into 
include/media/omap3isp.h. I've sent a patch for that to the linux-media 
mailing list and CC'ed you.

Unfortunately that won't be enough, as board code currently requires the 
isp_device structure definition to access the platform callback functions. 
Those functions will be removed in the future when more generic alternatives 
will be available, but there's still some work required for that.

> Is there a better way to do this ? The relevant hunk of the patch is shown
> below:
> 
> diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> index 0000000..319a6a1
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> +#include <linux/io.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <mach/gpio.h>
> +
> +#include <media/tvp514x.h>
> +
> +#include <../drivers/media/video/omap3isp/isp.h>

#include "../drivers/media/video/omap3isp/isp.h"

but that's not really better :-)

You should include <media/omap3isp.h> (after applying the patch that creates 
that file). If your board code doesn't use the OMAP3 ISP platform callback 
functions, you don't need to include the isp.h header at all.

-- 
Regards,

Laurent Pinchart
