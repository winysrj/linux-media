Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376B5C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1A5620859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 17:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="ZrwN2gCu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfAIRhB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 12:37:01 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:45141 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbfAIRhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 12:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xzkuCnTe8ZPW9xM1sMiVTbcdj/8wG7lc9aZ2cBn6QB4=; b=ZrwN2gCuzQN7RHU5DaetVwvFFw
        y6P4cyOS5uy2SXwMz+IuyfBeY0aLfGoONcO7yBJN2eYD+FsXCFBqm2UyLSpxIJA5k0sH6t3B8ySph
        GNgJzN0MyKCAyzsHKoD+d08QpOT2VJNf5NYV2VWiXQt2s9MCHoMvlwWkfyIbuLUkD1gU3/xHCnBB/
        XjPRPQc+3YpBkPsonj5qs/BLh75efLNhLiOWlzTBSdQqimCUJoVJfCDBRfse+fibQzE2OmWAuilf/
        KdoKCLkYGzkiWPaGWuVp+w2aTN2XHpPvP/PGIHZkVcIdL235mrjTe5nB94xcJUkT/86O7rEHKjn2C
        oQ3D38Bw==;
Received: from 87-92-92-105.bb.dnainternet.fi ([87.92.92.105] helo=localhost.localdomain)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <crope@iki.fi>)
        id 1ghHmj-0003wk-Ie; Wed, 09 Jan 2019 19:36:57 +0200
Subject: Re: [PATCH 1/4] si2157: add detection of si2177 tuner
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1545343031-20935-1-git-send-email-brad@nextdimension.cc>
 <1545343031-20935-2-git-send-email-brad@nextdimension.cc>
From:   Antti Palosaari <crope@iki.fi>
Message-ID: <7e3c07bd-b9be-d9fc-8d52-577825bbc315@iki.fi>
Date:   Wed, 9 Jan 2019 19:36:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1545343031-20935-2-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 87.92.92.105
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/20/18 11:57 PM, Brad Love wrote:
> Works in ATSC and QAM as is, DVB is completely untested.
> 
> Firmware required.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>   drivers/media/tuners/si2157.c      | 6 ++++++
>   drivers/media/tuners/si2157_priv.h | 3 ++-


>   #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
>   #define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
> -
> +#define SI2157_A30_FIRMWARE "dvb-tuner-si2157-a30-05.fw"

Why you added 05 to that file name? I added that spare number for cases 
you have to replace firmware to another for some reason thus by default 
case it should be 01.

regards
Antti

-- 
http://palosaari.fi/
