Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3BEStp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 13:49:45 -0500
Date: Tue, 5 Feb 2013 16:49:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.9] Move cx2341x from media/i2c to media/common
Message-ID: <20130205164941.6052fd42@redhat.com>
In-Reply-To: <201301290956.20849.hverkuil@xs4all.nl>
References: <201301290956.20849.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Tue, 29 Jan 2013 09:56:20 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> The cx2341x module is a helper module for conexant-based MPEG encoders.
> It isn't an i2c module at all, instead it should be in common since it is
> used by 7 pci and usb drivers to handle the MPEG setup.
>     
> It also shouldn't be visible in the config menu as it is always
> selected automatically by those drivers that need it.

It should be noticed that the other non-i2c helper drivers also at
the i2c directories:
	$ grep -L i2c_client drivers/media/i2c/*.c|grep -v mod
	drivers/media/i2c/aptina-pll.c
	drivers/media/i2c/btcx-risc.c
	drivers/media/i2c/cx2341x.c
	drivers/media/i2c/smiapp-pll.c

A closer look may even hit some weird stuff, like tveeprom. This
particular helper driver is not an I2C driver, although it
has i2c_client symbol there, in order to optionally read the data
via I2C, instead of receiving it via an API call.

Also, I don't think cx2341x or any of those other helper drivers
deserve each its own directory.

So, IMHO, the better is to just live them at the i2c directory.
They might be moved, instead, to drivers/media/common (but without
creating subdirs there).

In any case, we should do the same for all those non-i2c helper
drivers. Just moving cx2341x and letting the others there will just
increase the mess.

> 
> This pull request moves it to the right directory.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:
> 
>   Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)
> 
> are available in the git repository at:
> 
> 
>   git://linuxtv.org/hverkuil/media_tree.git cx2341x
> 
> for you to fetch changes up to 15ee97480694257081933f3f78666de1c88eec5e:
> 
>   cx2341x: move from media/i2c to media/common (2013-01-29 09:47:49 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       cx2341x: move from media/i2c to media/common
> 
>  drivers/media/common/Kconfig                    |    1 +
>  drivers/media/common/Makefile                   |    2 +-
>  drivers/media/common/cx2341x/Kconfig            |    2 ++
>  drivers/media/common/cx2341x/Makefile           |    1 +
>  drivers/media/{i2c => common/cx2341x}/cx2341x.c |    0
>  drivers/media/i2c/Kconfig                       |   14 --------------
>  drivers/media/i2c/Makefile                      |    1 -
>  7 files changed, 5 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/media/common/cx2341x/Kconfig
>  create mode 100644 drivers/media/common/cx2341x/Makefile
>  rename drivers/media/{i2c => common/cx2341x}/cx2341x.c (100%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
