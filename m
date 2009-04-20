Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbZDTRui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 13:50:38 -0400
Date: Mon, 20 Apr 2009 14:50:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [patch review] uvc_driver: fix compile warning
Message-ID: <20090420145031.2ffd860a@pedra.chehab.org>
In-Reply-To: <200904201925.00656.laurent.pinchart@skynet.be>
References: <1240171389.12537.3.camel@tux.localhost>
	<200904201925.00656.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009 19:25:00 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Alexey,
> 
> On Sunday 19 April 2009 22:03:09 Alexey Klimov wrote:
> > Hello, all
> > I saw warnings in v4l-dvb daily build.
> > May this patch be helpful?
> 
> I can't reproduce the problem with gcc 4.3.2.
> 
> Hans, what's the policy for fixing gcc-related issues ? Should the code use 
> uninitialized_var() to make every gcc version happy, or can ignore the 
> warnings when a newer gcc version fixes the problem 

Laurent,

The kernel way is to use unitialized_var() on such cases.

Personally, I don't like very much this approach, since it will get rid forever
of such error for that var. However, a future patch could make that var truly
uninitialized. So, an extra care should be taken on every patch touching a var
that uses uninitialized_var() macro.

>From my side, I accept patches with both ways to fix it.

Cheers,
Mauro
