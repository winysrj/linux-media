Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5C6C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 12:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E032192B
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 12:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394679AbfBOMRA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:17:00 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38109 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394664AbfBOMRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 07:17:00 -0500
Received: from [IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc] ([IPv6:2001:420:44c1:2579:e58e:188a:dca7:31dc])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ucQIgJC5h4HFnucQMgt0Mz; Fri, 15 Feb 2019 13:16:58 +0100
Subject: Re: [PATCH] media: tda1997: fix get-edid
To:     Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org
References: <20190205162336.13490-1-tharvey@gateworks.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <4ec799e2-a80c-be10-4a80-b6f268f1b842@xs4all.nl>
Date:   Fri, 15 Feb 2019 13:16:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190205162336.13490-1-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFqrgWFlssVoZCEAm6m+nXzz5hl/KDK/vUKqylqOfDFL7On6TuFyc+iDAKWEkv2Pev3rmnQxlhQExQgl74l/gjp2dyh4loPD3SmLe9TdzC0rwPOvMsbR
 j4b2n41Z8Wvr04gKVS6VjNeSJDG239XIfx6tA6KQn9QiCNyaTDE/GOUjEfRwBA7fTdpP3SrhysMYcRJg1iJewwKaGB9rizP8g4a8G9sZP10Mneq9SQZAeLsU
 +7gSXI+WDHCBYpMppmIGRoHj4WWvWAY5tcSA3Yt5OLphLetuGoo2C8d52vbADdBrU+IMmpTrBPu1tozY9HrlvjdeVact1u+rFZgz33X5Ers=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On 2/5/19 5:23 PM, Tim Harvey wrote:

I merged this patch and added my own commit log message.

Just remember to provide it in the future...

Regards,

	Hans

> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  drivers/media/i2c/tda1997x.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
> index c4c2a6134e1e..73451e9bbc41 100644
> --- a/drivers/media/i2c/tda1997x.c
> +++ b/drivers/media/i2c/tda1997x.c
> @@ -1884,6 +1884,10 @@ static int tda1997x_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>  	for (i = 0; i < 128; i++)
>  		io_write(sd, REG_EDID_IN_BYTE128 + i, edid->edid[i+128]);
>  
> +	/* store state */
> +	memcpy(state->edid.edid, edid->edid, 256);
> +	state->edid.blocks = edid->blocks;
> +
>  	tda1997x_enable_edid(sd);
>  
>  	return 0;
> 

