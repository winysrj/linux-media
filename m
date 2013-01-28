Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2841 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3A1Khz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:37:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 6/7] saa7134: v4l2-compliance: remove V4L2_IN_ST_NO_SYNC from enum_input
Date: Mon, 28 Jan 2013 11:37:32 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <1359315912-1767-7-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-7-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281137.32942.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 20:45:11 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: don't set bogus V4L2_IN_ST_NO_SYNC
> flag in enum_input as it's for digital video only

I think there is a lot to be said for allowing this particular flag for analog
as well.

There are two types of flags here: flags relating the digital tuners (those
should not be used) and flags relating to sync issues. V4L2_IN_ST_NO_SYNC
is perfectly valid as a way to report sync problems.

I think a better solution is to allow this flag and to reorganize the 'Input
Status Flags' documentation:

- rename the "Analog Video" header to "Video Sync"
- rename the "Digital Video" header to "Digital Tuner (Deprecated)"
- move V4L2_IN_ST_NO_SYNC to the "Video Sync" section

Basically you have a number of video sync states:

1) NO_POWER: the device is off
2) NO_SIGNAL: the device is on, but there is no incoming signal
3) NO_SYNC: there is a signal, but we can't sync at all
4) NO_H_LOCK: there is a signal, we detect video lines, but we can't
   get a horizontal sync
5) NO_COLOR: there is no color signal at all
6) COLOR_KILL: we see a color signal, but we can't lock to it.

Note that not a single driver uses COLOR_KILL at the moment, but I know it
can be used.

If you can think of a way of improving the documentation w.r.t. these sync
status flags, then that would be great. Perhaps the table shouldn't be in
the order of the value but in a more logical order.

Regards,

	Hans

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
> 
