Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42858 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbaGRKyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:54:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [linuxtv-media:master 470/499] ERROR: "__aeabi_uldivmod" [drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.ko] undefined!
Date: Fri, 18 Jul 2014 12:54:32 +0200
Message-ID: <3139693.X0ad9DorED@avalon>
In-Reply-To: <53c88b73.EUNyETlXK5NV9LSY%fengguang.wu@intel.com>
References: <53c88b73.EUNyETlXK5NV9LSY%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 July 2014 10:50:27 kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git master
> head:   0ca1ba2aac5f6b26672099b13040c5b40db93486
> commit: 3ed1a0023c48db707db537ef8aeb21445db637a6 [470/499] [media] v4l:
> omap4iss: tighten omap4iss dependencies config: make ARCH=arm allmodconfig
> 
> All error/warnings:
> >> ERROR: "__aeabi_uldivmod"
> >> [drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.ko] undefined!

That's most probably unrelated to the patch being blamed. Antti, could you 
please have a look ?

-- 
Regards,

Laurent Pinchart

