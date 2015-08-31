Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58255 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbbHaLpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:45:17 -0400
Message-ID: <55E43E15.6060302@xs4all.nl>
Date: Mon, 31 Aug 2015 13:44:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 40/55] [media] media.h: don't use legacy entity macros
 at Kernel
References: <cover.1440902901.git.mchehab@osg.samsung.com> <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Put the legacy MEDIA_ENT_* macros under a #ifndef __KERNEL__,
> in order to be sure that none of those old symbols are used
> inside the Kernel.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index cd486fc25f1e..4186891e5e81 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -107,6 +107,7 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 3)
>  #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 4)
>  
> +#ifndef __KERNEL__
>  /* Legacy symbols used to avoid userspace compilation breakages */
>  #define MEDIA_ENT_TYPE_SHIFT		16
>  #define MEDIA_ENT_TYPE_MASK		0x00ff0000
> @@ -120,6 +121,7 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
>  #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
>  #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> +#endif
>  
>  /* Entity types */
>  
> 

