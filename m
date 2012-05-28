Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2607 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2E1MwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:52:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCHv2 1/3] [media] media: reorganize the main Kconfig items
Date: Mon, 28 May 2012 14:51:50 +0200
Cc: stefanr@s5r6.in-berlin.de
References: <1338207469-32606-1-git-send-email-mchehab@redhat.com> <1338207469-32606-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338207469-32606-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281451.50127.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 14:17:47 Mauro Carvalho Chehab wrote:
> Change the main items to:
> 
> <m> Multimedia support  --->
>    [ ]   Cameras/video grabbers support
>    [ ]   Analog TV support
>    [ ]   Digital TV support
>    [ ]   AM/FM radio receivers/transmitters support
>    [ ]   Remote Controller support
> 
> This provides an interface that is clearer to end users that
> are compiling the Kernel, and will allow the building system
> to automatically unselect drivers for unused functions.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/Kconfig               |  109 +++++++++++++++++++++++-----------
>  drivers/media/common/tuners/Kconfig |    1 +
>  drivers/media/dvb/frontends/Kconfig |    1 +
>  drivers/media/rc/Kconfig            |   29 ++++-----
>  4 files changed, 89 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 9575db4..323b2f0 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -6,20 +6,82 @@ menuconfig MEDIA_SUPPORT
>  	tristate "Multimedia support"
>  	depends on HAS_IOMEM
>  	help
> -	  If you want to use Video for Linux, DVB for Linux, or DAB adapters,
> +	  If you want to use Webcams, Video grabber devices and/or TV devices
>  	  enable this option and other options below.
> +	  Additional info and docs are available on the web at
> +	  <http://linuxtv.org>
>  
>  if MEDIA_SUPPORT
>  
>  comment "Multimedia core support"
>  
>  #
> +# Multimedia support - automatically enable V4L2 and DVB core
> +#
> +config MEDIA_CAMERA_SUPPORT
> +	bool "Cameras/video grabbers support"
> +	---help---
> +	  Enable support for webcams and video grabbers.

And memory-to-memory devices, and video output devices.

Perhaps this should be called MEDIA_VIDEO_SUPPORT? It really refers
to any video device that does not have a tuner, right? I find it
really strange to have a e.g. HDMI video grabber depend on MEDIA_CAMERA_SUPPORT.

> +
> +	  Say Y when you have a webcam or a video capture grabber board.
> +
> +config MEDIA_ANALOG_TV_SUPPORT
> +	bool "Analog TV support"
> +	---help---
> +	  Enable analog TV support.

I still prefer to see the term 'tuner' be used explicitly:

MEDIA_ANALOG_TUNER_SUPPORT and 'Analog TV tuner support'

> +
> +	  Say Y when you have a TV board with analog support or with a
> +	  hybrid analog/digital TV chipset.
> +
> +	  Note: There are several DVB cards that are based on chips that
> +		support both analog and digital TV. Disabling this option
> +		will disable support for them.
> +
> +config MEDIA_DIGITAL_TV_SUPPORT
> +	bool "Digital TV support"
> +	---help---
> +	  Enable digital TV support.

Ditto.

> +
> +	  Say Y when you have a board with digital support or a board with
> +	  hybrid digital TV and analog TV.
> +
> +config MEDIA_RADIO_SUPPORT
> +	bool "AM/FM radio receivers/transmitters support"
> +	---help---
> +	  Enable AM/FM radio support.

Just drop the 'AM/FM' part. We may get other devices that support other
bands as well (I know they exist, and one is actually on its way to me).

> +
> +	  Additional info and docs are available on the web at
> +	  <http://linuxtv.org>
> +
> +	  Say Y when you have a board with radio support.
> +
> +	  Note: There are several TV cards that are based on chips that
> +		support radio reception. Disabling this option will
> +		disable support for them.

The remainder of this patch looks good to me.

Regards,

	Hans

