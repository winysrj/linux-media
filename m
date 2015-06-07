Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:48144 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbFGTTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2015 15:19:32 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 4/4] media: pxa_camera: conversion to dmaengine
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
	<1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1506041318210.15142@axis700.grange>
Date: Sun, 07 Jun 2015 21:17:49 +0200
In-Reply-To: <Pine.LNX.4.64.1506041318210.15142@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu, 4 Jun 2015 13:20:33 +0200 (CEST)")
Message-ID: <87oakr49b6.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> Please, correct me if I am wrong, but doesn't this patch have to be 
> updates? Elgl looking at this:
>> +	for (i = 0; i < 3 && buf->descs[i]; i++) {
>> +		async_tx_ack(buf->descs[i]);
>> +		dmaengine_tx_release(buf->descs[i]);
>
> hasn't the addition of your proposed dmaengine_tx_release() API been 
> rejected? I'll wait for an updated version then.
Yeah, correct.
The updated version will just remove the dmaengine_tx_release() call, the
async_tx_ack() is sufficient.

I hope this won't stop the review, it's the only change I have so far in my tree
on top of the submission.

Cheers.

-- 
Robert
