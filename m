Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580Ab2INRek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 13:34:40 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so1362498bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:34:39 -0700 (PDT)
Message-ID: <50536AAD.2030306@gmail.com>
Date: Fri, 14 Sep 2012 19:34:37 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv3 API PATCH 28/31] Set vfl_dir for all display or m2m drivers.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <77dc4c90ae1e875bb5f5530003390c19a4ebab3e.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <77dc4c90ae1e875bb5f5530003390c19a4ebab3e.1347619766.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:57 PM, Hans Verkuil wrote:
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/pci/ivtv/ivtv-streams.c         |    3 +++
>   drivers/media/pci/zoran/zoran_card.c          |    4 ++++
>   drivers/media/platform/coda.c                 |    1 +
>   drivers/media/platform/davinci/vpbe_display.c |    1 +
>   drivers/media/platform/davinci/vpif_display.c |    1 +
>   drivers/media/platform/m2m-deinterlace.c      |    1 +
>   drivers/media/platform/mem2mem_testdev.c      |    1 +
>   drivers/media/platform/mx2_emmaprp.c          |    1 +
>   drivers/media/platform/omap/omap_vout.c       |    1 +
>   drivers/media/platform/omap3isp/ispvideo.c    |    1 +
>   drivers/media/platform/s5p-fimc/fimc-m2m.c    |    1 +
>   drivers/media/platform/s5p-g2d/g2d.c          |    1 +
>   drivers/media/platform/s5p-jpeg/jpeg-core.c   |    1 +
>   drivers/media/platform/s5p-mfc/s5p_mfc.c      |    1 +
>   drivers/media/platform/s5p-tv/mixer_video.c   |    1 +
>   drivers/media/platform/sh_vou.c               |    1 +
>   drivers/media/usb/uvc/uvc_driver.c            |    2 ++

For drivers/media/platform/s5p-*,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
