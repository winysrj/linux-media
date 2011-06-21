Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab1FUTYM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 15:24:12 -0400
Message-ID: <4E00EFD1.40307@redhat.com>
Date: Tue, 21 Jun 2011 16:24:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RESEND PATCH v19 0/6] davinci vpbe: dm6446 v4l2 driver
References: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF736@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF736@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-06-2011 04:03, Hadli, Manjunath escreveu:
> Mauro,
> 
> Can you consider this patch series for a pull?

Next time, could you please add on your tree and send me a git pull request?

Patchwork is currently not reliable. I have a backup process, but
a git pull request works better and I won't have the risk of
applying the wrong patches or at a wrong order.

In this specific case, as all patches were caught by patchwork,
I'll apply from your emails after reviewing them.

Thanks,
Mauro

> 
> -Manju
> 
> On Fri, Jun 17, 2011 at 12:31:30, Hadli, Manjunath wrote:
>> fixed a wrong file inclusion in one of the patches
>>
>> Manjunath Hadli (6):
>>   davinci vpbe: V4L2 display driver for DM644X SoC
>>   davinci vpbe: VPBE display driver
>>   davinci vpbe: OSD(On Screen Display) block
>>   davinci vpbe: VENC( Video Encoder) implementation
>>   davinci vpbe: Build infrastructure for VPBE driver
>>   davinci vpbe: Readme text for Dm6446 vpbe
>>
>>  Documentation/video4linux/README.davinci-vpbe |   93 ++
>>  drivers/media/video/davinci/Kconfig           |   23 +
>>  drivers/media/video/davinci/Makefile          |    2 +
>>  drivers/media/video/davinci/vpbe.c            |  864 ++++++++++++
>>  drivers/media/video/davinci/vpbe_display.c    | 1860 +++++++++++++++++++++++++
>>  drivers/media/video/davinci/vpbe_osd.c        | 1231 ++++++++++++++++
>>  drivers/media/video/davinci/vpbe_osd_regs.h   |  364 +++++
>>  drivers/media/video/davinci/vpbe_venc.c       |  566 ++++++++
>>  drivers/media/video/davinci/vpbe_venc_regs.h  |  177 +++
>>  include/media/davinci/vpbe.h                  |  184 +++
>>  include/media/davinci/vpbe_display.h          |  147 ++
>>  include/media/davinci/vpbe_osd.h              |  394 ++++++
>>  include/media/davinci/vpbe_types.h            |   91 ++
>>  include/media/davinci/vpbe_venc.h             |   45 +
>>  14 files changed, 6041 insertions(+), 0 deletions(-)  create mode 100644 Documentation/video4linux/README.davinci-vpbe
>>  create mode 100644 drivers/media/video/davinci/vpbe.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_display.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
>>  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
>>  create mode 100644 include/media/davinci/vpbe.h  create mode 100644 include/media/davinci/vpbe_display.h
>>  create mode 100644 include/media/davinci/vpbe_osd.h  create mode 100644 include/media/davinci/vpbe_types.h
>>  create mode 100644 include/media/davinci/vpbe_venc.h
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

