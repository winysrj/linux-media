Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61087 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753523AbdLHO7n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 09:59:43 -0500
Date: Fri, 8 Dec 2017 12:59:37 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        yong.zhi@intel.com
Subject: Re: [RESEND GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver
 driver
Message-ID: <20171208125937.07bb3302@vento.lan>
In-Reply-To: <20171201143135.c6r2e2iaoxcvyxpi@valkosipuli.retiisi.org.uk>
References: <20171201143135.c6r2e2iaoxcvyxpi@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 1 Dec 2017 16:31:36 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's the Intel IPU3 CIO2 CSI-2 receiver driver, with the accompanying
> format definitions.

This patch generates two warnings:

drivers/media/pci/intel/ipu3/ipu3-cio2.c:1899:16: warning: Variable length array is used.
drivers/media/pci/intel/ipu3/ipu3-cio2.c: In function 'cio2_pci_probe':
drivers/media/pci/intel/ipu3/ipu3-cio2.c:1726:14: warning: variable 'phys' set but not used [-Wunused-but-set-variable]
  phys_addr_t phys;
              ^~~~

We should never use variable-length array on Kernel, as Linux stack
is very limited, and we have static analyzers to check for it at
compilation time.

Also, the logic should check if pci_resource_start() succeeded, instead
of just ignoring it.

Please fix.


> 
> Please pull.
> 
> 
> The following changes since commit be9b53c83792e3898755dce90f8c632d40e7c83e:
> 
>   media: dvb-frontends: complete kernel-doc markups (2017-11-30 04:19:05 -0500)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git ipu3
> 
> for you to fetch changes up to f178207daa68e817ab6fd702d81ed7c8637ab72c:
> 
>   intel-ipu3: cio2: add new MIPI-CSI2 driver (2017-11-30 14:19:47 +0200)
> 
> ----------------------------------------------------------------
> Yong Zhi (3):
>       videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
>       doc-rst: add IPU3 raw10 bayer pixel format definitions
>       intel-ipu3: cio2: add new MIPI-CSI2 driver
> 
>  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
>  .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |  335 ++++
>  MAINTAINERS                                        |    8 +
>  drivers/media/pci/Kconfig                          |    2 +
>  drivers/media/pci/Makefile                         |    3 +-
>  drivers/media/pci/intel/Makefile                   |    5 +
>  drivers/media/pci/intel/ipu3/Kconfig               |   19 +
>  drivers/media/pci/intel/ipu3/Makefile              |    1 +
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2052 ++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  449 +++++
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
>  include/uapi/linux/videodev2.h                     |    6 +
>  12 files changed, 2884 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
>  create mode 100644 drivers/media/pci/intel/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
>  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
> 



Thanks,
Mauro
