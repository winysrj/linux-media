Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:46902 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZEQV46 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 17:56:58 -0400
Date: Sun, 17 May 2009 16:56:58 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@isely.net>
Subject: Re: [PATCH 8/8] pvrusb2: Instantiate ir_video I2C device by default
In-Reply-To: <20090513215620.4b6b359a@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0905171656420.17519@cnc.isely.net>
References: <20090513214559.0f009231@hyperion.delvare>
 <20090513215620.4b6b359a@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 May 2009, Jean Delvare wrote:

> Now that the ir-kbd-i2c driver has been converted to a new-style i2c
> driver, we can instantiate the ir_video I2C device by default. The
> pvr2_disable_ir_video is kept to disable the IR receiver, either
> because the user doesn't use it, or for debugging purpose.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mike Isely <isely@pobox.com>

Acked-by: Mike Isely <isely@pobox.com>

> ---
>  linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-05-13 18:05:54.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-05-13 18:06:32.000000000 +0200
> @@ -43,7 +43,7 @@ static int ir_mode[PVR_NUM] = { [0 ... P
>  module_param_array(ir_mode, int, NULL, 0444);
>  MODULE_PARM_DESC(ir_mode,"specify: 0=disable IR reception, 1=normal IR");
>  
> -static int pvr2_disable_ir_video = 1;
> +static int pvr2_disable_ir_video;
>  module_param_named(disable_autoload_ir_video, pvr2_disable_ir_video,
>  		   int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(disable_autoload_ir_video,
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
