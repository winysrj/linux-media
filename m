Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59926
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752769AbdHTLyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:54:05 -0400
Date: Sun, 20 Aug 2017 08:53:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>, rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH] [media] ddbridge: add IOCTLs
Message-ID: <20170820085356.0aa87e66@vento.lan>
In-Reply-To: <20170820110855.7127-1-d.scheller.oss@gmail.com>
References: <20170820110855.7127-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Aug 2017 13:08:55 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> This patch adds back the IOCTL API/functionality which is present in the
> upstream dddvb driver package. In comparison, the IOCTL handler has been
> factored to a separate object (and with that, some functionality from
> -core has been moved there aswell), the IOCTLs are defined in an include
> in the uAPI, and ioctl-number.txt is updated to document that there are
> IOCTLs present in this driver.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
> This patch depends on the ddbridge-0.9.29 bump, see [1]. The
> functionality was part of the driver before.
> 
> [1] http://www.spinics.net/lists/linux-media/msg119911.html
> 
>  Documentation/ioctl/ioctl-number.txt        |   1 +
>  MAINTAINERS                                 |   1 +
>  drivers/media/pci/ddbridge/Makefile         |   2 +-
>  drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +--------
>  drivers/media/pci/ddbridge/ddbridge-ioctl.c | 334 ++++++++++++++++++++++++++++
>  drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++
>  include/uapi/linux/ddbridge-ioctl.h         | 110 +++++++++
>  7 files changed, 481 insertions(+), 110 deletions(-)
>  create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.c
>  create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.h
>  create mode 100644 include/uapi/linux/ddbridge-ioctl.h
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 3e3fdae5f3ed..d78d1cd092d2 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -215,6 +215,7 @@ Code  Seq#(hex)	Include File		Comments
>  'c'	A0-AF   arch/x86/include/asm/msr.h	conflict!
>  'd'	00-FF	linux/char/drm/drm.h	conflict!
>  'd'	02-40	pcmcia/ds.h		conflict!
> +'d'	00-0B	linux/ddbridge-ioctl.h	conflict!

That's where the problem with this patch starts: we don't add conflicts
here :-)

We need more discussions with regards to the features added by this
patchset.

Anyway, I applied today the ddbridge patches we had. I solved a few
conflicts while merging some things, so I'd appreciate if you could
check if everything is ok. If not, please send patches :-)

Regards,
Mauro
