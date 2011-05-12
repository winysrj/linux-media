Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.187]:65415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab1ELMPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 08:15:06 -0400
Date: Thu, 12 May 2011 14:14:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
cc: Josh Wu <josh.wu@atmel.com>, mchehab@redhat.com,
	linux-media@vger.kernel.org, lars.haring@atmel.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
In-Reply-To: <20110512114530.GE18952@game.jcrosoft.org>
Message-ID: <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <20110512114530.GE18952@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 12 May 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:

[snip]

> > +	if (0 == *nbuffers)
> please invert the test

Don't think this is required by CodingStyle or anything like that. If it 
were, you'd have to revamp half of the kernel.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
