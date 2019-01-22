Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C860C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB04920855
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548172276;
	bh=A7+dDwj4KALNwVh92sH1oBhhC+L4DfC24sG0rDT8G40=;
	h=Subject:To:References:From:Date:In-Reply-To:List-ID:From;
	b=aUGmz5BaKsrWsTXQwnMhyJmJPxcDhJUuI167V6R01qavHd9tJoEQcYCsyMtQdGnt0
	 BcTgBQXn4M4h+PNq0xpsXtL8M8lAWDJUIReOt8Ax5M30441KcIK2caP3JpIET2kxcw
	 0WobWfCYE8whw9KrAzysf3RATYWVkl2Kc0aPehuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfAVPvQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfAVPvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:51:16 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78EC520854;
        Tue, 22 Jan 2019 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548172275;
        bh=A7+dDwj4KALNwVh92sH1oBhhC+L4DfC24sG0rDT8G40=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=rPf7t+9oCSxtlpGenoL7jiTDwlCZeu96f/z7iPK8pvyf4bGfEslg15tzOfW593evh
         NIAVAA4Tgf1K9xf2mt0NNcg54IXt8HAnmWdjUDuL9O68FHbgoko3MGZV6cetLn72y3
         HGdBE9tIi7VpKRYhTTolT7Yn1zeDXsHXiocAyNTI=
Subject: Re: [PATCH 1/2] selftests: Use lirc.h from kernel tree, not from
 system
To:     Sean Young <sean@mess.org>, Patrick Lerda <patrick9876@free.fr>,
        linux-media@vger.kernel.org, shuah <shuah@kernel.org>
References: <cover.1547738495.git.sean@mess.org>
 <dad2fab452d98aaadea210807f9e0545a7814b32.1547738495.git.sean@mess.org>
From:   shuah <shuah@kernel.org>
Message-ID: <46b12148-23d5-94a6-3c63-606636300bf4@kernel.org>
Date:   Tue, 22 Jan 2019 08:51:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <dad2fab452d98aaadea210807f9e0545a7814b32.1547738495.git.sean@mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/17/19 8:29 AM, Sean Young wrote:
> When the system lirc.h is older than v4.16, you will get errors like:
> 
> ir_loopback.c:32:16: error: field ‘proto’ has incomplete type
>    enum rc_proto proto;
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>   tools/testing/selftests/ir/Makefile | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/ir/Makefile b/tools/testing/selftests/ir/Makefile
> index f4ba8eb84b95..ad06489c22a5 100644
> --- a/tools/testing/selftests/ir/Makefile
> +++ b/tools/testing/selftests/ir/Makefile
> @@ -1,5 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0
>   TEST_PROGS := ir_loopback.sh
>   TEST_GEN_PROGS_EXTENDED := ir_loopback
> +APIDIR := ../../../include/uapi
> +CFLAGS += -Wall -O2 -I$(APIDIR)
>   
>   include ../lib.mk
> 

Thanks for the fix. I can take this through kselftest tree if
there are no dependencies on any media patches. It looks that
way, just confirming. It will be very likely for rc5.

thanks,
-- Shuah
