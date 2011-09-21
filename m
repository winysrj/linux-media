Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:38997 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1IURjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 13:39:04 -0400
Date: Wed, 21 Sep 2011 11:39:02 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	ytang5@marvell.com, leiwen@marvell.com, jwan@marvell.com,
	qingx@marvell.com
Subject: Re: [PATCH V3] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
Message-ID: <20110921113902.1ea85b06@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.1109211928500.24024@axis700.grange>
References: <1307528966-8233-1-git-send-email-ygli@marvell.com>
	<4E7A1CD8.8070401@redhat.com>
	<Pine.LNX.4.64.1109211928500.24024@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Sep 2011 19:31:21 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Indeed I would (mind);-) AFAIU, Jon has converted the cafe-ccic driver to 
> be usable for other implementations, using the same core, this driver has 
> to be converted to re-use the common code, and so far this has not been 
> done, or am I missing something?

That is, indeed, how I think it should be done.  I'm fully aware that I've
not quite finished my part of that - in particular, I've not fixed the
ov7670-only problem.  That would move up on my tragically long priority
list if I knew that there would be a need for it in the near future.

Thanks,

jon
