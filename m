Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35134 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbcBVN2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 08:28:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, shuahkh@osg.samsung.com
Subject: Re: [RFC 3/4] media: Properly handle user pointers
Date: Mon, 22 Feb 2016 15:28:51 +0200
Message-ID: <4745454.esNGAZoyuI@avalon>
In-Reply-To: <1456090575-28354-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090575-28354-1-git-send-email-sakari.ailus@linux.intel.com> <1456090575-28354-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Sunday 21 February 2016 23:36:14 Sakari Ailus wrote:
> Mark pointers containing user pointers as such.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 5ebb3cd..f001c27 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -245,10 +245,10 @@ static long __media_device_get_topology(struct
> media_device *mdev, struct media_interface *intf;
>  	struct media_pad *pad;
>  	struct media_link *link;
> -	struct media_v2_entity kentity, *uentity;
> -	struct media_v2_interface kintf, *uintf;
> -	struct media_v2_pad kpad, *upad;
> -	struct media_v2_link klink, *ulink;
> +	struct media_v2_entity kentity, __user *uentity;
> +	struct media_v2_interface kintf, __user *uintf;
> +	struct media_v2_pad kpad, __user *upad;
> +	struct media_v2_link klink, __user *ulink;
>  	unsigned int i;
>  	int ret = 0;

-- 
Regards,

Laurent Pinchart

