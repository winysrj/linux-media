Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:16813 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbFTVuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2015 17:50:25 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 3/4] media: pxa_camera: trivial move of dma irq functions
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
	<1426980085-12281-4-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1506201503550.31977@axis700.grange>
Date: Sat, 20 Jun 2015 23:48:15 +0200
In-Reply-To: <Pine.LNX.4.64.1506201503550.31977@axis700.grange> (Guennadi
	Liakhovetski's message of "Sat, 20 Jun 2015 15:29:00 +0200 (CEST)")
Message-ID: <87y4je831c.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> +static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
>> +			       enum pxa_camera_active_dma act_dma);
>> +
>> +static void pxa_camera_dma_irq_y(void *data)
>
> Wait, how is this patch trivial? You change pxa_camera_dma_irq_?() 
> prototypes, which are used as PXA DMA callbacks. Does this mean, that 
> either before or after this patch compilation is broken?

Jeez you're right.
So I can either fold that with patch 4, or try to rework it somehow ...

Cheers.

--
Robert
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
