Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FCAC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B40E82087E
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="LvTiK8nZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfAHJSH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 04:18:07 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:42374 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfAHJSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 04:18:06 -0500
Received: from mailhost.synopsys.com (mailhost2.synopsys.com [10.13.184.66])
        by smtprelay.synopsys.com (Postfix) with ESMTP id 4976124E128F;
        Tue,  8 Jan 2019 01:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1546939086; bh=xQjjco8BxkFuJITUPzAYcNAQ8+uqF6hDqCdgteCwABE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From;
        b=LvTiK8nZEurFicqRMwqJNoBFMHy8I15G20DwBrd66NZLdukmdbM1tWWU8HbXMDh+d
         wST2i/vnNSrs+LjH7URl+MdRwEKT1VDqenF3Vmn1sRchIJQ9cVNykgVPq879D3Mwts
         KkoN/nYSrhKlW37F1xzd1nGN3Hj5ODeFo0a4QSVRIa5fXCkpN8DVY5fXHF3F/Y8yJq
         h1rCFdStkj2/y6keRVpczAgU5SqJuycFtT5yrO0USd4ALJ41FUE+CsSYvmK65ko7e4
         yMhquefUUCB+ScJv2yHFlF8bZGSOxBD+BUNbC1i2hnwwzzJPFX7eqWToQ7ypBBU7pI
         3S6GQwaid9WEg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        by mailhost.synopsys.com (Postfix) with ESMTP id F35073987;
        Tue,  8 Jan 2019 01:18:02 -0800 (PST)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 8 Jan 2019 01:18:02 -0800
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 DE02WEHTCA.internal.synopsys.com (10.225.19.92) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 8 Jan 2019 10:18:01 +0100
Received: from [10.107.19.13] (10.107.19.13) by
 DE02WEHTCB.internal.synopsys.com (10.225.19.80) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 8 Jan 2019 10:18:01 +0100
Subject: Re: [V3, 2/4] media: platform: dwc: Add DW MIPI DPHY Rx platform
To:     Sakari Ailus <sakari.ailus@iki.fi>,
        Luis Oliveira <luis.oliveira@synopsys.com>
CC:     <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Keiichi Watanabe" <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-3-git-send-email-lolivei@synopsys.com>
 <20190107115828.4tegmsbkoiqh7y5g@valkosipuli.retiisi.org.uk>
From:   Luis de Oliveira <luis.oliveira@synopsys.com>
Message-ID: <a0aef8a5-9430-6503-6d1b-9ed912344d87@synopsys.com>
Date:   Tue, 8 Jan 2019 09:17:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20190107115828.4tegmsbkoiqh7y5g@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.107.19.13]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On 07-Jan-19 11:58, Sakari Ailus wrote:
> Hi Luis,
> 
> On Fri, Oct 19, 2018 at 02:52:24PM +0200, Luis Oliveira wrote:
>> Add of Synopsys MIPI D-PHY in RX mode support.
>> Separated in the implementation are platform dependent probing functions.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
> 
> Maxime has a patchset adding D-PHY parameters to the PHY API. I think they
> could be relevant for this one as well:
> 

Maxime was kind to send me the patchset for me to use.
I was on a different project for the last weeks but I will get back to this and
prepare a V4 with the new PHY API parameters asap.

Thank you,
Luis
