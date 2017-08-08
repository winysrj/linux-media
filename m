Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:37424 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdHHOjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 10:39:21 -0400
Received: by mail-wr0-f170.google.com with SMTP id 33so13737262wrz.4
        for <linux-media@vger.kernel.org>; Tue, 08 Aug 2017 07:39:21 -0700 (PDT)
Message-ID: <5989CD1C.7080308@baylibre.com>
Date: Tue, 08 Aug 2017 16:39:24 +0200
From: Neil Armstrong <narmstrong@baylibre.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH] MAINTAINERS: add entry for meson ao cec driver
References: <323ef568-a88f-5bc1-390c-fd630dfc4535@xs4all.nl>
In-Reply-To: <323ef568-a88f-5bc1-390c-fd630dfc4535@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 08/08/2017 16:18, Hans Verkuil a écrit :
> Add entry to the MAINTAINERS file for the meson ao cec driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9826a918d37a..ed568e1ac856 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8671,6 +8671,16 @@ F:	drivers/leds/leds-menf21bmc.c
>  F:	drivers/hwmon/menf21bmc_hwmon.c
>  F:	Documentation/hwmon/menf21bmc
> 
> +MESON AO CEC DRIVER FOR AMLOGIC SOCS
> +M:	Neil Armstrong <narmstrong@baylibre.com>
> +L:	linux-media@lists.freedesktop.org
> +L:	linux-amlogic@lists.infradead.org
> +W:	http://linux-meson.com/
> +S:	Supported
> +F:	drivers/media/platform/meson/ao-cec.c
> +F:	Documentation/devicetree/bindings/media/meson-ao-cec.txt
> +T:	git git://linuxtv.org/media_tree.git
> +
>  METAG ARCHITECTURE
>  M:	James Hogan <james.hogan@imgtec.com>
>  L:	linux-metag@vger.kernel.org
> 

Hi Hans,

Thanks !

Acked-by: Neil Armstrong <narmstrong@baylibre.com>
