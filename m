Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab2HIUZ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 16:25:59 -0400
Message-ID: <50241CCE.2030000@redhat.com>
Date: Thu, 09 Aug 2012 17:25:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v8] media: Add stk1160 new driver
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch looks ok. Just a few comments:

Em 06-08-2012 10:38, Ezequiel Garcia escreveu:
> This driver adds support for stk1160 usb bridge as used in some
> video/audio usb capture devices.
> It is a complete rewrite of staging/media/easycap driver and
> it's expected as a replacement.
> ---

Please don't add a "---" here. Everything after a --- are discarded
by my scripts (and by most other kernel developer scripts).

> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Hmm... weren't it reviewed already be them?

> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/video/stk1160/Makefile
> new file mode 100644
> index 0000000..8f66a78
> --- /dev/null
> +++ b/drivers/media/video/stk1160/Makefile
> @@ -0,0 +1,12 @@
> +obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) := stk1160-ac97.o
> +
> +stk1160-y := 	stk1160-core.o \
> +		stk1160-v4l.o \
> +		stk1160-video.o \
> +		stk1160-i2c.o \
> +		$(obj-stk1160-ac97-y)
> +
> +obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
> +
> +ccflags-y += -Wall

You shouldn't be adding the above here.

> +ccflags-y += -Idrivers/media/video

Ah, please split this patch into two patches: one with the new driver
addition, and another one with the removal of the driver at staging.

That will help to make the patch smaller, and avoids mixing two different
things at the same place.

Thanks,
Mauro

