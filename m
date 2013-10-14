Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:53588 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3JNMaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 08:30:55 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUN00G3TS38CW50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Oct 2013 08:30:54 -0400 (EDT)
Date: Mon, 14 Oct 2013 09:30:50 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.13] Various fixes
Message-id: <20131014093050.6460c1c7@samsung.com>
In-reply-to: <524E9A77.7090205@xs4all.nl>
References: <524E9A77.7090205@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Oct 2013 12:37:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Just a bunch of various fixes. Most notably the solo fixes for big-endian systems:
> these fixes were removed when I did the large sync to the Bluecherry code base for the
> solo driver. Many thanks to Krzysztof for doing this work again.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit d10e8280c4c2513d3e7350c27d8e6f0fa03a5f71:
> 
>   [media] cx24117: use hybrid_tuner_request/release_state to share state between multiple instances (2013-10-03 07:40:12 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.13
> 
> for you to fetch changes up to fffc9c8a324c7b43db9e359ae4710176fa66f432:
> 
>   radio-sf16fmr2: Remove redundant dev_set_drvdata (2013-10-04 12:32:42 +0200)
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       snd_tea575x: precedence bug in fmr2_tea575x_get_pins()
> 
> Krzysztof Hałasa (4):
>       SOLO6x10: don't do DMA from stack in solo_dma_vin_region().
>       SOLO6x10: Remove unused #define SOLO_DEFAULT_GOP
>       SOLO6x10: Fix video encoding on big-endian systems.
>       SOLO6x10: Fix video headers on certain hardware.
> 
> Michael Opdenacker (1):
>       davinci: remove deprecated IRQF_DISABLED

This patch was likely applied already:

testing if patches/0003-davinci-remove-deprecated-IRQF_DISABLED.patch applies
patch -p1 -i patches/0003-davinci-remove-deprecated-IRQF_DISABLED.patch --dry-run -t -N
checking file drivers/media/platform/davinci/vpbe_display.c
Reversed (or previously applied) patch detected!  Skipping patch.
1 out of 1 hunk ignored
checking file drivers/media/platform/davinci/vpfe_capture.c
Reversed (or previously applied) patch detected!  Skipping patch.
2 out of 2 hunks ignored
 drivers/media/platform/davinci/vpbe_display.c |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
Subject: davinci: remove deprecated IRQF_DISABLED
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Mon, 9 Sep 2013 02:30:11 +0000
Signed-off-by:	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by:	Hans Verkuil <hans.verkuil@cisco.com>
Maint: 		"Lad, Prabhakar" <prabhakar.csengg@gmail.com> (maintainer:TI DAVINCI SERIES...)
>>> Patch patches/0003-davinci-remove-deprecated-IRQF_DISABLED.patch doesn't apply
Patch is likely applied
Can't connect to server nave. at /home/mchehab/bin/search_msg.pl line 64.
Duplicated md5sum patches
Likely duplicated patches (need manual check)


> 
> Sachin Kamat (1):
>       radio-sf16fmr2: Remove redundant dev_set_drvdata
> 
> Sylwester Nawrocki (1):
>       v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function prototype
> 
>  drivers/media/platform/davinci/vpbe_display.c      |   2 +-
>  drivers/media/platform/davinci/vpfe_capture.c      |   4 +-
>  drivers/media/radio/radio-sf16fmr2.c               |   5 +--
>  drivers/media/v4l2-core/v4l2-ctrls.c               |   6 +--
>  drivers/staging/media/solo6x10/solo6x10-disp.c     |  24 ++++++++----
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 153 ++++++++++++++++++++++++++++++++++++++++++++-----------------------------
>  drivers/staging/media/solo6x10/solo6x10.h          |   1 -
>  include/media/v4l2-common.h                        |   2 +-
>  8 files changed, 117 insertions(+), 80 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
