Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51404
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752819AbdHIOid (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 10:38:33 -0400
Date: Wed, 9 Aug 2017 11:38:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.14] Fixes, fixes, ever more fixes :-)
Message-ID: <20170809113826.4f41102c@vento.lan>
In-Reply-To: <9307321b-6fff-2102-b1af-4f73b7199e2b@xs4all.nl>
References: <9307321b-6fff-2102-b1af-4f73b7199e2b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 4 Aug 2017 13:40:18 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Lots of constify patches and some random other fixes. Except for the solo patch
> which is an actual feature enhancement.
> 
> Regards,
> 
> 	Hans
> 
> 
> The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:
> 
>   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.14e
> 
> for you to fetch changes up to 09408627c4d001f4df6ede6d22eb27c2945c455c:
> 
>   v4l2-compat-ioctl32: Fix timespec conversion (2017-08-04 13:27:18 +0200)
> 
> ----------------------------------------------------------------
> Anton Sviridenko (1):
>       solo6x10: export hardware GPIO pins 8:31 to gpiolib interface
> 
> Arvind Yadav (27):
>       marvell-ccic: constify pci_device_id.
>       netup_unidvb: constify pci_device_id.
>       cx23885: constify pci_device_id.
>       meye: constify pci_device_id.
>       pluto2: constify pci_device_id.
>       dm1105: constify pci_device_id.
>       zoran: constify pci_device_id.
>       bt8xx: constify pci_device_id.
>       bt8xx: bttv: constify pci_device_id.
>       ivtv: constify pci_device_id.
>       cobalt: constify pci_device_id.
>       b2c2: constify pci_device_id.
>       saa7164: constify pci_device_id.
>       pt1: constify pci_device_id.
>       mantis: constify pci_device_id.
>       mantis: hopper_cards: constify pci_device_id.
>       cx18: constify pci_device_id.
>       radio: constify pci_device_id.
>       drv-intf: saa7146: constify pci_device_id.
>       ttpci: budget: constify pci_device_id.
>       ttpci: budget-patch: constify pci_device_id.
>       ttpci: budget-ci: constify pci_device_id.
>       ttpci: budget-av: constify pci_device_id.
>       ttpci: av7110: constify pci_device_id.
>       saa7146: mxb: constify pci_device_id.
>       saa7146: hexium_orion: constify pci_device_id.
>       saa7146: hexium_gemini: constify pci_device_id.
> 
> Dan Carpenter (1):
>       adv7604: Prevent out of bounds access
> 
> Daniel Mentz (2):
>       v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
>       v4l2-compat-ioctl32: Fix timespec conversion
> 
> Julia Lawall (1):
>       DaVinci-VPBE: constify vpbe_dev_ops
> 
> Peter Rosin (3):
>       cx231xx: fail probe if i2c_add_adapter fails
>       cx231xx: drop return value of cx231xx_i2c_unregister


>       cx231xx: only unregister successfully registered i2c adapters

IMHO, this fix is wrong: it will prevent the driver to unregister RC
if the I2C bus is not zero.

The remaining patches are OK, and were applied.

Regards,
Mauro

Thanks,
Mauro
