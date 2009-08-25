Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40289 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZHYLX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 07:23:26 -0400
Date: Tue, 25 Aug 2009 20:23:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] soc-camera: fix recently introduced overlong lines
Message-ID: <20090825112327.GA5653@linux-sh.org>
References: <Pine.LNX.4.64.0908251258410.4810@axis700.grange> <Pine.LNX.4.64.0908251303240.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908251303240.4810@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 25, 2009 at 01:06:07PM +0200, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/boards/board-ap325rxa.c           |    3 ++-
>  drivers/media/video/mt9m111.c             |    9 +++++----
>  drivers/media/video/mt9v022.c             |    5 ++++-
>  drivers/media/video/mx1_camera.c          |    3 ++-
>  drivers/media/video/ov772x.c              |    6 ++++--
>  drivers/media/video/pxa_camera.c          |    3 ++-
>  drivers/media/video/soc_camera.c          |   14 +++++++++++---
>  drivers/media/video/soc_camera_platform.c |    3 ++-
>  drivers/media/video/tw9910.c              |    3 ++-
>  include/media/soc_camera.h                |   15 ++++++++++-----
>  10 files changed, 44 insertions(+), 20 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
