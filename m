Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbZBZBki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 20:40:38 -0500
Date: Wed, 25 Feb 2009 22:39:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	Markus Rechberger <mrechberger@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory
 together with uvcvideo driver
Message-ID: <20090225223956.108a9225@caramujo.chehab.org>
In-Reply-To: <200902252255.43803.laurent.pinchart@skynet.be>
References: <bug-12768-10286@http.bugzilla.kernel.org/>
	<49A4F6C0.5060503@freemail.hu>
	<20090225094929.09783b83@caramujo.chehab.org>
	<200902252255.43803.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Feb 2009 22:55:43 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Could this
> 
> http://article.gmane.org/gmane.linux.usb.general/15315/match=urb+leak
> 
> be related ?

This seems to solve the bug with the em28xx driver. I'll let the stress test
run over the night and see if is everything is all right.

Cheers,
Mauro
