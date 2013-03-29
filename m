Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab3C2Mv4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 08:51:56 -0400
Date: Fri, 29 Mar 2013 09:51:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR v3.10] Move cypress_firmware to common
Message-ID: <20130329095142.5856e961@redhat.com>
In-Reply-To: <201303291246.39331.hverkuil@xs4all.nl>
References: <201303291246.39331.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Mar 2013 12:46:39 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> As discussed earlier (http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/62438)
> let's move this to common. It's a nice cleanup for go7007 as well which had a weird DVB
> dependency.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 9e7664e0827528701074875eef872f2be1dfaab8:
> 
>   [media] solo6x10: The size of the thresholds ioctls was too large (2013-03-29 08:34:23 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git cypress-common
> 
> for you to fetch changes up to 6e69c66b2dafc4927b88a15801e0f84585a28336:
> 
>   media: move dvb-usb-v2/cypress_firmware.c to media/common. (2013-03-29 12:42:32 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       media: move dvb-usb-v2/cypress_firmware.c to media/common.

That broke compilation:

drivers/media/usb/dvb-usb-v2/az6007.c: In function 'az6007_download_firmware':
drivers/media/usb/dvb-usb-v2/az6007.c:845:2: error: implicit declaration of function 'cypress_load_firmware' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

> 
>  drivers/media/common/Kconfig                                |    3 +++
>  drivers/media/common/Makefile                               |    2 ++
>  drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.c |   77 +++++++++++++++++++++++++++++++++---------------------------------
>  drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.h |    9 +++-----
>  drivers/media/usb/dvb-usb-v2/Kconfig                        |    6 +-----
>  drivers/media/usb/dvb-usb-v2/Makefile                       |    5 +----
>  drivers/media/usb/dvb-usb-v2/az6007.c                       |    2 +-
>  drivers/staging/media/go7007/Kconfig                        |    3 ++-
>  drivers/staging/media/go7007/Makefile                       |    6 +-----
>  drivers/staging/media/go7007/go7007-loader.c                |    4 ++--
>  10 files changed, 54 insertions(+), 63 deletions(-)

>  rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.c (88%)
>  rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.h (68%)

Why are out there so many changes? 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
