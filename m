Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43426 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbcBLJug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:50:36 -0500
Subject: Re: [PATCH 01/11] [media] v4l2-mc.h: prevent it for being included
 twice
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	no To-header on input <""@pop.xs4all.nl>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
 <ee25e26aaa5280050e7d216b80ecf4fe5cab8237.1455269986.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BDAAE6.9090202@xs4all.nl>
Date: Fri, 12 Feb 2016 10:50:30 +0100
MIME-Version: 1.0
In-Reply-To: <ee25e26aaa5280050e7d216b80ecf4fe5cab8237.1455269986.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2016 10:44 AM, Mauro Carvalho Chehab wrote:
> Don't let it be included twice, to avoid compiler issues.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  include/media/v4l2-mc.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 6fad97277a0b..20f1ee285947 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -14,6 +14,9 @@
>   * GNU General Public License for more details.
>   */
>  
> +#ifndef _V4L2_MC_H
> +#define _V4L2_MC_H
> +
>  #include <media/media-device.h>
>  
>  /**
> @@ -136,3 +139,5 @@ struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
>  }
>  
>  #endif
> +
> +#endif
> 

