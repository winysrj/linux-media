Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD00C43612
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 16:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 009D120870
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 16:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="cmkFBLhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfALQv1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 11:51:27 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:37436 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfALQv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 11:51:27 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D1E2513;
        Sat, 12 Jan 2019 17:51:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547311885;
        bh=nwInfb6NPAJbdJ8RJrflTRX9RwLvJptwayrnP32sKVc=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cmkFBLhPj51ung6XWGINPCJiemN6/95gdWA+vyb64JAojh/gvNvFeFMVZuU0pYeJV
         V2enUv/HfQFa5y8kpE4uZhjnYO9SPwqhb3iUh6mdcCbKXx3yXuJk/8z6U0W+S+p0/3
         3nIBpB5iQYx16vHpRLI20Sw7BLUCsDL4YY+zbFWY=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Remove PAGE_WAIT
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
 <38687704.IXnQZ8UTlm@avalon>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <3ff66246-d536-3d38-1e77-ce2379b967d7@ideasonboard.com>
Date:   Sat, 12 Jan 2019 16:51:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <38687704.IXnQZ8UTlm@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 11/01/2019 20:23, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Friday, 11 January 2019 19:41:41 EET Kieran Bingham wrote:
>> The ADV748X_PAGE_WAIT is a fake page to insert arbitrary delays in the
>> register tables.
>>
>> Its only usage was removed, so we can remove the handling and simplify
>> the code.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/i2c/adv748x/adv748x-core.c | 17 ++++++-----------
>>  drivers/media/i2c/adv748x/adv748x.h      |  1 -
>>  2 files changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
>> b/drivers/media/i2c/adv748x/adv748x-core.c index 252bdb28b18b..8199e0b20790
>> 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -219,18 +219,13 @@ static int adv748x_write_regs(struct adv748x_state
>> *state, int ret;
>>
>>  	while (regs->page != ADV748X_PAGE_EOR) {
> 
> While at it you could write this as
> 
> 	for (; regs->page != ADV748X_PAGE_EOR; ++regs)
> 
> and remove the regs++ below.

ah yes - good idea. I'll update this.

--
Kieran


> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> -		if (regs->page == ADV748X_PAGE_WAIT) {
>> -			msleep(regs->value);
>> -		} else {
>> -			ret = adv748x_write(state, regs->page, regs->reg,
>> -				      regs->value);
>> -			if (ret < 0) {
>> -				adv_err(state,
>> -					"Error regs page: 0x%02x reg: 0x%02x\n",
>> -					regs->page, regs->reg);
>> -				return ret;
>> -			}
>> +		ret = adv748x_write(state, regs->page, regs->reg, regs->value);
>> +		if (ret < 0) {
>> +			adv_err(state, "Error regs page: 0x%02x reg: 0x%02x\n",
>> +				regs->page, regs->reg);
>> +			return ret;
>>  		}
>> +
>>  		regs++;
>>  	}
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x.h
>> b/drivers/media/i2c/adv748x/adv748x.h index 2f8d751cfbb0..5042f9e94aee
>> 100644
>> --- a/drivers/media/i2c/adv748x/adv748x.h
>> +++ b/drivers/media/i2c/adv748x/adv748x.h
>> @@ -39,7 +39,6 @@ enum adv748x_page {
>>  	ADV748X_PAGE_MAX,
>>
>>  	/* Fake pages for register sequences */
>> -	ADV748X_PAGE_WAIT,		/* Wait x msec */
>>  	ADV748X_PAGE_EOR,		/* End Mark */
>>  };
> 

