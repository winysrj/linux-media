Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51668 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdAMKVr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 05:21:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Marek Vasut <marex@denx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Attila Kinali <attila@kinali.ch>,
        Luca Barbato <lu_zero@gentoo.org>
Subject: Re: [PATCH v5] media: video-i2c: add video-i2c driver
Date: Fri, 13 Jan 2017 12:22 +0200
Message-ID: <5567693.ylOOACtACV@avalon>
In-Reply-To: <CAJ_EiSQEQYiCcivdUysB_=xR2HFbK6NhoziMeGKUKGq-GiF0Fg@mail.gmail.com>
References: <1482548666-25272-1-git-send-email-matt@ranostay.consulting> <2f86a894-817f-6834-fad6-8ed2294ba2e4@denx.de> <CAJ_EiSQEQYiCcivdUysB_=xR2HFbK6NhoziMeGKUKGq-GiF0Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Thursday 12 Jan 2017 20:45:21 Matt Ranostay wrote:
> On Sun, Jan 8, 2017 at 9:33 PM, Marek Vasut <marex@denx.de> wrote:
> > On 01/09/2017 06:17 AM, Matt Ranostay wrote:
> >> Gentle ping on this! :)
> > 
> > Just some high-level feedback ... You should use regmap instead. Also,
> > calling a driver which is specific to a particular sensor (amg88x) by
> > generic name (video_i2c) is probably not a good idea.
> 
> There are likely going to variants, and other vendors that will have
> parts as well. One example to note is the FLIR Lepton, and that may be
> a good reason to use regmap in the future.   Also Laurent suggested
> the generic naming :)

I actually suggested video-i2c instead of i2c-polling to make the name *less* 
generic :-)

> >>> On Dec 23, 2016, at 19:04, Matt Ranostay <matt@ranostay.consulting>
> >>> wrote:
> >>> 
> >>> There are several thermal sensors that only have a low-speed bus
> >>> interface but output valid video data. This patchset enables support
> >>> for the AMG88xx "Grid-Eye" sensor family.
> >>> 
> >>> Cc: Attila Kinali <attila@kinali.ch>
> >>> Cc: Marek Vasut <marex@denx.de>
> >>> Cc: Luca Barbato <lu_zero@gentoo.org>
> >>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> >>> ---
> >>> Changes from v1:
> >>> * correct i2c_polling_remove() operations
> >>> * fixed delay calcuation in buffer_queue()
> >>> * add include linux/slab.h
> >>> 
> >>> Changes from v2:
> >>> * fix build error due to typo in include of slab.h
> >>> 
> >>> Changes from v3:
> >>> * switch data transport to a kthread to avoid to .buf_queue that can't
> >>> sleep * change naming from i2c-polling to video-i2c
> >>> * make the driver for single chipset under another uses the driver
> >>> 
> >>> Changes from v4:
> >>> * fix wraparound issue with jiffies and schedule_timeout_interruptible()
> >>> 
> >>> drivers/media/i2c/Kconfig     |   9 +
> >>> drivers/media/i2c/Makefile    |   1 +
> >>> drivers/media/i2c/video-i2c.c | 569 ++++++++++++++++++++++++++++++++++++
> >>> 3 files changed, 579 insertions(+)
> >>> create mode 100644 drivers/media/i2c/video-i2c.c

-- 
Regards,

Laurent Pinchart

