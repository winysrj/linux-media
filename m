Return-path: <linux-media-owner@vger.kernel.org>
Received: from dehamd003.servertools24.de ([31.47.254.18]:36168 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbbAIXMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2015 18:12:25 -0500
Message-ID: <54B05E05.3090409@ladisch.de>
Date: Sat, 10 Jan 2015 00:02:29 +0100
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, stefanr@s5r6.in-berlin.de
CC: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCH] media; firewire: Remove no longer needed fix me comment
	in firedtv-ci.c for the function,fdtv_ca_ioctl
References: <1420838221-3957-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1420838221-3957-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicholas Krause wrote:
> Removes the no longer fix me comment for if we need to set the tuner status with
> the line, avc_tuner_status(fdtv, &stat). This line is needed in order to set the
> tuner status after we have through the switch statement checking what fdtv function
> we need to call to use to try and setup the hardware successfully.

You have attempted to describe what fdtv_ca_ioctl() does, but your description
lacks any understanding of what avc_tuner_status() does, or how it might affect
the device, or whether it is necessary.

Please stop spamming us with useless patches.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/media/firewire/firedtv-ci.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
> index e63f582..9c038ba 100644
> --- a/drivers/media/firewire/firedtv-ci.c
> +++ b/drivers/media/firewire/firedtv-ci.c
> @@ -201,7 +201,6 @@ static int fdtv_ca_ioctl(struct file *file, unsigned int cmd, void *arg)
>  		err = -EOPNOTSUPP;
>  	}
>
> -	/* FIXME Is this necessary? */
>  	avc_tuner_status(fdtv, &stat);
>
>  	return err;
