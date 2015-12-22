Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59915 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbbLVMks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 07:40:48 -0500
Subject: Re: next-20151222 - compile failure in
 drivers/media/usb/uvc/uvc_driver.c
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <75073.1450779516@turing-police.cc.vt.edu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <567944CB.4070505@osg.samsung.com>
Date: Tue, 22 Dec 2015 09:40:43 -0300
MIME-Version: 1.0
In-Reply-To: <75073.1450779516@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Valdis,

On 12/22/2015 07:18 AM, Valdis Kletnieks wrote:
> next-20151222 fails to build for me:
> 
>   CC      drivers/media/usb/uvc/uvc_driver.o
> drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
> drivers/media/usb/uvc/uvc_driver.c:1941:32: error: 'struct uvc_device' has no member named 'mdev'
>   if (media_device_register(&dev->mdev) < 0)
>                                 ^
> scripts/Makefile.build:258: recipe for target 'drivers/media/usb/uvc/uvc_driver.o' failed
> 
> 'git blame' points at that line being added in:
> 
> commit 1590ad7b52714fddc958189103c95541b49b1dae
> Author: Javier Martinez Canillas <javier@osg.samsung.com>
> Date:   Fri Dec 11 20:57:08 2015 -0200
> 
>     [media] media-device: split media initialization and registration
> 
> Not sure what went wrong here.
>

It was my forgetting to test with !CONFIG_MEDIA_CONTROLLER...

Anyways, I've already posted a fix for this:

https://lkml.org/lkml/2015/12/21/224

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
