Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:27410 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2GQMMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:12:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [GIT PULL] Davinci VPIF feature enhancement and fixes for v3.5
Date: Tue, 17 Jul 2012 14:11:39 +0200
Cc: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'LMML'" <linux-media@vger.kernel.org>,
	"'dlos'" <davinci-linux-open-source@linux.davincidsp.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>
References: <4665BC9CC4253445B213A010E6DC7B35CE0035@DBDE01.ent.ti.com>
In-Reply-To: <4665BC9CC4253445B213A010E6DC7B35CE0035@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207171411.39166.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 10 July 2012 14:53:52 Lad, Prabhakar wrote:
> Hi Mauro,
> 
> Please pull the following VPIF driver feature enhancement and fixes for v3.5
> 
> Thanks and Regards,
> --Prabhakar Lad

Just for the record:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:
> 
>   Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)
> 
> are available in the git repository at:
>   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_vpif
> 
> Lad, Prabhakar (2):
>       davinci: vpif capture: migrate driver to videobuf2
>       davinci: vpif display: migrate driver to videobuf2
> 
> Manjunath Hadli (12):
>       davinci: vpif: add check for genuine interrupts in the isr
>       davinci: vpif: make generic changes to re-use the vpif drivers on da850/omap-l138 soc
>       davinci: vpif: make request_irq flags as shared
>       davinci: vpif: fix setting of data width in config_vpif_params() function
>       davinci: vpif display: size up the memory for the buffers from the buffer pool
>       davinci: vpif capture: size up the memory for the buffers from the buffer pool
>       davinci: vpif: add support for clipping on output data
>       davinci: vpif display: Add power management support
>       davinci: vpif capture:Add power management support
>       davinci: vpif: Add suspend/resume callbacks to vpif driver
>       davinci: vpif: add build configuration for vpif drivers
>       davinci: vpif: Enable selection of the ADV7343 and THS7303
> 
>  drivers/media/video/davinci/Kconfig        |   30 +-
>  drivers/media/video/davinci/Makefile       |    8 +-
>  drivers/media/video/davinci/vpif.c         |   45 ++-
>  drivers/media/video/davinci/vpif.h         |   45 ++
>  drivers/media/video/davinci/vpif_capture.c |  690 +++++++++++++++-------------
>  drivers/media/video/davinci/vpif_capture.h |   16 +-
>  drivers/media/video/davinci/vpif_display.c |  684 +++++++++++++++------------
>  drivers/media/video/davinci/vpif_display.h |   23 +-
>  include/media/davinci/vpif_types.h         |    2 +
>  9 files changed, 881 insertions(+), 662 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
