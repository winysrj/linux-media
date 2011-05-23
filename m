Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41997 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1EWRSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 13:18:05 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 23 May 2011 22:47:53 +0530
Subject: RE: [PATCH 1/1] davinci: dm646x: move vpif related code to driver
 core	header from platform
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D09B435@dbde02.ent.ti.com>
References: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1305899929-2509-1-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, May 20, 2011 at 19:28:49, Hadli, Manjunath wrote:
> move vpif related code for capture and display drivers
> from dm646x platform header file to vpif.h as these definitions
> are related to driver code more than the platform or board.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

> diff --git a/drivers/media/video/davinci/vpif.h b/drivers/media/video/davinci/vpif.h
> index 10550bd..e76dded 100644
> --- a/drivers/media/video/davinci/vpif.h
> +++ b/drivers/media/video/davinci/vpif.h
> @@ -20,6 +20,7 @@
>  #include <linux/videodev2.h>
>  #include <mach/hardware.h>
>  #include <mach/dm646x.h>
> +#include <media/davinci/vpif.h>

mach/hardware.h and mach/dm646x.h can now be dropped.

Thanks,
Sekhar
