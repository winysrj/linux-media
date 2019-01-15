Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29061C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F337D20656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 09:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfAOJ10 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:27:26 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40948 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727865AbfAOJ10 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 04:27:26 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 01B35634C85;
        Tue, 15 Jan 2019 11:25:44 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gjKyd-0004L8-Br; Tue, 15 Jan 2019 11:25:43 +0200
Date:   Tue, 15 Jan 2019 11:25:43 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] media: ov7740: get rid of extra ifdefs
Message-ID: <20190115092543.24aeb2fvzjwev7bq@valkosipuli.retiisi.org.uk>
References: <20181128171918.160643-1-lkundrak@v3.sk>
 <20181128171918.160643-3-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128171918.160643-3-lkundrak@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Nov 28, 2018 at 06:19:14PM +0100, Lubomir Rintel wrote:
> Stubbed v4l2_subdev_get_try_format() will return a correct error when
> configured without CONFIG_VIDEO_V4L2_SUBDEV_API.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

I'm marking these as rejected for now; let's see if we'll get rid of the
said Kconfig options.

Thanks.

-- 
Sakari Ailus
