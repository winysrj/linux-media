Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3391 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3JCHA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 03:00:26 -0400
Message-ID: <524D15F7.5070102@xs4all.nl>
Date: Thu, 03 Oct 2013 09:00:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 0/6] OMAP4 ISS driver
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/03/2013 01:55 AM, Laurent Pinchart wrote:
> Hello,
> 
> The OMAP4 ISS driver has lived out of tree for more than two years now. This
> situation is both sad and resource-wasting, as the driver has been used (and
> thus) hacked since then with nowhere to send patches to. Time has come to fix
> the problem.
> 
> As the code is mostly, but not quite ready for prime time, I'd like to request
> its addition to drivers/staging/. I've added a (pretty small) TODO file and I
> commit to cleaning up the code and get it to drivers/media/ where it belongs.
> 
> I've split the driver in six patches to avoid getting caught in vger's size
> and to make review slightly easier. Sergio Aguirre is the driver author (huge
> thanks for that!), I've thus kept his authorship on patches 1/6 to 5/6.
> 
> I don't have much else to add here, let's get this beast to mainline and allow
> other developers to use the driver and contribute patches.

Thanks for the patch series! Much appreciated.

For this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I've posted a few comments for the first two patches (nothing jumped out to me for
the other patches) that you may want to address in a follow-up patch, particularly
the missing timestamp_type for vb2_queue will give a lot of WARN_ON messages in the
kernel log.

Regards,

	Hans

> 
> Laurent Pinchart (1):
>   v4l: omap4iss: Add support for OMAP4 camera interface - Build system
> 
> Sergio Aguirre (5):
>   v4l: omap4iss: Add support for OMAP4 camera interface - Core
>   v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
>   v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
>   v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
>   v4l: omap4iss: Add support for OMAP4 camera interface - Resizer
> 
>  Documentation/video4linux/omap4_camera.txt   |   63 ++
>  drivers/staging/media/Kconfig                |    2 +
>  drivers/staging/media/Makefile               |    1 +
>  drivers/staging/media/omap4iss/Kconfig       |   12 +
>  drivers/staging/media/omap4iss/Makefile      |    6 +
>  drivers/staging/media/omap4iss/TODO          |    4 +
>  drivers/staging/media/omap4iss/iss.c         | 1477 ++++++++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss.h         |  153 +++
>  drivers/staging/media/omap4iss/iss_csi2.c    | 1368 ++++++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss_csi2.h    |  156 +++
>  drivers/staging/media/omap4iss/iss_csiphy.c  |  278 +++++
>  drivers/staging/media/omap4iss/iss_csiphy.h  |   51 +
>  drivers/staging/media/omap4iss/iss_ipipe.c   |  581 ++++++++++
>  drivers/staging/media/omap4iss/iss_ipipe.h   |   67 ++
>  drivers/staging/media/omap4iss/iss_ipipeif.c |  847 +++++++++++++++
>  drivers/staging/media/omap4iss/iss_ipipeif.h |   92 ++
>  drivers/staging/media/omap4iss/iss_regs.h    |  883 +++++++++++++++
>  drivers/staging/media/omap4iss/iss_resizer.c |  905 ++++++++++++++++
>  drivers/staging/media/omap4iss/iss_resizer.h |   75 ++
>  drivers/staging/media/omap4iss/iss_video.c   | 1129 ++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss_video.h   |  201 ++++
>  include/media/omap4iss.h                     |   65 ++
>  22 files changed, 8416 insertions(+)
>  create mode 100644 Documentation/video4linux/omap4_camera.txt
>  create mode 100644 drivers/staging/media/omap4iss/Kconfig
>  create mode 100644 drivers/staging/media/omap4iss/Makefile
>  create mode 100644 drivers/staging/media/omap4iss/TODO
>  create mode 100644 drivers/staging/media/omap4iss/iss.c
>  create mode 100644 drivers/staging/media/omap4iss/iss.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_csi2.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_csi2.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_resizer.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_resizer.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_video.c
>  create mode 100644 drivers/staging/media/omap4iss/iss_video.h
>  create mode 100644 include/media/omap4iss.h
> 

