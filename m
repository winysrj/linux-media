Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1819 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCIrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 04:47:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 3/3] bttv: Convert to generic TEA575x interface
Date: Mon, 3 Jun 2013 10:46:42 +0200
Cc: linux-media@vger.kernel.org
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org> <1368564885-20940-4-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1368564885-20940-4-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306031046.42057.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue May 14 2013 22:54:45 Ondrej Zary wrote:
> Remove tea575x-specific code from bttv and use the common driver instead.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/media/pci/bt8xx/bttv-cards.c  |  317 ++++++++++++---------------------
>  drivers/media/pci/bt8xx/bttv-driver.c |    6 +-
>  drivers/media/pci/bt8xx/bttvp.h       |   14 +-
>  sound/pci/Kconfig                     |    4 +-
>  4 files changed, 124 insertions(+), 217 deletions(-)
> 

...

> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> index fe6fa93..83e0df5 100644
> --- a/sound/pci/Kconfig
> +++ b/sound/pci/Kconfig
> @@ -2,8 +2,8 @@
>  
>  config SND_TEA575X
>  	tristate
> -	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
> -	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
> +	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
> +	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
>  
>  menuconfig SND_PCI
>  	bool "PCI sound devices"
> 

In addition, bttv should also become dependent on SND.

Frankly, isn't it time that tea575x-tuner moves to drivers/media/common or
driver/media/radio? It's really weird to have such a fairly widely used v4l
module in sound.

Regards,

	Hans
