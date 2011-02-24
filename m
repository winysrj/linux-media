Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab1BXNqL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 08:46:11 -0500
Message-ID: <4D666116.70605@redhat.com>
Date: Thu, 24 Feb 2011 10:45:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Matt Janus <hello@mattjan.us>, linux-media@vger.kernel.org,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: oops cx2341x control handler
References: <9AA38BEC-4364-4F45-968B-E33BA5098C34@mattjan.us> <201101252229.35418.hverkuil@xs4all.nl>
In-Reply-To: <201101252229.35418.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-01-2011 19:29, Hans Verkuil escreveu:
> Hi Matt,
> 
> On Tuesday, January 25, 2011 03:10:38 Matt Janus wrote:
>> A quick test with mplayer didn't error, when i tried to use mythtv the driver crashed and resulted in this:
> 
> I could reproduce this and the fix is below. Please test!

What's the status of this patch? Should it be applied or not?

Cheers,
Mauro
> 
> Regards,
> 
> 	Hans
> 
> From 6b7c84508e915f26a9b701ef2f5fa0b92ca62f2f Mon Sep 17 00:00:00 2001
> Message-Id: <6b7c84508e915f26a9b701ef2f5fa0b92ca62f2f.1295990866.git.hverkuil@xs4all.nl>
> From: Hans Verkuil <hverkuil@xs4all.nl>
> Date: Tue, 25 Jan 2011 22:25:39 +0100
> Subject: [PATCH] cx18: fix kernel oops when setting MPEG control before capturing.
> 
> The cxhdl->priv field was not set initially, only after capturing started.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/cx18/cx18-driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 869690b..877e201 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -713,6 +713,7 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
>  	cx->cxhdl.capabilities = CX2341X_CAP_HAS_TS | CX2341X_CAP_HAS_SLICED_VBI;
>  	cx->cxhdl.ops = &cx18_cxhdl_ops;
>  	cx->cxhdl.func = cx18_api_func;
> +	cx->cxhdl.priv = &cx->streams[CX18_ENC_STREAM_TYPE_MPG];
>  	ret = cx2341x_handler_init(&cx->cxhdl, 50);
>  	if (ret)
>  		return ret;

