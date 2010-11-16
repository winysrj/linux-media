Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051Ab0KPOTt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 09:19:49 -0500
Message-ID: <4CE292FE.5090604@redhat.com>
Date: Tue, 16 Nov 2010 12:19:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: matti.j.aaltonen@nokia.com
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL REQUEST v2.]  WL1273 FM Radio driver.
References: <E1P9THI-0003aa-4H@www.linuxtv.org>	 <1289833803.5350.67.camel@masi.mnp.nokia.com> <1289914513.5350.72.camel@masi.mnp.nokia.com>
In-Reply-To: <1289914513.5350.72.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-11-2010 11:35, Matti J. Aaltonen escreveu:
> Hi.
> 
> The radio pull request, now using http protocol.
> 
> The following changes since commit
> f6614b7bb405a9b35dd28baea989a749492c46b2:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../sfrench/cifs-2.6
> 
> are available in the git repository at:
> 
>   http://git.gitorious.org/wl1273-fm-driver/wl1273-fm-driver.git master
> 
> Matti J. Aaltonen (2):
>       MFD: WL1273 FM Radio: MFD driver for the FM radio.
>       V4L2: WL1273 FM Radio: Controls for the FM radio.

Hi Matti,

The proper way is to add the core stuff to drivers/media/radio, adding just
the mfd glue at drivers/mfd. I also want mfd's maintainer ack of the mfd
patch.

I just added an mfd driver right now. You may use it as an example:
	http://git.linuxtv.org/media_tree.git?a=commit;h=ef6ce9acc5f87e253c97dfd5301f8036f937f595
	http://git.linuxtv.org/media_tree.git?a=commit;h=552faf8580766b6fc944cb966f690ed0624a5564

> 
>  drivers/media/radio/Kconfig        |   16 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 1841
> ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |    6 +
>  drivers/mfd/Makefile               |    1 +
>  drivers/mfd/wl1273-core.c          |  617 ++++++++++++
>  include/linux/mfd/wl1273-core.h    |  330 +++++++
>  7 files changed, 2812 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
>  create mode 100644 drivers/mfd/wl1273-core.c
>  create mode 100644 include/linux/mfd/wl1273-core.h
> 
> 
> B.R.
> Matti A.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