> +
> +menuconfig MEDIA_RC_SUPPORT
> +	bool "Remote Controller support"
> +	depends on INPUT
> +	---help---
> +	  Enable support for Remote Controllers on Linux. This is
> +	  needed in order to support several video capture adapters,
> +	  standalone IR receivers/transmitters, and RF receivers.
> +
> +	  Enable this option if you have a video capture board even
> +	  if you don't need IR, as otherwise, you may not be able to
> +	  compile the driver for your adapter.
> +
> +	  Say Y when you have a TV or an IR device.
> +
> +#
>  # Media controller
> +#	Selectable only for webcam/grabbers, as other drivers don't use it
>  #
>  
>  config MEDIA_CONTROLLER
>  	bool "Media Controller API (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
> +	depends on MEDIA_CAMERA_SUPPORT
>  	---help---
>  	  Enable the media controller API used to query media devices internal
>  	  topology and configure it dynamically.
> @@ -27,26 +89,15 @@ config MEDIA_CONTROLLER
>  	  This API is mostly used by camera interfaces in embedded platforms.
>  
>  #
> -# V4L core and enabled API's
> +# Video4Linux support
> +#	Only enables if one of the V4L2 types (ATV, webcam, radio) is selected
>  #
>  
>  config VIDEO_DEV
> -	tristate "Video For Linux"
> -	---help---
> -	  V4L core support for video capture and overlay devices, webcams and
> -	  AM/FM radio cards.
> -
> -	  This kernel includes support for the new Video for Linux Two API,
> -	  (V4L2).
> -
> -	  Additional info and docs are available on the web at
> -	  <http://linuxtv.org>
> -
> -	  Documentation for V4L2 is also available on the web at
> -	  <http://bytesex.org/v4l/>.
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called videodev.
> +	tristate
> +	depends on MEDIA_SUPPORT
> +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT
> +	default y
>  
>  config VIDEO_V4L2_COMMON
>  	tristate
> @@ -64,25 +115,15 @@ config VIDEO_V4L2_SUBDEV_API
>  
>  #
>  # DVB Core
> +#	Only enables if one of DTV is selected
>  #
>  
>  config DVB_CORE
> -	tristate "DVB for Linux"
> +	tristate
> +	depends on MEDIA_SUPPORT
> +	depends on MEDIA_DIGITAL_TV_SUPPORT
> +	default y
>  	select CRC32
> -	help
> -	  DVB core utility functions for device handling, software fallbacks etc.
> -
> -	  Enable this if you own a DVB/ATSC adapter and want to use it or if
> -	  you compile Linux for a digital SetTopBox.
> -
> -	  Say Y when you have a DVB or an ATSC card and want to use it.
> -
> -	  API specs and user tools are available from <http://www.linuxtv.org/>.
> -
> -	  Please report problems regarding this support to the LinuxDVB
> -	  mailing list.
> -
> -	  If unsure say N.
>  
>  config DVB_NET
>  	bool "DVB Network Support"
> @@ -101,8 +142,6 @@ config VIDEO_MEDIA
>  	tristate
>  	default (DVB_CORE && (VIDEO_DEV = n)) || (VIDEO_DEV && (DVB_CORE = n)) || (DVB_CORE && VIDEO_DEV)
>  
> -comment "Multimedia drivers"
> -
>  source "drivers/media/common/Kconfig"
>  source "drivers/media/rc/Kconfig"
>  
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index bbf4945..16ee1a4 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -2,6 +2,7 @@ config MEDIA_ATTACH
>  	bool "Load and attach frontend and tuner driver modules as needed"
>  	depends on VIDEO_MEDIA
>  	depends on MODULES
> +	default y if !EXPERT
>  	help
>  	  Remove the static dependency of DVB card drivers on all
>  	  frontend modules for all possible card variants. Instead,
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index b98ebb2..6d3c2f7 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -1,6 +1,7 @@
>  config DVB_FE_CUSTOMISE
>  	bool "Customise the frontend modules to build"
>  	depends on DVB_CORE
> +	depends on EXPERT
>  	default y if EXPERT
>  	help
>  	  This allows the user to select/deselect frontend drivers for their
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index f97eeb8..d2655f1 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -1,21 +1,12 @@
> -menuconfig RC_CORE
> -	tristate "Remote Controller adapters"
> +config RC_CORE
> +	tristate
> +	depends on MEDIA_RC_SUPPORT
>  	depends on INPUT
> -	default INPUT
> -	---help---
> -	  Enable support for Remote Controllers on Linux. This is
> -	  needed in order to support several video capture adapters,
> -	  standalone IR receivers/transmitters, and RF receivers.
> -
> -	  Enable this option if you have a video capture board even
> -	  if you don't need IR, as otherwise, you may not be able to
> -	  compile the driver for your adapter.
> -
> -if RC_CORE
> +	default y
>  
>  config LIRC
> -	tristate
> -	default y
> +	tristate "LIRC interface driver"
> +	depends on RC_CORE
>  
>  	---help---
>  	   Enable this option to build the Linux Infrared Remote
> @@ -109,6 +100,12 @@ config IR_MCE_KBD_DECODER
>  	   Windows Media Center Edition, which you would like to use with
>  	   a raw IR receiver in your system.
>  
> +menuconfig RC_DEVICES
> +	bool "Remote Controller devices"
> +	depends on RC_CORE
> +
> +if RC_DEVICES
> +
>  config IR_LIRC_CODEC
>  	tristate "Enable IR to LIRC bridge"
>  	depends on RC_CORE
> @@ -276,4 +273,4 @@ config IR_GPIO_CIR
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called gpio-ir-recv.
>  
> -endif #RC_CORE
> +endif #RC_DEVICES
> 
