Return-path: <linux-media-owner@vger.kernel.org>
Received: from 92-243-34-74.adsl.nanet.at ([92.243.34.74]:42736 "EHLO
        mail.osadl.at" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754013AbdC2KnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 06:43:15 -0400
Date: Wed, 29 Mar 2017 10:43:09 +0000
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] m5mols: add missing dependency on
 VIDEO_IR_I2C
Message-ID: <20170329104309.GA24469@osadl.at>
References: <1481607848-24053-1-git-send-email-hofrat@osadl.org>
 <CGME20170329095611epcas1p38e8a9d321864202ce47de1d99ba578ce@epcas1p3.samsung.com>
 <42bdc11f-8202-c54c-a25c-5ac33b6bddae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42bdc11f-8202-c54c-a25c-5ac33b6bddae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 11:56:08AM +0200, Sylwester Nawrocki wrote:
> On 12/13/2016 06:44 AM, Nicholas Mc Guire wrote:
> >The Depends on: tag in Kconfig for CONFIG_VIDEO_M5MOLS does not list
> >VIDEO_IR_I2C so Kconfig displays the dependencies needed so the M-5MOLS
> >driver can not be found.
> >
> >Fixes: commit cb7a01ac324b ("[media] move i2c files into drivers/media/i2c")
> >Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> >---
> >
> >searching for VIDEO_M5MOLS in menuconfig currently shows the following
> >dependencies
> > Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=m] && \
> >             VIDEO_V4L2_SUBDEV_API [=y] && MEDIA_CAMERA_SUPPORT [=y]
> >but as the default settings include MEDIA_SUBDRV_AUTOSELECT=y the
> >"I2C module for IR" submenu (CONFIG_VIDEO_IR_I2C) is not displayed
> >adding the VIDEO_IR_I2C to the dependency list makes this clear
> 
> > drivers/media/i2c/m5mols/Kconfig | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/media/i2c/m5mols/Kconfig b/drivers/media/i2c/m5mols/Kconfig
> >index dc8c250..6847a1b 100644
> >--- a/drivers/media/i2c/m5mols/Kconfig
> >+++ b/drivers/media/i2c/m5mols/Kconfig
> >@@ -1,6 +1,6 @@
> > config VIDEO_M5MOLS
> > 	tristate "Fujitsu M-5MOLS 8MP sensor support"
> >-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> >+	depends on I2C && VIDEO_IR_I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> 
> There should be no need to enable the "I2C module for IR" to use m5mols
> driver, so the bug fix needs to be somewhere else.
>
yup - my bad - not clear how I came to that conclusion, guess it was due
to the indirection of VIDEO_M5MOLS needing !CONFIG_MEDIA_SUBDRV_AUTOSELECT

Step-by-step its:

0) x86_64_defconfig
  Depends on: MEDIA_SUPPORT [=n] && I2C [=y] && VIDEO_V4L2 [=n] && VIDEO_V4L2_SUBDEV_API [=n] && MEDIA_CAMERA_SUPPORT [=n]

1) <M> Multimedia support  --->
 Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=n] && VIDEO_V4L2_SUBDEV_API [=n] && MEDIA_CAMERA_SUPPORT [=n]

2)    [*]   Cameras/video grabbers support
 Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=m] && VIDEO_V4L2_SUBDEV_API [=n] && MEDIA_CAMERA_SUPPORT [=y]

3)    [*]   Media Controller API (NEW)
      [*]   V4L2 sub-device userspace API (NEW)
 Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=m] && VIDEO_V4L2_SUBDEV_API [=y] && MEDIA_CAMERA_SUPPORT [=y]

So now all listed dependencies are satisfied but the M-5MOLS drive is not
visible du to default CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

Not sure how I ended up with the VIDEO_IR_I2C dependency - which as you 
state - is wrong. though VIDEO_M5MOLS probably needs a 
!CONFIG_MEDIA_SUBDRV_AUTOSELECT in the dependency list though.

thx!
hofrat 
