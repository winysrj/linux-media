Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:29150 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbbGLOi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 10:38:29 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v2 1/4] media: pxa_camera: fix the buffer free path
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
	<1436120872-24484-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1507121557210.32193@axis700.grange>
Date: Sun, 12 Jul 2015 16:35:42 +0200
In-Reply-To: <Pine.LNX.4.64.1507121557210.32193@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 12 Jul 2015 15:58:06 +0200 (CEST)")
Message-ID: <87380tl9z5.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
>
> On Sun, 5 Jul 2015, Robert Jarzmik wrote:
>
>> From: Robert Jarzmik <robert.jarzmik@intel.com>
>> 
>> Fix the error path where the video buffer wasn't allocated nor
>> mapped. In this case, in the driver free path don't try to unmap memory
>> which was not mapped in the first place.
>
> Have I missed your reply to my comments to v1 of this patch? This one 
> seems to be its exact copy?
Yeah, that's because I don't have any ... reply from you on v1.
At least I don't remember it and in [1] I don't see it.

Cheers.

--
Robert

[1] http://www.spinics.net/lists/linux-media/msg88021.html
