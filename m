Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56527 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbbAMNEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 08:04:52 -0500
Message-ID: <54B517C3.3070205@xs4all.nl>
Date: Tue, 13 Jan 2015 14:04:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/16] [media] adv7180: Add support for different chip
References: <1421150481-30230-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On 01/13/15 13:01, Lars-Peter Clausen wrote:
> The adv7180 is part of a larger family of chips which all implement
> different features from a feature superset. This patch series step by step
> extends the current adv7180 with features from the superset that are
> currently not supported and gradually adding support for more variations of
> the chip.
> 
> The first half of this series contains fixes and cleanups while the second
> half adds new features and support for new chips.

For patches 1-7, 9-13 and 16:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I need a bit more time to review patches 8 and 15. Ping me if you haven't
heard from me by Friday.

BTW: is the adv7183 part of the same family? There is a separate i2c driver
for it in the kernel, so I was wondering if that could be merged into this
driver eventually.

Did you check with authors of drivers that use the adv7180 to ensure nothing
broke? They should be pinged about this at least.

Regards,

	Hans

> 
> - Lars
> 
> Lars-Peter Clausen (16):
>   [media] adv7180: Do not request the IRQ again during resume
>   [media] adv7180: Pass correct flags to request_threaded_irq()
>   [media] adv7180: Use inline function instead of macro
>   [media] adv7180: Cleanup register define naming
>   [media] adv7180: Do implicit register paging
>   [media] adv7180: Reset the device before initialization
>   [media] adv7180: Add media controller support
>   [media] adv7180: Consolidate video mode setting
>   [media] adv7180: Prepare for multi-chip support
>   [media] adv7180: Add support for the ad7182
>   [media] adv7180: Add support for the adv7280/adv7281/adv7282
>   [media] adv7180: Add support for the
>     adv7280-m/adv7281-m/adv7281-ma/adv7282-m
>   [media] adv7180: Add I2P support
>   [media] adv7180: Add fast switch support
>   [media] adv7180: Add free run mode controls
>   [media] Add MAINTAINERS entry for the adv7180
> 
>  MAINTAINERS                       |    7 +
>  drivers/media/i2c/Kconfig         |    2 +-
>  drivers/media/i2c/adv7180.c       | 1137 ++++++++++++++++++++++++++++++-------
>  drivers/media/pci/sta2x11/Kconfig |    1 +
>  drivers/media/platform/Kconfig    |    2 +-
>  5 files changed, 947 insertions(+), 202 deletions(-)
> 

