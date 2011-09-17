Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52850 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1IQQYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 12:24:17 -0400
Received: from lancelot.localnet (unknown [91.178.181.94])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D0047359E9
	for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 16:24:16 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] USB: export video.h to the includes available for userspace
Date: Sat, 17 Sep 2011 18:24:14 +0200
References: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com> <1316273642-3624-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1316273642-3624-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109171824.15845.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 17 September 2011 17:34:02 Laurent Pinchart wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>

I'm not sure how this From: line got there, I'll fix it.

> The uvcvideo extension unit API requires constants defined in the
> video.h header. Add it to the list of includes exported to userspace.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/usb/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/usb/Kbuild b/include/linux/usb/Kbuild
> index ed91fb6..b607f35 100644
> --- a/include/linux/usb/Kbuild
> +++ b/include/linux/usb/Kbuild
> @@ -7,3 +7,4 @@ header-y += gadgetfs.h
>  header-y += midi.h
>  header-y += g_printer.h
>  header-y += tmc.h
> +header-y += video.h

-- 
Regards,

Laurent Pinchart
