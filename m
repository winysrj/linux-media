Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:40142 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbZKYLKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 06:10:41 -0500
Received: by gxk26 with SMTP id 26so7548670gxk.1
        for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 03:10:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
References: <uzl6ig9iy.wl%morimoto.kuninori@renesas.com>
Date: Wed, 25 Nov 2009 20:10:47 +0900
Message-ID: <aec7e5c30911250310m46442ff7r5bd0c745a0ad9f42@mail.gmail.com>
Subject: Re: [PATCH] soc-camera: Add mt9t112 camera support
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Guennadi <g.liakhovetski@gmx.de>,
	Linux-V4L2 <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 19, 2009 at 6:15 PM, Kuninori Morimoto
<morimoto.kuninori@renesas.com> wrote:
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>>> Guennadi
>
> I add new number in v4l2-chip-ident.h
> Is it OK for you ?
>
> This camera is very picky.
> So, it have a lot of constant value.
>
> The register of mt9t112 and mt9t111 are same.
> But I have mt9t112 only.
> mt9t111 should also work, but I can not check.
>
> This patch is based on your 20091105 patches.
>
>  drivers/media/video/Kconfig     |    6 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/mt9t112.c   | 1158 +++++++++++++++++++++++++++++++++++++++
>  include/media/mt9t112.h         |   32 ++
>  include/media/v4l2-chip-ident.h |    2 +
>  5 files changed, 1199 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9t112.c
>  create mode 100644 include/media/mt9t112.h

Hi Morimoto-san,

Do you have any mt9t112 platform data for the ecovec board? I'd like
to try out this patch but I don't know which board specific parts that
are missing!

/ magnus
