Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52704 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbcCALnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2016 06:43:35 -0500
Date: Tue, 1 Mar 2016 08:43:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 3/4] media: Properly handle user pointers
Message-ID: <20160301084330.173cd3ad@recife.lan>
In-Reply-To: <1456174024-11389-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1456174024-11389-1-git-send-email-sakari.ailus@linux.intel.com>
	<1456174024-11389-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Feb 2016 22:47:03 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Mark pointers containing user pointers as such.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Looks OK to me.

> ---
>  drivers/media/media-device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 5ebb3cd..f001c27 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -245,10 +245,10 @@ static long __media_device_get_topology(struct media_device *mdev,
>  	struct media_interface *intf;
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
>  


-- 
Thanks,
Mauro
