Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34706 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751258AbdJMUst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 16:48:49 -0400
Date: Fri, 13 Oct 2017 23:48:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: Re: [PATCH 0/4] media: ov7670: add media controller support
Message-ID: <20171013204843.eho3dhkeltvjnajd@valkosipuli.retiisi.org.uk>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On Fri, Oct 13, 2017 at 01:21:13AM +0900, Akinobu Mita wrote:
> This series adds media controller support and other related changes to the
> OV7670 which is cheap and highly available CMOS image sensor for hobbyists.
> 
> This enables to control a video pipeline system with the OV7670.  I've
> tested this with the xilinx video IP pipeline.
> 
> Akinobu Mita (4):
>   media: ov7670: create subdevice device node
>   media: ov7670: use v4l2_async_unregister_subdev()
>   media: ov7670: add media controller support
>   media: ov7670: add get_fmt() pad ops callback
> 
>  drivers/media/i2c/ov7670.c | 55 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 1 deletion(-)

I understand Wenyou has submitted a set with similar functionality +
runtime PM as well, but it has issues. There hasn't been updated for some
time on that. Wenyou, what's the status of your patchset?

The set was submitted on the list under subject "[PATCH v5 0/3] media:
ov7670: Add entity init and power operation"

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
