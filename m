Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49181 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbbHSIcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 04:32:00 -0400
Message-ID: <1439973119.3160.1.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] [media] tc358743: make reset gpio optional
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Wed, 19 Aug 2015 10:31:59 +0200
In-Reply-To: <1439886670-12322-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1439886670-12322-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1439886670-12322-2-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 18.08.2015, 10:31 +0200 schrieb Uwe Kleine-König:
> Commit 256148246852 ("[media] tc358743: support probe from device tree")
> specified in the device tree binding documentation that the reset gpio
> is optional. Make the implementation match accordingly.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

