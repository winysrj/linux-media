Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53813 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933888AbdKBCvk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 22:51:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2 08/26] media: v4l2-async: shut up an unitialized symbol warning
Date: Thu, 02 Nov 2017 04:51:40 +0200
Message-ID: <1844403.anYkCZaVIn@avalon>
In-Reply-To: <e510e9651f4c8672ab7f64df4a55863b4b9cb787.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com> <e510e9651f4c8672ab7f64df4a55863b4b9cb787.1509569763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Wednesday, 1 November 2017 23:05:45 EET Mauro Carvalho Chehab wrote:
> Smatch reports this warning:
> 	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev()
> error: uninitialized symbol 'ret'.
> 
> However, there's nothing wrong there. So, just shut up the
> warning.

Nothing wrong, really ? ret does seem to be used uninitialized when the 
function returns at the very last line.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index 49f7eccc76db..5bc861c4ae5c
> 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -532,7 +532,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *subdev_notifier;
>  	struct v4l2_async_notifier *notifier;
> -	int ret;
> +	int uninitialized_var(ret);
> 
>  	/*
>  	 * No reference taken. The reference is held by the device


-- 
Regards,

Laurent Pinchart
