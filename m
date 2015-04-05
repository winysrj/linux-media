Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49970 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbbDEKyC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2015 06:54:02 -0400
Date: Sun, 5 Apr 2015 12:53:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Li <kassey1216@gmail.com>
cc: linux-media@vger.kernel.org, kasseyl@nvidia.com
Subject: Re: [PATCH V2] [media] V4L: soc-camera: add SPI device support
In-Reply-To: <1422864417-7296-1-git-send-email-kassey1216@gmail.com>
Message-ID: <Pine.LNX.4.64.1504051244360.20924@axis700.grange>
References: <1422864417-7296-1-git-send-email-kassey1216@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kassey,

Thanks for updating your patch and addressing my comments! In your reply 
to v1 of this patch you said, that you would add DT support in v2, i.e. in 
this version, right? Is it now present in this patch? If yes - can you 
explain to me how it works? For I2C the soc_camera_host_register() 
function calls scan_of_host() always when an OF node is present in the 
camera hostdevice, i.e. it would also be called in your SPI case, but the 
soc_of_bind() function, called there, explicitly uses I2C binding, so, it 
won't work for SPI. Could you explain?

Besides, you place your SPI support functions under #ifdef 
CONFIG_I2C_BOARDINFO, which doesn't make much sense for SPI.

Thanks
Guennadi

On Mon, 2 Feb 2015, Kassey Li wrote:

> From: Kassey Li <kasseyl@nvidia.com>
> 
> This adds support for spi interface sub device for
> soc_camera.
> 
> Signed-off-by: Kassey Li <kasseyl@nvidia.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |   94 ++++++++++++++++++++++++
>  include/media/soc_camera.h                     |    4 +
>  2 files changed, 98 insertions(+)

[patch omitted]
