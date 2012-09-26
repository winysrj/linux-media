Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47269 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab2IZQlG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 12:41:06 -0400
Date: Wed, 26 Sep 2012 10:42:02 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 2/5] media: ov7670: make try_fmt() consistent with
 'min_height' and 'min_width'.
Message-ID: <20120926104202.794c96c5@lwn.net>
In-Reply-To: <1348652877-25816-3-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-3-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 11:47:54 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> 'min_height' and 'min_width' are variables that allow to specify the minimum
> resolution that the sensor will achieve. This patch make v4l2 fmt callbacks
> consider this parameters in order to return valid data to user space.
> 
I'd have preferred to do this differently, perhaps backing toward larger
sizes if the minimum turns out to be violated.  But so be it...

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
