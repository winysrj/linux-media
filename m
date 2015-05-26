Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbEZOP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 10:15:27 -0400
Date: Tue, 26 May 2015 07:15:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Piotr S. Staszewski" <p.staszewski@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] staging: media: omap4iss: Reformat overly long lines
Message-ID: <20150526141524.GD21573@kroah.com>
References: <20150526085418.GA22775@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150526085418.GA22775@swordfish>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2015 at 10:54:18AM +0200, Piotr S. Staszewski wrote:
> This reformats lines that were previously above 80 characters long,
> improving readability and making checkpatch.pl happy.
> 
> Signed-off-by: Piotr S. Staszewski <p.staszewski@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss_csi2.c    | 21 ++++++++++++-------
>  drivers/staging/media/omap4iss/iss_ipipe.c   | 30 ++++++++++++++++++----------
>  drivers/staging/media/omap4iss/iss_ipipeif.c | 10 ++++++----
>  drivers/staging/media/omap4iss/iss_resizer.c |  8 +++++---
>  4 files changed, 44 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
> index d7ff769..a8714bb 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.c
> +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> @@ -224,7 +224,8 @@ static u16 csi2_ctx_map_format(struct iss_csi2_device *csi2)
>  		fmtidx = 3;
>  		break;
>  	default:
> -		WARN(1, KERN_ERR "CSI2: pixel format %08x unsupported!\n",
> +		WARN(1,
> +		     KERN_ERR "CSI2: pixel format %08x unsupported!\n",

That line wasn't over 80 characters long, why change it?

greg k-h
