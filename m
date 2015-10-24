Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:31225 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbJXPfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2015 11:35:43 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
Date: Sat, 24 Oct 2015 11:59:32 +0200
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <87io5wwahg.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Fix the error path where the video buffer wasn't allocated nor
> mapped. In this case, in the driver free path don't try to unmap memory
> which was not mapped in the first place.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
> Since v3: take into account the 2 paths possibilities to free_buffer()
Okay Guennadi, it's been enough time.
Could you you have another look at this serie please ?

Cheers.

--
Robert
