Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49516 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbCCKJh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 05:09:37 -0500
Date: Tue, 3 Mar 2015 11:09:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] media: adv7604: improve usage of gpiod API
Message-ID: <20150303100927.GM7865@pengutronix.de>
References: <1425279644-25873-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <54F5851E.70906@xs4all.nl>
 <54F585FA.70701@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54F585FA.70701@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Tue, Mar 03, 2015 at 10:59:22AM +0100, Hans Verkuil wrote:
> Never mind those comments, after checking what devm_gpiod_get_index_optional
> does it's clear that this patch is correct.
> 
> Sorry about the noise.
No problem. Is this an Ack then? Who picks up this patch?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
