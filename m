Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47346 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188Ab2IZQvt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 12:51:49 -0400
Date: Wed, 26 Sep 2012 10:52:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 5/5] media: ov7670: Add possibility to disable pixclk
 during hblank.
Message-ID: <20120926105244.177b2471@lwn.net>
In-Reply-To: <1348652877-25816-6-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-6-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 11:47:57 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/i2c/ov7670.c |    8 ++++++++
>  include/media/ov7670.h     |    1 +
>  2 files changed, 9 insertions(+)

Again, needs a changelog.  Otherwise

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
