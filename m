Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33892 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbcEDVQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 17:16:59 -0400
Received: by mail-qg0-f54.google.com with SMTP id 90so30740816qgz.1
        for <linux-media@vger.kernel.org>; Wed, 04 May 2016 14:16:58 -0700 (PDT)
Date: Thu, 5 May 2016 00:14:45 +0300
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160504211444.GA23122@acer>
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 04, 2016 at 01:21:20PM -0300, Ismael Luceno wrote:
> From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> Such frame size is met in practice. Also report oversized frames.
> 
> [ismael: Reworked warning and commit message]
> 
> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

I object against merging the first part.

> ---
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> index 67a14c4..f98017b 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
> @@ -33,7 +33,7 @@
>  #include "solo6x10-jpeg.h"
>  
>  #define MIN_VID_BUFFERS		2
> -#define FRAME_BUF_SIZE		(196 * 1024)
> +#define FRAME_BUF_SIZE		(200 * 1024)

Please don't push this.
It doesn't matter whether there are 196 or 200 KiB because there happen
bigger frames.
I don't remember details so I cannot point to all time max frame size.
AFAIK this issue appeared on one particular customer installation. I
don't monitor it closely right now. I think I have compiled custom
package for that setup with FRAME_BUF_SIZE increased much more (maybe
10x?).
