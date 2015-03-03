Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37982 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755939AbbCCKML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 05:12:11 -0500
Message-ID: <54F588EA.7070502@xs4all.nl>
Date: Tue, 03 Mar 2015 11:11:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] media: adv7604: improve usage of gpiod API
References: <1425279644-25873-1-git-send-email-u.kleine-koenig@pengutronix.de> <54F5851E.70906@xs4all.nl> <54F585FA.70701@xs4all.nl> <20150303100927.GM7865@pengutronix.de>
In-Reply-To: <20150303100927.GM7865@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2015 11:09 AM, Uwe Kleine-König wrote:
> Hello Hans,
> 
> On Tue, Mar 03, 2015 at 10:59:22AM +0100, Hans Verkuil wrote:
>> Never mind those comments, after checking what devm_gpiod_get_index_optional
>> does it's clear that this patch is correct.
>>
>> Sorry about the noise.
> No problem. Is this an Ack then? Who picks up this patch?

I do, I've just accepted it and will post a pull request for v4.1 in a minute.

Regards,

	Hans
