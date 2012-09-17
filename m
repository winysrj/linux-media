Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:54517 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab2IQPqv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 11:46:51 -0400
Date: Mon, 17 Sep 2012 09:47:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] videobuf2-core: Replace BUG_ON and return an error
 at vb2_queue_init()
Message-ID: <20120917094742.7309b29a@lwn.net>
In-Reply-To: <201209171741.24310.hverkuil@xs4all.nl>
References: <1347889437-15073-1-git-send-email-elezegarcia@gmail.com>
	<201209171610.43862.hverkuil@xs4all.nl>
	<20120917093636.635feb96@lwn.net>
	<201209171741.24310.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 17 Sep 2012 17:41:24 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> However, videobuf2-core.c is a core function of a core module. So it will
> give this warning once for one driver, then another is loaded with the same
> problem and you'll get no warnings anymore.

Unlikely scenario, but good point regardless, I hadn't thought about that
aspect of the problem. 

jon
