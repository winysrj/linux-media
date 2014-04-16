Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35455 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161077AbaDPNnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 09:43:11 -0400
Date: Wed, 16 Apr 2014 09:43:09 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] V4L2: ov7670: fix a wrong index, potentially Oopsing
 the kernel from user-space
Message-ID: <20140416094309.5736bc19@lwn.net>
In-Reply-To: <Pine.LNX.4.64.1404141545280.23631@axis700.grange>
References: <Pine.LNX.4.64.1404141545280.23631@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Apr 2014 15:49:34 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> I'd prefer to first post it to the lists to maybe have someone test it ;) 
> Otherwise - I've got a couple more fixes for 3.15, which I hope to make 
> ready and push in a couple of weeks... So, with your ack I can take this 
> one too, or, if you prefer to push it earlier - would be good too.

Unfortunately, my machines that could test this are a couple thousand
miles away, and that situation isn't going to change anytime soon.  It
looks clearly more correct than what was there before, though, so feel
free to add my ack to it.

Thanks,

jon
