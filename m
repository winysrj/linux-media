Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36387 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbcDDX04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2016 19:26:56 -0400
Subject: Re: [PATCH v3] [media] tpg: Export the tpg code from vivid as a
 module
To: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com
References: <1459575308-13761-1-git-send-email-helen.koike@collabora.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5702F835.3060708@xs4all.nl>
Date: Mon, 4 Apr 2016 16:26:45 -0700
MIME-Version: 1.0
In-Reply-To: <1459575308-13761-1-git-send-email-helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On 04/01/2016 10:35 PM, Helen Mae Koike Fornazier wrote:
> The test pattern generator will be used by other drivers as the virtual
> media controller (vimc)
>
> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
> ---
>
> The patch is based on 'media/master' branch and available at
>          https://github.com/helen-fornazier/opw-staging tpg/review/vivid
>
> Changes since last version:
> 	* mv drivers/media/platform/tpg drivers/media/common/v4l2-tpg
> 	* files renamed with v4l2 prefix
> 	* tpg removed from menuconfig, depends on VIDEO_VIVID and selected automaticaly by VIDEO_VIVID
> 	* module's description
>
> NOTE: I left the "select VIDEO_V4L2_TPG" in the vivid Kconfig because without it the tpg module is
> not selected automaticaly when selecting VIDEO_VIVID, it seems that using the "depends on VIDEO_VIVID" in
> the tpg's Kconfig is not enough (I thought it should be, but apparently I missundestood the docs). Please,
> let me know if this is not correct.
>
>   drivers/media/common/Kconfig                       |  1 +
>   drivers/media/common/Makefile                      |  2 +-
>   drivers/media/common/v4l2-tpg/Kconfig              |  3 +++
>   drivers/media/common/v4l2-tpg/Makefile             |  3 +++
>   .../v4l2-tpg/v4l2-tpg-colors.c}                    |  7 +++----
>   .../v4l2-tpg/v4l2-tpg-core.c}                      | 24 ++++++++++++++++++++--
>   drivers/media/platform/vivid/Kconfig               |  1 +
>   drivers/media/platform/vivid/Makefile              |  2 +-
>   drivers/media/platform/vivid/vivid-core.h          |  2 +-
>   .../media/v4l2-tpg-colors.h                        |  6 +++---
>   .../vivid/vivid-tpg.h => include/media/v4l2-tpg.h  |  9 ++++----
>   11 files changed, 43 insertions(+), 17 deletions(-)
>   create mode 100644 drivers/media/common/v4l2-tpg/Kconfig
>   create mode 100644 drivers/media/common/v4l2-tpg/Makefile
>   rename drivers/media/{platform/vivid/vivid-tpg-colors.c => common/v4l2-tpg/v4l2-tpg-colors.c} (99%)
>   rename drivers/media/{platform/vivid/vivid-tpg.c => common/v4l2-tpg/v4l2-tpg-core.c} (98%)
>   rename drivers/media/platform/vivid/vivid-tpg-colors.h => include/media/v4l2-tpg-colors.h (93%)
>   rename drivers/media/platform/vivid/vivid-tpg.h => include/media/v4l2-tpg.h (99%)
>
> diff --git a/drivers/media/common/Kconfig b/drivers/media/common/Kconfig
> index 21154dd..326df0a 100644
> --- a/drivers/media/common/Kconfig
> +++ b/drivers/media/common/Kconfig
> @@ -19,3 +19,4 @@ config CYPRESS_FIRMWARE
>   source "drivers/media/common/b2c2/Kconfig"
>   source "drivers/media/common/saa7146/Kconfig"
>   source "drivers/media/common/siano/Kconfig"
> +source "drivers/media/common/v4l2-tpg/Kconfig"
> diff --git a/drivers/media/common/Makefile b/drivers/media/common/Makefile
> index 89b795d..2d1b0a0 100644
> --- a/drivers/media/common/Makefile
> +++ b/drivers/media/common/Makefile
> @@ -1,4 +1,4 @@
> -obj-y += b2c2/ saa7146/ siano/
> +obj-y += b2c2/ saa7146/ siano/ v4l2-tpg/
>   obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>   obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>   obj-$(CONFIG_CYPRESS_FIRMWARE) += cypress_firmware.o
> diff --git a/drivers/media/common/v4l2-tpg/Kconfig b/drivers/media/common/v4l2-tpg/Kconfig
> new file mode 100644
> index 0000000..3c36f52
> --- /dev/null
> +++ b/drivers/media/common/v4l2-tpg/Kconfig
> @@ -0,0 +1,3 @@
> +config VIDEO_V4L2_TPG
> +	tristate
> +	depends on VIDEO_VIVID

This is weird. I would not expect a 'depends on' here, instead the vivid driver should select it.
It's similar to how e.g. VIDEOBUF2_CORE works.

Regards,

	Hans
