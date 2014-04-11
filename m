Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49247 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaDKNEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 09:04:11 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so963349wib.5
        for <linux-media@vger.kernel.org>; Fri, 11 Apr 2014 06:04:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140411110822.GO4963@mwanda>
References: <20131106161342.GD15603@elgon.mountain>
	<20140411110822.GO4963@mwanda>
Date: Fri, 11 Apr 2014 10:04:09 -0300
Message-ID: <CAOMZO5D+APp=LcnVuCQYeCOtMDZ6KkyzHZ8js_XPC+DKHd-+Eg@mail.gmail.com>
Subject: Re: [media] coda: update CODA7541 to firmware 1.4.50
From: Fabio Estevam <festevam@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan/Philipp,

On Fri, Apr 11, 2014 at 8:08 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> What ever happened with this?
>
> regards,
> dan carpenter
>
> On Wed, Nov 06, 2013 at 07:13:43PM +0300, Dan Carpenter wrote:
>> Hello Philipp Zabel,
>>
>> This is a semi-automatic email about new static checker warnings.
>>
>> The patch 5677e3b04d3b: "[media] coda: update CODA7541 to firmware
>> 1.4.50" from Jun 21, 2013, leads to the following Smatch complaint:
>>
>> drivers/media/platform/coda.c:1530 coda_alloc_framebuffers()
>>        error: we previously assumed 'ctx->codec' could be null (see line 1521)
>>
>> drivers/media/platform/coda.c
>>   1520
>>   1521                if (ctx->codec && ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
>>                     ^^^^^^^^^^
>> Patch introduces a new NULL check.
>>
>>   1522                        height = round_up(height, 16);
>>   1523                ysize = round_up(q_data->width, 8) * height;
>>   1524
>>   1525                /* Allocate frame buffers */
>>   1526                for (i = 0; i < ctx->num_internal_frames; i++) {
>>   1527                        size_t size;
>>   1528
>>   1529                        size = q_data->sizeimage;
>>   1530                        if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
>>                             ^^^^^^^^^^^^^^^^^^^^^^
>> Patch introduces a new unchecked dereference.
>>
>>   1531                            dev->devtype->product != CODA_DX6)
>>   1532                                ctx->internal_frames[i].size += ysize/4;

Would the fix below address this issue?

--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1518,7 +1518,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
        int ret;
        int i;

-       if (ctx->codec && ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
+       if (!ctx->codec)
+               return -EINVAL;
+
+       if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
                height = round_up(height, 16);
        ysize = round_up(q_data->width, 8) * height;
