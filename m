Return-path: <linux-media-owner@vger.kernel.org>
Received: from dynamic.0.6.79d1f80.14cc20ac3a53.cust.bredband2.com ([89.233.230.99]:50924
	"EHLO bigcity.berto.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755454AbcASQkB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 11:40:01 -0500
Date: Tue, 19 Jan 2016 17:10:47 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk
Subject: Re: [RESEND PATCH] media: adv7180: increase delay after reset to 5ms
Message-ID: <20160119161047.GA22815@bigcity.dyn.berto.se>
References: <1453205956-9103-1-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453205956-9103-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

This fixes the problems I have seen on Koelsch.

* Ulrich Hecht <ulrich.hecht+renesas@gmail.com> [2016-01-19 13:19:16 +0100]:

> Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
> Lager board about 50% of the time.  This patch resolves the issue by
> increasing the minimum delay after reset from 2 ms to 5 ms, following the
> recommendation in the ADV7180 datasheet:
>
> "Executing a software reset takes approximately 2 ms. However, it is
> recommended to wait 5 ms before any further I2C writes are performed."
>
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
