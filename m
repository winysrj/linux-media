Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39552 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIXM2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 08:28:02 -0400
Received: by mail-pa0-f50.google.com with SMTP id lj1so170301pab.9
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 05:28:01 -0700 (PDT)
Message-ID: <5422B8CD.8050302@gmail.com>
Date: Wed, 24 Sep 2014 21:27:57 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] qm1d1c0042: fix compilation on 32 bits
References: <aee9cf18e96ed8384a04bd3eda69c7b9e888ee5b.1411522264.git.mchehab@osg.samsung.com>
In-Reply-To: <aee9cf18e96ed8384a04bd3eda69c7b9e888ee5b.1411522264.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -	b = (((s64) freq) << 20) / state->cfg.xtal_freq - (((s64) a) << 20);
> +	b = (s32)div64_s64(((s64) freq) << 20,
> +			   state->cfg.xtal_freq - (((s64) a) << 20));
> +

I'm afraid it should be like the following.
> +	b = (s32)(div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
> +			- (((s64) a) << 20));

regads,
akihiro

