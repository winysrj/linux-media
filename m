Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1IUUOc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 16:14:32 -0400
Message-ID: <4E7A45A4.7000001@redhat.com>
Date: Wed, 21 Sep 2011 17:14:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.2] gspca for_v3.2
References: <20110812103749.0ba22d60@tele>
In-Reply-To: <20110812103749.0ba22d60@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-08-2011 05:37, Jean-Francois Moine escreveu:
> The following changes since commit
> 9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e:
> 
>   [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028 (2011-08-06 09:52:47 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_v3.2

Jean-François,

The last 3 patches didn't apply. Could you please re-base them over the
current tree?

Thanks!
Mauro
> 
> Jean-François Moine (15):
>       gspca - ov519: Fix LED inversion of some ov519 webcams
>       gspca - sonixj: Fix the darkness of sensor om6802 in 320x240
>       gspca - jeilinj: Cleanup code
>       gspca - sonixj: Adjust the contrast control
>       gspca - sonixj: Increase the exposure for sensor soi768
>       gspca - sonixj: Cleanup source and remove useless instructions
>       gspca - benq: Remove the useless function sd_isoc_init
>       gspca - kinect: Remove the gspca_debug definition
>       gspca - ov534_9: Use the new control mechanism
>       gspca - ov534_9: New sensor ov9712 and new webcam 05a9:8065
>       gspca - main: Fix the isochronous transfer interval
>       gspca - main: Better values for V4L2_FMT_FLAG_COMPRESSED
>       gspca - main: Use a better altsetting for image transfer
>       gspca - main: Handle the xHCI error on usb_set_interface()
>       gspca - tp6800: New subdriver for Topro webcams
> 
> Luiz Carlos Ramos (1):
>       gspca - sonixj: Fix wrong register mask for sensor om6802
> 
>  Documentation/video4linux/gspca.txt |    3 +
>  drivers/media/video/gspca/Kconfig   |    9 +
>  drivers/media/video/gspca/Makefile  |    2 +
>  drivers/media/video/gspca/benq.c    |   15 -
>  drivers/media/video/gspca/gspca.c   |  234 ++-
>  drivers/media/video/gspca/jeilinj.c |   10 +-
>  drivers/media/video/gspca/kinect.c  |    5 -
>  drivers/media/video/gspca/ov519.c   |   22 +-
>  drivers/media/video/gspca/ov534_9.c |  504 ++--
>  drivers/media/video/gspca/sonixj.c  |   29 +-
>  drivers/media/video/gspca/tp6800.c  | 4989 +++++++++++++++++++++++++++++++++++
>  11 files changed, 5430 insertions(+), 392 deletions(-)
>  create mode 100644 drivers/media/video/gspca/tp6800.c
> 

