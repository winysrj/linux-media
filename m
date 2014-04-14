Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:48392 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbaDNNu3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 09:50:29 -0400
Date: Mon, 14 Apr 2014 09:17:43 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OV7670: ENUM_FRAMESIZES seems buggy to me
Message-ID: <20140414091743.32523def@lwn.net>
In-Reply-To: <Pine.LNX.4.64.1404141439210.23631@axis700.grange>
References: <Pine.LNX.4.64.1404141439210.23631@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Apr 2014 14:50:15 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> If any of the above "if" statements is true, it will 
> stay true forever, until the loop terminates. If that's intended, you 
> could at least use "break" immediately. If it's not - something else is 
> wrong there. Maybe the "win" initialisation at the top of the loop should 
> have "i" as an index? I.e.
> 
> -		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
> +		struct ov7670_win_size *win = &info->devtype->win_sizes[i];

Sigh.  As far as I can tell, that bug was introduced by
75e2bdad8901a0b599e01a96229be922eef1e488 (ov7670: allow configuration
of image size, clock speed, and I/O method) by Daniel Drake in 2.6.37.
It's not only wrong, it could conceivably be a security issue - index
is unchecked straight from user space.

Say the word and I'll package up a patch.  Otherwise please feel free
to add my Acked-by to your own change, with a cc to stable@.  

Thanks for catching this,

jon
