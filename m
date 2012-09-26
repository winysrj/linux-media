Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47332 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab2IZQt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 12:49:58 -0400
Date: Wed, 26 Sep 2012 10:50:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 3/5] media: ov7670: calculate framerate properly for
 ov7675.
Message-ID: <20120926105054.12aca245@lwn.net>
In-Reply-To: <1348652877-25816-4-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-4-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 11:47:55 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> According to the datasheet ov7675 uses a formula to achieve
> the desired framerate that is different from the operations
> done in the current code.
> 
> In fact, this formula should apply to ov7670 too. This would
> mean that current code is wrong but, in order to preserve
> compatibility, the new formula will be used for ov7675 only.

At this point I couldn't tell you what the real situation is; it's been a
while and there's always a fair amount of black magic involved with
ov7670 configuration.  I do appreciate attention to not breaking existing
users.

> +static void ov7670_get_framerate(struct v4l2_subdev *sd,
> +				 struct v4l2_fract *tpf)

This bugs me, though.  It's called ov7670_get_framerate() but it's getting
the rate for the ov7675 - confusing.  Meanwhile the real ov7670 code
remains inline while ov7675 has its own function.  

Please make two functions, one of which is ov7675_get_framerate(), and call
the right one for the model.  Same for the "set" functions, obviously.
Maybe what's really needed is a structure full of sensor-specific
operations?  The get_wsizes() function could go there too.  That would take
a lot of if statements out of the code.

> +	/*
> +	 * The datasheet claims that clkrc = 0 will divide the input clock by 1
> +	 * but we've checked with an oscilloscope that it divides by 2 instead.
> +	 * So, if clkrc = 0 just bypass the divider.
> +	 */

Thanks for documenting this kind of thing.

jon
