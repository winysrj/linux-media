Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:36837 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIBPCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 11:02:47 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBA00DIY4GL2140@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 11:02:45 -0400 (EDT)
Date: Tue, 02 Sep 2014 12:02:40 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Changbing Xiong <cb.xiong@samsung.com>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH 1/3] media: fix kernel deadlock due to tuner pull-out while
 playing
Message-id: <20140902120240.2e85bd68.m.chehab@samsung.com>
In-reply-to: <1408586666-2105-1-git-send-email-cb.xiong@samsung.com>
References: <1408586666-2105-1-git-send-email-cb.xiong@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Changbing,

All 3 patches on this series seem OK on my eyes. I'll do some tests with them
and see what happens.

Yet, there are some issues on the way you're sending the patches.

First of all, it seems that patchwork is messing with your From:, removing
your name. I just fixed it there.

Em Thu, 21 Aug 2014 10:04:25 +0800
Changbing Xiong <cb.xiong@samsung.com> escreveu:

> Enviroment: odroidx2 + Hauppauge(WinTV-Aero-M)
> Normally, ADAP_STREAMING bit is set in dvb_usb_start_feed and cleared in dvb_usb_stop_feed.
> But in exceptional cases, for example, when the tv is playing programs, and the tuner is pulled out.
> then dvb_usbv2_disconnect is called, it will first call dvb_usbv2_adapter_frontend_exit to stop
> dvb_frontend_thread, and then call dvb_usbv2_adapter_dvb_exit to clear ADAP_STREAMING bit, At this point,
> if dvb_frontend_thread is sleeping and wait for ADAP_STREAMING to be cleared to get out of sleep.
> then dvb_frontend_thread can never be stoped, because clearing ADAP_STREAMING bit is performed after
> dvb_frontend_thread is stopped(i.e. performed in dvb_usbv2_adapter_dvb_exit), So deadlock becomes true.

Second, please avoid big lines and just one paragraph. I rewrote this.

It is really boring and harder to understand when it is like that. Also,
we generally use no more than 72 cols on the patches, as we want to be
able to read them well with 80 cols standard tty terminals.

See the patch that will be merged.

>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  mode change 100644 => 100755 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c

Third, why are you changing the mode on all your 3 patches?

It makes no sense to transform a .c file into an exec file.

No need to further action from you, as I already fixed them when
applying, but please fix your environment to avoid future rework
from the maintainers.

Regards,
Mauro
