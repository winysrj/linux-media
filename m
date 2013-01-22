Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39326 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754529Ab3AVQhs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:37:48 -0500
Date: Tue, 22 Jan 2013 18:37:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC] media: Rename media_entity_remote_source to
 media_entity_remote_pad
Message-ID: <20130122163744.GA18639@valkosipuli.retiisi.org.uk>
References: <1358843095-4839-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358843095-4839-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, Andrzej!

On Tue, Jan 22, 2013 at 09:24:55AM +0100, Andrzej Hajda wrote:
> Function media_entity_remote_source actually returns the remote pad to
> the given one, regardless if this is the source or the sink pad.
> Name media_entity_remote_pad is more adequate for this function.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/media-framework.txt                |    2 +-
>  drivers/media/media-entity.c                     |   13 ++++++-------
>  drivers/media/platform/omap3isp/isp.c            |    6 +++---
>  drivers/media/platform/omap3isp/ispccdc.c        |    2 +-
>  drivers/media/platform/omap3isp/ispccp2.c        |    2 +-
>  drivers/media/platform/omap3isp/ispcsi2.c        |    2 +-
>  drivers/media/platform/omap3isp/ispvideo.c       |    6 +++---
>  drivers/media/platform/s3c-camif/camif-capture.c |    2 +-
>  drivers/media/platform/s5p-fimc/fimc-capture.c   |    8 ++++----
>  drivers/media/platform/s5p-fimc/fimc-lite.c      |    4 ++--
>  drivers/media/platform/s5p-fimc/fimc-mdevice.c   |    2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c  |   12 ++++++------
>  include/media/media-entity.h                     |    2 +-
>  13 files changed, 31 insertions(+), 32 deletions(-)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
