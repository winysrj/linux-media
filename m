Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51401 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3FQU1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 16:27:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PULL FOR 3.11] Media entity link handling fixes
Date: Mon, 17 Jun 2013 22:27:47 +0200
Message-ID: <13581628.t9xlNhDWCX@avalon>
In-Reply-To: <51BEFD22.30708@samsung.com>
References: <51BEFD22.30708@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

A bit late, but for the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

As discussed privately earlier today, sorry for not having handled the patches 
myself. I will gather media controller related patches in the future.

On Monday 17 June 2013 14:12:18 Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> This includes corrections of the media entity links handling and resolves
> potential issues when media entity drivers are in different kernel modules.
> It allows to keep all entities that belong to same media graph in correct
> state, when one of an entity's driver module gets unloaded.
> 
> The following changes since commit dd8c393b3c39f7ebd9ad69ce50cc836773d512b6:
> 
>   [media] media: i2c: ths7303: make the pdata as a constant pointer
> (2013-06-13 11:42:17 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/snawrocki/samsung.git for-v3.11-2
> 
> for you to fetch changes up to 28521e45c4478b7bc083e445573aacb7d174dd35:
> 
>   V4L: Remove all links of the media entity when unregistering subdev
> (2013-06-17 13:42:22 +0200)
> 
> ----------------------------------------------------------------
> Sakari Ailus (2):
>       davinci_vpfe: Clean up media entity after unregistering subdev
>       smiapp: Clean up media entity after unregistering subdev
> 
> Sylwester Nawrocki (2):
>       media: Add a function removing all links of a media entity
>       V4L: Remove all links of the media entity when unregistering subdev
> 
>  drivers/media/i2c/smiapp/smiapp-core.c             |    2 +-
>  drivers/media/media-entity.c                       |   50 +++++++++++++++++
>  drivers/media/v4l2-core/v4l2-device.c              |    4 +-
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    4 +-
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    4 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 +-
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |   14 +++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
>  include/media/media-entity.h                       |    3 ++
>  9 files changed, 71 insertions(+), 16 deletions(-)

-- 
Regards,

Laurent Pinchart

