Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35538 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbHSF4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 01:56:04 -0400
Received: by oiew67 with SMTP id w67so95461057oie.2
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2015 22:56:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439886670-12322-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1439886670-12322-2-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 19 Aug 2015 07:56:02 +0200
Message-ID: <CACRpkdbxJJ66JBsFdzxhs5eNSHeuGELk44dHbm_Lz4P-96iHWQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] tc358743: make reset gpio optional
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
> specified in the device tree binding documentation that the reset gpio
> is optional. Make the implementation match accordingly.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
