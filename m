Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3A1Kay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:30:54 -0500
Date: Mon, 28 Jan 2013 08:30:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 6/7] saa7134: v4l2-compliance: remove V4L2_IN_ST_NO_SYNC
 from enum_input
Message-ID: <20130128083046.206a3958@redhat.com>
In-Reply-To: <1359315912-1767-7-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
	<1359315912-1767-7-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Jan 2013 20:45:11 +0100
Ondrej Zary <linux@rainbow-software.org> escreveu:

> Make saa7134 driver more V4L2 compliant: don't set bogus V4L2_IN_ST_NO_SYNC
> flag in enum_input as it's for digital video only
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 0b42f0c..fff6735 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1757,8 +1757,6 @@ static int saa7134_enum_input(struct file *file, void *priv,
>  
>  		if (0 != (v1 & 0x40))
>  			i->status |= V4L2_IN_ST_NO_H_LOCK;
> -		if (0 != (v2 & 0x40))
> -			i->status |= V4L2_IN_ST_NO_SYNC;
>  		if (0 != (v2 & 0x0e))
>  			i->status |= V4L2_IN_ST_MACROVISION;
>  	}


Hmm... I'm not sure about this one. Very few drivers use those definitions,
but I suspect that this might potentially break some userspace applications.

It sounds more likely that v4l-compliance is doing the wrong thing here,
if it is complaining about that.

-- 

Cheers,
Mauro
