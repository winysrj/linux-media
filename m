Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51538 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJFJ1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 05:27:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
Date: Mon, 06 Oct 2014 11:26:50 +0200
Message-ID: <4788945.SoI4OqN9Zu@wuerfel>
In-Reply-To: <1412586626.4054.42.camel@x220>
References: <1412586626.4054.42.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 06 October 2014 11:10:26 Paul Bolle wrote:
>  config VIDEO_SAMSUNG_S5P_TV
>         bool "Samsung TV driver for S5P platform"
>         depends on PM_RUNTIME
> -       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
> +       depends on ARCH_EXYNOS || COMPILE_TEST
>         default n
>         ---help---
>           Say Y here to enable selecting the TV output devices for
> 

I wonder if it should now allow being built for ARCH_S5PV210.
Maybe it was a mistake to remove the PLAT_S5P symbol without changing
the use here?

Does S5PV210 have this device?

	Arnd
