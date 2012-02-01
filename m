Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53015 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2BAJDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 04:03:53 -0500
Received: by qcqw6 with SMTP id w6so526318qcq.19
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2012 01:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F28FF5E.30407@samsung.com>
References: <1328072989-12498-1-git-send-email-sachin.kamat@linaro.org>
	<4F28FF5E.30407@samsung.com>
Date: Wed, 1 Feb 2012 14:33:52 +0530
Message-ID: <CAK9yfHw=NjZUHP-6uHcxgUjaisjS=Y21Zqxab7k98mQL3ZK0_A@mail.gmail.com>
Subject: Re: [PATCH v3] [media] s5p-g2d: Add HFLIP and VFLIP support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,



On 1 February 2012 14:31, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 02/01/2012 06:09 AM, Sachin Kamat wrote:
>> @@ -200,11 +206,7 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>>  {
>>       struct g2d_dev *dev = ctx->dev;
>>
>> -     v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
>> -     if (ctx->ctrl_handler.error) {
>> -             v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
>> -             return ctx->ctrl_handler.error;
>> -     }
>> +     v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
>>
>>       v4l2_ctrl_new_std_menu(
>>               &ctx->ctrl_handler,
>> @@ -214,11 +216,20 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>>               ~((1 << V4L2_COLORFX_NONE) | (1 << V4L2_COLORFX_NEGATIVE)),
>>               V4L2_COLORFX_NONE);
>>
>> +
>> +     ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
>> +                                             V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +
>> +     ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
>> +                                             V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +
>>       if (ctx->ctrl_handler.error) {
>>               v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
>
> It's not only v4l2_ctrl_handler_init() that might have failed at this point,
> therefore you need to also call v4l2_ctrl_handler_free() here. There is an
> example of that in Documentation/v4l2-controls.txt.

Thank you for pointing it out.

>
>>               return ctx->ctrl_handler.error;
>>       }
>
> --
>
> Thanks,
> Sylwester



-- 
With warm regards,
Sachin
