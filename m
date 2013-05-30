Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59770 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694Ab3E3BR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 21:17:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCHv1 18/38] media/i2c: remove g_chip_ident op.
Date: Thu, 30 May 2013 03:17:23 +0200
Message-ID: <4324449.niclkIejJB@avalon>
In-Reply-To: <1369825211-29770-19-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl> <1369825211-29770-19-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wednesday 29 May 2013 12:59:51 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is no longer needed since the core now handles this through
> DBG_G_CHIP_INFO.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
>  drivers/media/i2c/ad9389b.c              |   21 +-----
>  drivers/media/i2c/adv7170.c              |   13 ----
>  drivers/media/i2c/adv7175.c              |    9 ---
>  drivers/media/i2c/adv7180.c              |   10 ---
>  drivers/media/i2c/adv7183.c              |   22 -------
>  drivers/media/i2c/adv7343.c              |   10 ---
>  drivers/media/i2c/adv7393.c              |   10 ---
>  drivers/media/i2c/adv7604.c              |   18 -----
>  drivers/media/i2c/ak881x.c               |   34 +---------
>  drivers/media/i2c/bt819.c                |   14 ----
>  drivers/media/i2c/bt856.c                |    9 ---
>  drivers/media/i2c/bt866.c                |   13 ----
>  drivers/media/i2c/cs5345.c               |   17 -----
>  drivers/media/i2c/cs53l32a.c             |   10 ---
>  drivers/media/i2c/cx25840/cx25840-core.c |   14 ----
>  drivers/media/i2c/ks0127.c               |   16 -----
>  drivers/media/i2c/m52790.c               |   15 -----
>  drivers/media/i2c/msp3400-driver.c       |   10 ---
>  drivers/media/i2c/mt9m032.c              |    9 +--
>  drivers/media/i2c/mt9p031.c              |    1 -
>  drivers/media/i2c/mt9v011.c              |   24 -------

For the Aptina sensors drivers,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  drivers/media/i2c/noon010pc30.c          |    1 -
>  drivers/media/i2c/ov7640.c               |    1 -
>  drivers/media/i2c/ov7670.c               |   17 -----
>  drivers/media/i2c/saa6588.c              |    9 ---
>  drivers/media/i2c/saa7110.c              |    9 ---
>  drivers/media/i2c/saa7115.c              |  105 +++++++++++++--------------
>  drivers/media/i2c/saa7127.c              |   47 +++++--------
>  drivers/media/i2c/saa717x.c              |    7 --
>  drivers/media/i2c/saa7185.c              |    9 ---
>  drivers/media/i2c/saa7191.c              |   10 ---
>  drivers/media/i2c/tda9840.c              |   13 ----
>  drivers/media/i2c/tea6415c.c             |   13 ----
>  drivers/media/i2c/tea6420.c              |   13 ----
>  drivers/media/i2c/ths7303.c              |   25 +------
>  drivers/media/i2c/tvaudio.c              |    9 ---
>  drivers/media/i2c/tvp514x.c              |    1 -
>  drivers/media/i2c/tvp5150.c              |   24 -------
>  drivers/media/i2c/tvp7002.c              |   34 ----------
>  drivers/media/i2c/tw2804.c               |    1 -
>  drivers/media/i2c/upd64031a.c            |   17 -----
>  drivers/media/i2c/upd64083.c             |   17 -----
>  drivers/media/i2c/vp27smpx.c             |    9 ---
>  drivers/media/i2c/vpx3220.c              |   14 ----
>  drivers/media/i2c/vs6624.c               |   22 -------
>  drivers/media/i2c/wm8739.c               |    9 ---
>  drivers/media/i2c/wm8775.c               |    9 ---
>  47 files changed, 73 insertions(+), 671 deletions(-)

-- 
Regards,

Laurent Pinchart

