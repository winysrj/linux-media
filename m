Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbeJHXJv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 19:09:51 -0400
Date: Mon, 8 Oct 2018 12:57:22 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [GIT PULL for 4.20] Lens driver fixes, imx214 sensor driver
Message-ID: <20181008125722.68fc5f2d@coco.lan>
In-Reply-To: <20181007130557.dfjrfvv2tip2inpr@valkosipuli.retiisi.org.uk>
References: <20181007130557.dfjrfvv2tip2inpr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 Oct 2018 16:05:57 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> This last pull for 4.20 contains dw9714 and dw9807 lens driver probe error
> handling fixes and the Sony imx214 sensor driver. In other words, patches
> that have roughly nil changes of breaking something.
> 
> Compile tested with and without both subdev uAPI and MC on x86-64, plus on
> arm as well.
> 
> Please pull.
> 
> 
> The following changes since commit 557c97b5133669297be561e6091da9ab6e488e65:
> 
>   media: cec: name for RC passthrough device does not need 'RC for' (2018-10-05 11:28:13 -0400)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-11-sign
> 
> for you to fetch changes up to a8f772a119afcc1dfabf4d8b7e258b9f90d2c561:
> 
>   imx214: Add imx214 camera sensor driver (2018-10-06 21:20:40 +0300)
> 
> ----------------------------------------------------------------
> dw9714 and dw9807 fixes; imx214 driver
> 
> ----------------------------------------------------------------
> Rajmohan Mani (1):
>       media: dw9714: Fix error handling in probe function
> 
> Ricardo Ribalda Delgado (2):
>       imx214: device tree binding
>       imx214: Add imx214 camera sensor driver

I'm missing the ack from Rob on the DT patch. Will apply the
remaining ones from this series as they're independent.


> 
> Sakari Ailus (2):
>       dw9714: Remove useless error message
>       dw9807-vcm: Fix probe error handling

> 
>  .../devicetree/bindings/media/i2c/sony,imx214.txt  |   53 +
>  MAINTAINERS                                        |    8 +
>  drivers/media/i2c/Kconfig                          |   12 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/dw9714.c                         |    5 +-
>  drivers/media/i2c/dw9807-vcm.c                     |    3 +-
>  drivers/media/i2c/imx214.c                         | 1118 ++++++++++++++++++++
>  7 files changed, 1197 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/sony,imx214.txt
>  create mode 100644 drivers/media/i2c/imx214.c
> 

Thanks,
Mauro
