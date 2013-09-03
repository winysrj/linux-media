Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3ICU2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 16:28:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 04/19] uvcvideo: Create separate debugfs entries for each streaming interface.
Date: Tue, 03 Sep 2013 22:28:41 +0200
Message-ID: <1776624.xH4KSMJxKi@avalon>
In-Reply-To: <1377829038-4726-5-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-5-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:03 Pawel Osciak wrote:
> Add interface number to debugfs entry name to be able to create separate
> entries for each streaming interface for devices exposing more than one,
> instead of failing to create more than one.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_debugfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_debugfs.c
> b/drivers/media/usb/uvc/uvc_debugfs.c index 14561a5..0663fbd 100644
> --- a/drivers/media/usb/uvc/uvc_debugfs.c
> +++ b/drivers/media/usb/uvc/uvc_debugfs.c
> @@ -84,7 +84,8 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
>  	if (uvc_debugfs_root_dir == NULL)
>  		return -ENODEV;
> 
> -	sprintf(dir_name, "%u-%u", udev->bus->busnum, udev->devnum);
> +	sprintf(dir_name, "%u-%u-%u", udev->bus->busnum, udev->devnum,

What about %u-%u.%u ? The USB subsystem names devices using devnum.intfnum 
(which can be seen in /sys/bus/usb/devices/ for instance), so I believe it 
would be a good idea to follow the same naming conventions.

> +			stream->intfnum);
> 
>  	dent = debugfs_create_dir(dir_name, uvc_debugfs_root_dir);
>  	if (IS_ERR_OR_NULL(dent)) {
-- 
Regards,

Laurent Pinchart

