Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:32115 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbGLOfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 10:35:20 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v2 3/4] media: pxa_camera: trivial move of dma irq functions
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
	<1436120872-24484-4-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1507121605040.32193@axis700.grange>
Date: Sun, 12 Jul 2015 16:32:27 +0200
In-Reply-To: <Pine.LNX.4.64.1507121605040.32193@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 12 Jul 2015 16:06:23 +0200 (CEST)")
Message-ID: <87a8v1la4k.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
>> index c0c0f0f..1ab4f9d 100644
>> --- a/drivers/media/platform/soc_camera/pxa_camera.c
>> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
>> @@ -311,6 +311,28 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
>>  
>>  	BUG_ON(size != 0);
>>  	return i + 1;
>> +static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
>> +			       enum pxa_camera_active_dma act_dma);
>
> Yes, functions look ok now as the sense - they are just moved up with no 
> modifications, but the patch itself looks as broken to me as it originally 
> was... Please, look 2 lines up - where you add your lines.
Indeed.
I don't know how that could happen. I would have sworn they were in the correct
place, then I rebased / solved conflicts, and ... messed up.

That would be for the v3, and I'll inspect the mails before sending.

Cheers.

--
Robert
