Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ED2C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2AE21872
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 10:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549015561;
	bh=PfAxe86KBEXd4QVKxanBUI89fRcYk+wiSs1YaJfak04=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=jzZ7/NRSUp9Uz8wQEA10uYuJJ9biy/byjd586CBPQcUWWGeK4X4Ys2OjH/b0sDwX9
	 NzdhTmUBvVhEg3osPx6OUWyuzU8TMsfNirw1dlnDQNdFPiYQS7AXTCBOv2tz/Kt0jh
	 HbqbfamdtLpqyJ/r6eF3mmxrL3QleH2Ix/hlzYMI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfBAKF4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:05:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfBAKF4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 05:05:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BqaS2Bn4ka/3mi6dGCWuT0gR70TRiaxFOW/ior3vlsU=; b=f8BvV0p4XU5v5XOXj1zXMwS+K
        UMb02S8o7nsf4AyYAnQR5rnmu5bf4mxwJGLwwUxsJoeFeX5MrTvVAGzFH6yCZv0FrcnSXpZew8gwm
        MgkNm7mdvrKVWUiMwfTyLpbhapt1Bavrn6wpUOkOG8h7LVOO8e3Az+hbqGW67MgpWYH8gm0uknupB
        ajAwPNJ+ODnP06uDjslt6yalMUpnHaY7C04MSkWtQcFAYuE6SLEfaTl/byEb/FnP7izH4iNWzoUJm
        cjMQiYBSpaFmss//4ocx7OfY617shUA0aoda98rJhvOuco3YaVD16T/8KsD3BaVU1EADg4ildG0H+
        1t+aEdm/g==;
Received: from 179.187.106.61.dynamic.adsl.gvt.net.br ([179.187.106.61] helo=silica.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gpVhq-0001P8-Lx; Fri, 01 Feb 2019 10:05:55 +0000
Date:   Fri, 1 Feb 2019 08:05:50 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Javier Serrano Polo <javier@jasp.net>
Cc:     javier--ZDpp3NWAUi4iojWgtC3QwkB5th4T5J@jasp.net,
        linux-media@vger.kernel.org
Subject: Re: ZBar: Move development to GitHub
Message-ID: <20190201080550.7f06058a@silica.lan>
In-Reply-To: <1548993218.1967.23.camel@jasp.net>
References: <1548993218.1967.23.camel@jasp.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Javier,

Em Fri, 01 Feb 2019 04:53:38 +0100
Javier Serrano Polo <javier@jasp.net> escreveu:

> Dear list,
> 
> I maintain a fork of ZBar. Following a reply from James Hilliard and
> according to Wikipedia edition from Mauro Carvalho Chehab, this team
> stands as the new upstream.
> 
> Please consider to continue development on GitHub, since the
> communication system is more friendly and there are continuous
> integration builds. If you agree, I will create a GitHub organization
> and import your repository along with my patches.

I do maintain a ZBar git tree at GitHub - although I have a copy also at 
linuxtv.org. I keep both in sync.

The GitHub's tree is at:

	https://github.com/mchehab/zbar

> I await your answer.
> Thank you.


Cheers,
Mauro
