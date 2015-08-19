Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36715 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbHSFzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 01:55:07 -0400
Received: by oiev193 with SMTP id v193so113714008oie.3
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2015 22:55:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 19 Aug 2015 07:55:06 +0200
Message-ID: <CACRpkdanGtMN0Bs4Q+k2buLUsn_ryAVsDXLVkMrumhKJUXNjpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] tc358743: set direction of reset gpio using devm_gpiod_get
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Mats Randgaard <matrandg@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2015 at 10:31 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:

> Commit 256148246852 ("[media] tc358743: support probe from device tree")
> failed to explicitly set the direction of the reset gpio. Use the
> optional flag of devm_gpiod_get to make up leeway.
>
> This is also necessary because the flag parameter will become mandatory
> soon.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
