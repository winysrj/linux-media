Return-path: <mchehab@gaivota>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2831 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0LUOP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 09:15:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [git:v4l-dvb/for_v2.6.38] [media] [v18, 2/2] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
Date: Tue, 21 Dec 2010 15:15:50 +0100
Cc: linux-media@vger.kernel.org
References: <E1PV2qd-0000hz-SU@www.linuxtv.org>
In-Reply-To: <E1PV2qd-0000hz-SU@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012211515.50613.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday, December 21, 2010 15:05:08 Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] [v18,2/2] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
> Author:  Matti Aaltonen <matti.j.aaltonen@nokia.com>
> Date:    Fri Dec 10 11:41:34 2010 -0300
> 
> This module implements V4L2 controls for the Texas Instruments
> WL1273 FM Radio and handles the communication with the chip.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/radio/Kconfig        |   16 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 2331 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 2348 insertions(+), 0 deletions(-)
> 

<snip>

> +
> +static const struct v4l2_file_operations wl1273_fops = {
> +	.owner		= THIS_MODULE,
> +	.read		= wl1273_fm_fops_read,
> +	.write		= wl1273_fm_fops_write,
> +	.poll		= wl1273_fm_fops_poll,
> +	.ioctl		= video_ioctl2,

Matti,

Can you make a patch that replaces .ioctl with .unlocked_ioctl?
This should be done for 2.6.38.

See this thread for more information on how to do this:

http://www.spinics.net/lists/linux-media/msg26604.html

Thanks!

	Hans

> +	.open		= wl1273_fm_fops_open,
> +	.release	= wl1273_fm_fops_release,
> +};

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
