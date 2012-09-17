Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:54348 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2IQPfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 11:35:45 -0400
Date: Mon, 17 Sep 2012 09:36:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] videobuf2-core: Replace BUG_ON and return an error
 at vb2_queue_init()
Message-ID: <20120917093636.635feb96@lwn.net>
In-Reply-To: <201209171610.43862.hverkuil@xs4all.nl>
References: <1347889437-15073-1-git-send-email-elezegarcia@gmail.com>
	<201209171610.43862.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Sep 2012 16:10:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Why WARN_ON_ONCE? I'd want to see this all the time, not just once.
> 
> It's certainly better than BUG_ON, but I'd go for WARN_ON.

I like WARN_ON_ONCE better, myself.  Avoids the risk of spamming the logs,
and once is enough to answer that "why doesn't my camera work?" question.
Don't feel all that strongly about it, though...

jon
