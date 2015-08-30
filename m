Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:18487 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbbH3TeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 15:34:06 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v3 3/4] media: pxa_camera: trivial move of dma irq functions
References: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
	<1438198744-6150-4-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1508301312250.29683@axis700.grange>
Date: Sun, 30 Aug 2015 21:29:35 +0200
In-Reply-To: <Pine.LNX.4.64.1508301312250.29683@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 30 Aug 2015 13:14:43 +0200 (CEST)")
Message-ID: <87a8t81so0.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> This still seems to break compilation to me. Could you compile-test after 
> each your patch, please?
Ah yes. Ill timing, I had sent the v4 before having these comments, so I'll have
to fix it in v5.

Cheers.

-- 
Robert
