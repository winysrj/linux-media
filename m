Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B781C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 18:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B8B218D3
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 18:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="k5Ir767H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbeLTS7M (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 13:59:12 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:9329 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLTS7M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 13:59:12 -0500
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 9EF241244F7;
        Thu, 20 Dec 2018 18:59:10 +0000 (UTC)
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (unknown [100.96.19.74])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 53F8612401B;
        Thu, 20 Dec 2018 18:59:10 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@b-rad.cc
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Thu, 20 Dec 2018 18:59:10 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@b-rad.cc
X-MailChannels-Auth-Id: dreamhost
X-Continue-Lonely: 1fa194ec7653a6f4_1545332350472_1836365320
X-MC-Loop-Signature: 1545332350472:3289245331
X-MC-Ingress-Time: 1545332350471
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTP id EE53580A59;
        Thu, 20 Dec 2018 10:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=
        subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=
        nextdimension.cc; bh=W9WS8wz8d5rnSrG1tajR6q+kwYg=; b=k5Ir767Ho8e
        R8ruwKvcB5V1TL2GZ9A+qXodsUGXCcUB8goz4qRguXEpwSY0PjNpYRtPcf1FOwWE
        6xIY8fX8H5ECO4yRo2Y+EYTTlXOKqV8vGV7Z0K6PxTUfbu2CcwQhxOTtCKhLFWKT
        FUQ5Y9djYzjpOFSmpdrQzVwNkPWiuICw=
Received: from [192.168.0.21] (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@b-rad.cc)
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTPSA id 8C80180A67;
        Thu, 20 Dec 2018 10:59:09 -0800 (PST)
Subject: Re: [PATCH 1/5] si2168: add frequency data to frontend info
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1545332084-12661-1-git-send-email-brad@nextdimension.cc>
X-DH-BACKEND: pdx1-sub0-mail-a23
From:   Brad Love <brad@nextdimension.cc>
Openpgp: preference=signencrypt
Autocrypt: addr=brad@nextdimension.cc; prefer-encrypt=mutual; keydata=
 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
Message-ID: <9d59deb2-e21d-ff15-0ac5-358f0aacd836@nextdimension.cc>
Date:   Thu, 20 Dec 2018 12:59:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1545332084-12661-1-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejfedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplgduledvrdduieekrddtrddvudgnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Ooops...ignore the series bit...this is solo.


On 20/12/2018 12.54, Brad Love wrote:
> Minimum, maximum, and stepsize taken from Silicon Labs reference.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  drivers/media/dvb-frontends/si2168.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 324493e..17301c6 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -683,8 +683,11 @@ static const struct dvb_frontend_ops si2168_ops = {
>  	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
>  	.info = {
>  		.name = "Silicon Labs Si2168",
> -		.symbol_rate_min = 1000000,
> -		.symbol_rate_max = 7200000,
> +		.frequency_min_hz      =  48 * MHz,
> +		.frequency_max_hz      = 870 * MHz,
> +		.frequency_stepsize_hz = 62500,
> +		.symbol_rate_min       = 1000000,
> +		.symbol_rate_max       = 7200000,
>  		.caps =	FE_CAN_FEC_1_2 |
>  			FE_CAN_FEC_2_3 |
>  			FE_CAN_FEC_3_4 |
