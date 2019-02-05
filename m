Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9621AC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715C6217F9
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 09:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfBEJxf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:53:35 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37034 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbfBEJxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 04:53:34 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3172B634C7E;
        Tue,  5 Feb 2019 11:52:15 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gqxOq-0002yA-5i; Tue, 05 Feb 2019 11:52:16 +0200
Date:   Tue, 5 Feb 2019 11:52:16 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
Subject: Re: compile error at sun6i_video
Message-ID: <20190205095216.f2fg5vjvqqhgs6as@valkosipuli.retiisi.org.uk>
References: <878syukax3.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878syukax3.wl-kuninori.morimoto.gx@renesas.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Morimoto-san,

On Tue, Feb 05, 2019 at 03:38:29PM +0900, Kuninori Morimoto wrote:
> 
> Hi MultiMedia ML
> 
> I got below compile error at SH.
> 
>   ...
>   CC      drivers/tty/tty_io.o
> /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c: In function 'sun6i_video_start_streaming':
> /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:141:29: error: passing argument 1 of 'media_pipeline_start' from incompatible pointer type [-Werror=incompatible-pointer-types]
>   ret = media_pipeline_start(&video->vdev.entity, &video->vdev.pipe);
>                              ^~~~~~~~~~~~~~~~~~~
> In file included from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-device.h:26,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/v4l2-device.h:24,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:10:
> /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-entity.h:1030:84: note: expected 'struct media_pad *' but argument is of type 'struct media_entity *'
>  __must_check int media_pipeline_start(struct media_pad *pad,
>                                                                                     ^  
> /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:205:22: error: passing argument 1 of 'media_pipeline_stop' from incompatible pointer type [-Werror=incompatible-pointer-types]
>   media_pipeline_stop(&video->vdev.entity);
>                       ^~~~~~~~~~~~~~~~~~~
> In file included from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-device.h:26,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/v4l2-device.h:24,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:10:
> /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-entity.h:1055:44: note: expected 'struct media_pad *' but argument is of type 'struct media_entity *'
>  void media_pipeline_stop(struct media_pad *pad);
>                           ~~~~~~~~~~~~~~~~~~^~~
> /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c: In function 'sun6i_video_stop_streaming':
> /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:229:22: error: passing argument 1 of 'media_pipeline_stop' from incompatible pointer type [-Werror=incompatible-pointer-types]
>   media_pipeline_stop(&video->vdev.entity);
>                       ^~~~~~~~~~~~~~~~~~~
> In file included from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-device.h:26,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/include/media/v4l2-device.h:24,
>                  from /opt/RB02197/home/morimoto/save/WORK/linux/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c:10:
> /opt/RB02197/home/morimoto/save/WORK/linux/include/media/media-entity.h:1055:44: note: expected 'struct media_pad *' but argument is of type 'struct media_entity *'
>  void media_pipeline_stop(struct media_pad *pad);
>                           ~~~~~~~~~~~~~~~~~~^~~

Do you have the patches Niklas's v4l2/mux (or my vc) branch in your tree?
They change a few things on the way and drivers need to be converted.
Drivers that have been added since the patches were written do need to be
converted as well, and I suppose the sun6i_video driver is one of them.

Cc Niklas.

-- 
Kind regards,

Sakari Ailus
