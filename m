Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61711 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3FUEUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 00:20:22 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so6126355wgh.35
        for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 21:20:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371760096-19256-3-git-send-email-hverkuil@xs4all.nl>
References: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl> <1371760096-19256-3-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 21 Jun 2013 09:50:01 +0530
Message-ID: <CA+V-a8tzvJioyg247wwODNcn36yJM9kX+-ovshL1uQhTAJVPew@mail.gmail.com>
Subject: Re: [REVIEW PATCH 3/3] omap_vout: fix compiler warning
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Fri, Jun 21, 2013 at 1:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> media-git/drivers/media/platform/omap/omap_vout.c: In function ‘omapvid_init’:
> media-git/drivers/media/platform/omap/omap_vout.c:382:17: warning: ‘mode’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   vout->dss_mode = video_mode_to_dss_mode(vout);
>                  ^
> media-git/drivers/media/platform/omap/omap_vout.c:332:23: note: ‘mode’ was declared here
>   enum omap_color_mode mode;
>                        ^
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.lad@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
