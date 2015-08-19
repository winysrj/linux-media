Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbbHSIbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 04:31:49 -0400
Message-ID: <1439973105.3160.0.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] [media] tc358743: set direction of reset gpio using
 devm_gpiod_get
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Wed, 19 Aug 2015 10:31:45 +0200
In-Reply-To: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 18.08.2015, 10:31 +0200 schrieb Uwe Kleine-König:
> Commit 256148246852 ("[media] tc358743: support probe from device tree")
> failed to explicitly set the direction of the reset gpio. Use the
> optional flag of devm_gpiod_get to make up leeway.
> 
> This is also necessary because the flag parameter will become mandatory
> soon.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

