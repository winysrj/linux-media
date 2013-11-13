Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43109 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab3KMSnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 13:43:47 -0500
Received: by mail-pa0-f49.google.com with SMTP id lf10so835878pab.8
        for <linux-media@vger.kernel.org>; Wed, 13 Nov 2013 10:43:46 -0800 (PST)
Message-ID: <5283C860.3020103@boundarydevices.com>
Date: Wed, 13 Nov 2013 11:43:44 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: Denis Carikli <denis@eukrea.com>, Shawn Guo <shawn.guo@linaro.org>
CC: Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	driverdev-devel@linuxdriverproject.org,
	David Airlie <airlied@linux.ie>, linux-media@vger.kernel.org,
	=?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
Subject: Re: [PATCHv4][ 3/7] staging: imx-drm: Add RGB666 support for parallel
 display.
References: <1384334603-14208-1-git-send-email-denis@eukrea.com> <1384334603-14208-3-git-send-email-denis@eukrea.com>
In-Reply-To: <1384334603-14208-3-git-send-email-denis@eukrea.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2013 2:23 AM, Denis Carikli wrote:
>   
> +	/* rgb666 */
> +	ipu_dc_map_clear(priv, IPU_DC_MAP_RGB666);
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 2, 17, 0xfc); /* red */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 1, 11, 0xfc); /* green */
> +	ipu_dc_map_config(priv, IPU_DC_MAP_RGB666, 0, 5, 0xfc); /* blue */
> +
>   	return 0;
>   }
>   
>

Since,  rgb24 and bgr24 reverse the byte numbers
/* rgb24 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_RGB24);
         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 0, 7, 0xff); /* blue */
         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 1, 15, 0xff); /* green */
         ipu_dc_map_config(priv, IPU_DC_MAP_RGB24, 2, 23, 0xff); /* red */

/* bgr24 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR24);
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 2, 7, 0xff); /* red */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 1, 15, 0xff); /* green */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR24, 0, 23, 0xff); /* blue */


Shouldn't rgb666 and bgr666 do the same?
Currently we have,

/* bgr666 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 5, 0xfc); /* blue */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* 
green */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 17, 0xfc); /* red */

Where I'd expect to see
/* bgr666 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_BGR666);
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 0, 17, 0xfc); /* blue */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 1, 11, 0xfc); /* 
green */
         ipu_dc_map_config(priv, IPU_DC_MAP_BGR666, 2, 5, 0xfc); /* red */


So, it looks like you are adding a duplicate of bgr666 because bgr666 is 
wrong.
Also, I'd prefer to keep the entries in 0,1,2 byte number order(blue, 
green, red,
assuming byte 0 is always blue) so that duplicates are easier to spot.

Not related to this patch, but the comments on gbr24 appear wrong as well.

/* gbr24 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_GBR24);
         ipu_dc_map_config(priv, IPU_DC_MAP_GBR24, 2, 15, 0xff); /* green */
         ipu_dc_map_config(priv, IPU_DC_MAP_GBR24, 1, 7, 0xff); /* blue */
         ipu_dc_map_config(priv, IPU_DC_MAP_GBR24, 0, 23, 0xff); /* red */

Should be
/* brg24 */
         ipu_dc_map_clear(priv, IPU_DC_MAP_BRG24);
         ipu_dc_map_config(priv, IPU_DC_MAP_BRG24, 0, 23, 0xff); /* blue*/
         ipu_dc_map_config(priv, IPU_DC_MAP_BRG24, 1, 7, 0xff); /* green */
         ipu_dc_map_config(priv, IPU_DC_MAP_BRG24, 2, 15, 0xff); /* red */

Of course, my understanding may be totally wrong. If so, please show me 
the light!


Troy

