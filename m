Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4445 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3I3MWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:22:34 -0400
Message-ID: <52496CFE.2090700@xs4all.nl>
Date: Mon, 30 Sep 2013 14:22:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/10] [media] remove unnecessary pci_set_drvdata()
References: <003601ceb7fe$462af680$d280e380$%han@samsung.com>
In-Reply-To: <003601ceb7fe$462af680$d280e380$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/2013 03:43 AM, Jingoo Han wrote:
> Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound),
> the driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.

For the whole patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> ---
>  drivers/media/common/saa7146/saa7146_core.c |    2 --
>  drivers/media/pci/b2c2/flexcop-pci.c        |    2 --
>  drivers/media/pci/bt8xx/bt878.c             |    1 -
>  drivers/media/pci/cx88/cx88-alsa.c          |    2 --
>  drivers/media/pci/cx88/cx88-mpeg.c          |    1 -
>  drivers/media/pci/cx88/cx88-video.c         |    1 -
>  drivers/media/pci/dm1105/dm1105.c           |    2 --
>  drivers/media/pci/mantis/mantis_pci.c       |    2 --
>  drivers/media/pci/ngene/ngene-core.c        |    2 --
>  drivers/media/pci/pluto2/pluto2.c           |    2 --
>  drivers/media/pci/pt1/pt1.c                 |    2 --
>  drivers/media/pci/saa7164/saa7164-core.c    |    1 -
>  12 files changed, 20 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

