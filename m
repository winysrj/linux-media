Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36489 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728220AbeI3TTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 15:19:36 -0400
Date: Sun, 30 Sep 2018 05:39:25 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org,
        eric.bachard@free.fr
Subject: Re: [PATCH] media: uvcvideo: Support UVC 1.5 video probe & commit
 controls
Message-ID: <20180930123925.GB20353@kroah.com>
References: <20180930103816.5115-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180930103816.5115-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 30, 2018 at 01:38:16PM +0300, Laurent Pinchart wrote:
> From: ming_qian <ming_qian@realsil.com.cn>
> 
> commit f620d1d7afc7db57ab59f35000752840c91f67e7 upstream.
> 
> The length of UVC 1.5 video control is 48, and it is 34 for UVC 1.1.
> Change it to 48 for UVC 1.5 device, and the UVC 1.5 device can be
> recognized.
> 
> More changes to the driver are needed for full UVC 1.5 compatibility.
> However, at least the UVC 1.5 Realtek RTS5847/RTS5852 cameras have been
> reported to work well.
> 
> [laurent.pinchart@ideasonboard.com: Factor out code to helper function, update size checks]
> 
> Signed-off-by: ming_qian <ming_qian@realsil.com.cn>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Tested-by: Ana Guerrero Lopez <ana.guerrero@collabora.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> Hello,
> 
> This patch was originally marked as a stable candidate, but a driver-wide
> switch from __u{8,16,32} to u{8,16,32} created conflicts that prevented
> backporting. This version fixes the conflicts and is otherwise not modified.
> 
> The decision to mark the patch as a stable candidate came after reports from
> distro users that their UVC 1.5 camera was otherwise unusable. A guide has
> even been published to tell Debian users how to patch their kernel to fix the
> problem. Including the fix in stable will make their life much easier.

Now queued up, thanks.

greg k-h
