Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8EFBC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A593420870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A593420870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=selasky.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbeLMMrC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:47:02 -0500
Received: from turbocat.net ([88.99.82.50]:49650 "EHLO mail.turbocat.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbeLMMrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:47:01 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2018 07:47:01 EST
Received: from hps2016.home.selasky.org (unknown [178.17.145.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.turbocat.net (Postfix) with ESMTPSA id 71570260243;
        Thu, 13 Dec 2018 13:39:07 +0100 (CET)
To:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
From:   Hans Petter Selasky <hps@selasky.org>
Subject: strscpy() vs strlcpy() and WARN_ONCE()
Message-ID: <506c194b-1dcf-b616-4b33-5fed3394a3a0@selasky.org>
Date:   Thu, 13 Dec 2018 13:37:14 +0100
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:60.0) Gecko/20100101
 Thunderbird/60.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

> commit c0decac19da3906d9b66291e57b7759489e1170f
> Author: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Date:   Mon Sep 10 08:19:14 2018 -0400
> 
>     media: use strscpy() instead of strlcpy()
>     
>     The implementation of strscpy() is more robust and safer.
>     
>     That's now the recommended way to copy NUL terminated strings.
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>     Reviewed-by: Kees Cook <keescook@chromium.org>
>     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Hi Mauro,

The following piece of the commit above I believe is wrong:

>         if (descr)
> -               WARN_ON(strlcpy(fmt->description, descr, sz) >= sz);
> +               WARN_ON(strscpy(fmt->description, descr, sz) >= sz);
>         fmt->flags = flags;

It should be:
		WARN_ON(strscpy(fmt->description, descr, sz) < 0);

I don't have time to make a full patch for this so please handle this 
issue for me. Thank you!

--HPS
