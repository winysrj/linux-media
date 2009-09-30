Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49823 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZI3IAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 04:00:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [PATCH] media/video:  adding __init/__exit macros to various drivers
Date: Wed, 30 Sep 2009 10:02:35 +0200
Cc: Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200909290219.01623.PeterHuewe@gmx.de>
In-Reply-To: <200909290219.01623.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909301002.35202.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 29 September 2009 02:19:00 Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init/__exit macros to the module_init/
> module_exit functions of the following drivers in media video:
>     drivers/media/video/ivtv/ivtv-driver.c
>     drivers/media/video/cx18/cx18-driver.c
>     drivers/media/video/davinci/dm355_ccdc.c
>     drivers/media/video/davinci/dm644x_ccdc.c
>     drivers/media/video/saa7164/saa7164-core.c
>     drivers/media/video/saa7134/saa7134-core.c
>     drivers/media/video/cx23885/cx23885-core.c

For drivers/media/video/davinci/dm355_ccdc.c and 
drivers/media/video/davinci/dm644x_ccdc.c,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Please have a look at the small patch and either pull it through
> your tree, or please ack' it so Jiri can pull it through the trivial tree.
> 
> linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

-- 
Laurent Pinchart
