Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47343 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab2IZQvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 12:51:16 -0400
Date: Wed, 26 Sep 2012 10:52:11 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/5] media: ov7670: add possibility to bypass pll for
 ov7675.
Message-ID: <20120926105211.38d14bc4@lwn.net>
In-Reply-To: <1348652877-25816-5-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-5-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Sep 2012 11:47:56 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

This one needs a changelog - what does bypassing the PLL do and why might
you want to do it?  Otherwise:

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
