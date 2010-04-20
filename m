Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:46399 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab0DTRg0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 13:36:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	jic23@cam.ac.uk
Subject: Re: [PATCH] pxa_camera: move fifo reset direct before dma start
References: <1271746289-14849-1-git-send-email-hbmeier@hni.uni-paderborn.de>
	<Pine.LNX.4.64.1004200905250.5292@axis700.grange>
Date: Tue, 20 Apr 2010 19:36:13 +0200
In-Reply-To: <Pine.LNX.4.64.1004200905250.5292@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue, 20 Apr 2010 09:06:38 +0200 (CEST)")
Message-ID: <87ljciyqk2.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Robert, what do you think? Are you still working with PXA camera?
Hi Guennadi,

Yes, I'm still working with pxa_camera :)

About the patch, I have a very good feeling about it. I have not tested it, but
it looks good to me. I'll assume Stefan has tested it, and if you want it,
please take my :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
