Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.120]:43956 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754841AbeDZWFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 18:05:40 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id CCADE72EA
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 16:42:02 -0500 (CDT)
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
 <20180423161742.66f939ba@vento.lan>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
Date: Thu, 26 Apr 2018 16:41:56 -0500
MIME-Version: 1.0
In-Reply-To: <20180423161742.66f939ba@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 04/23/2018 02:17 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 23 Apr 2018 14:11:02 -0500
> 
> Thanks, I 'll mark this series as rejected at patchwork.linuxtv.org.
> Please feel free to resubmit any patch if they represent a real
> threat, adding a corresponding description about the threat scenario
> at the body of the e-mail.
> 
>> Sorry for the noise and thanks for the feedback.
> 
> Anytime.
> 

I noticed you changed the status of this series from rejected to new.

Also, there are other similar issues in media/pci/

I can write proper patches for all of them if you agree those are not 
False Positives:

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c 
b/drivers/media/pci/cx18/cx18-ioctl.c
index 80b902b..63f4388 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -36,6 +36,8 @@
  #include <media/tveeprom.h>
  #include <media/v4l2-event.h>

+#include <linux/nospec.h>
+
  u16 cx18_service2vbi(int type)
  {
         switch (type) {
@@ -488,8 +490,9 @@ static int cx18_enum_fmt_vid_cap(struct file *file, 
void *fh,
                 },
         };

-       if (fmt->index > ARRAY_SIZE(formats) - 1)
+       if (fmt->index >= ARRAY_SIZE(formats))
                 return -EINVAL;
+       fmt->index = array_index_nospec(fmt->index, ARRAY_SIZE(formats));
         *fmt = formats[fmt->index];
         return 0;
  }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c 
b/drivers/media/pci/saa7134/saa7134-video.c
index 1a50ec9..d93cf09 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -30,6 +30,8 @@
  #include <media/v4l2-event.h>
  #include <media/i2c/saa6588.h>

+#include <linux/nospec.h>
+
  /* ------------------------------------------------------------------ */

  unsigned int video_debug;
@@ -1819,6 +1821,8 @@ static int saa7134_enum_fmt_vid_cap(struct file 
*file, void  *priv,
         if (f->index >= FORMATS)
                 return -EINVAL;

+       f->index = array_index_nospec(f->index, FORMATS);
+
         strlcpy(f->description, formats[f->index].name,
                 sizeof(f->description));

diff --git a/drivers/media/pci/tw68/tw68-video.c 
b/drivers/media/pci/tw68/tw68-video.c
index 8c1f4a0..a6cfb4b 100644
--- a/drivers/media/pci/tw68/tw68-video.c
  #include <media/v4l2-event.h>
  #include <media/videobuf2-dma-sg.h>

+#include <linux/nospec.h>
+
  #include "tw68.h"
  #include "tw68-reg.h"

@@ -789,6 +791,8 @@ static int tw68_enum_fmt_vid_cap(struct file *file, 
void  *priv,
         if (f->index >= FORMATS)
                 return -EINVAL;

+       f->index = array_index_nospec(f->index, FORMATS);
+
         strlcpy(f->description, formats[f->index].name,
                 sizeof(f->description));

diff --git a/drivers/media/pci/tw686x/tw686x-video.c 
b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa9..281d722 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -25,6 +25,8 @@
  #include "tw686x.h"
  #include "tw686x-regs.h"

+#include <linux/nospec.h>
+
  #define TW686X_INPUTS_PER_CH           4
  #define TW686X_VIDEO_WIDTH             720
  #define TW686X_VIDEO_HEIGHT(id)                ((id & V4L2_STD_525_60) 
? 480 : 576)
@@ -981,6 +983,7 @@ static int tw686x_enum_fmt_vid_cap(struct file 
*file, void *priv,
  {
         if (f->index >= ARRAY_SIZE(formats))
                 return -EINVAL;
+       f->index = array_index_nospec(f->index, ARRAY_SIZE(formats));
         f->pixelformat = formats[f->index].fourcc;
         return 0;
  }


Thanks
--
Gustavo
