Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D603DC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 17:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A943E2177E
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfCLRQV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 13:16:21 -0400
Received: from shell.v3.sk ([90.176.6.54]:52790 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbfCLRQU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 13:16:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 3EA7B102E57;
        Tue, 12 Mar 2019 18:16:17 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id fC59OIptrBHw; Tue, 12 Mar 2019 18:16:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id D2583102E58;
        Tue, 12 Mar 2019 18:16:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l_opNcAMdZl1; Tue, 12 Mar 2019 18:16:10 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 2B40A102E57;
        Tue, 12 Mar 2019 18:16:10 +0100 (CET)
Message-ID: <559a9073a3d42de6737f75a1fb6a6e53451a6a28.camel@v3.sk>
Subject: Re: [PATCH 0/2] media: ov7670: fix regressions caused by "hook
 s_power onto v4l2 core"
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 12 Mar 2019 18:16:08 +0100
In-Reply-To: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-03-12 at 00:36 +0900, Akinobu Mita wrote:
> This patchset fixes the problems introduced by recent change to ov7670.
> 
> Akinobu Mita (2):
>   media: ov7670: restore default settings after power-up
>   media: ov7670: don't access registers when the device is powered off
> 
>  drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> Cc: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>

For the both patches in the set:

Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
Tested-by: Lubomir Rintel <lkundrak@v3.sk>

Thank you,
Lubo

