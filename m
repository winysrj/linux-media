Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1IXDSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 23:18:16 -0400
Message-ID: <4E7D4BF4.9080901@redhat.com>
Date: Sat, 24 Sep 2011 00:18:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.2] gspca for_v3.2
References: <20110923103709.46363e45@tele>
In-Reply-To: <20110923103709.46363e45@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-09-2011 05:37, Jean-Francois Moine escreveu:
> Hi Mauro,
> 
> This set includes the patches:
> 	http://patchwork.linuxtv.org/patch/7358
> 	http://patchwork.linuxtv.org/patch/114

Thanks for doing that!

Applied, thanks!
 
> Cheers.
> 
> The following changes since commit e553000a14ead0e265a8aa4d241c7b3221e233e3:
> 
>   [media] sr030pc30: Remove empty s_stream op (2011-09-21 12:48:45 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_v3.2
> 
> Frank Schaefer (1):
>       gspca - sn9c20x: Fix status LED device 0c45:62b3.
> 
> Jean-François Moine (10):
>       gspca - benq: Remove the useless function sd_isoc_init
>       gspca - main: Use a better altsetting for image transfer
>       gspca - main: Handle the xHCI error on usb_set_interface()
>       gspca - topro: New subdriver for Topro webcams
>       gspca - spca1528: Increase the status waiting time
>       gspca - spca1528: Add some comments and update copyright
>       gspca - spca1528: Change the JPEG quality of the images
>       gspca - spca1528: Don't force the USB transfer alternate setting
>       gspca - main: Version change to 2.14.0
>       gspca - main: Display the subdriver name and version at probe time
> 
> Wolfram Sang (1):
>       gspca - zc3xx: New webcam 03f0:1b07 HP Premium Starter Cam
> 
>  Documentation/video4linux/gspca.txt  |    3 +
>  drivers/media/video/gspca/Kconfig    |   10 +
>  drivers/media/video/gspca/Makefile   |    2 +
>  drivers/media/video/gspca/benq.c     |   15 -
>  drivers/media/video/gspca/gspca.c    |  225 ++-
>  drivers/media/video/gspca/sn9c20x.c  |    2 +-
>  drivers/media/video/gspca/spca1528.c |   26 +-
>  drivers/media/video/gspca/topro.c    | 4989 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/gspca/zc3xx.c    |    1 +
>  9 files changed, 5180 insertions(+), 93 deletions(-)
>  create mode 100644 drivers/media/video/gspca/topro.c
> 

