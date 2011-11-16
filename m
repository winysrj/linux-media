Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37908 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599Ab1KPHma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 02:42:30 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id E00FC21116
	for <linux-media@vger.kernel.org>; Wed, 16 Nov 2011 02:42:28 -0500 (EST)
Message-ID: <4EC36963.9000300@ladisch.de>
Date: Wed, 16 Nov 2011 08:42:27 +0100
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix truncated entity specification
References: <4EB5ADA9.6010104@ladisch.de> <201111150148.07957.laurent.pinchart@ideasonboard.com> <4EC262DD.1070502@ladisch.de> <201111160133.04816.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111160133.04816.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> > > On Saturday 05 November 2011 22:42:01 Clemens Ladisch wrote:
> > > > When enumerating an entity, assign the entire entity specification
> > > > instead of only the first two words.  (This requires giving the
> > > > specification union a name.)
> 
> Your patch looks good then, except that I would memcpy to u_ent.raw instead of
> u_ent.v4l. Would you also be ok with shortening specification to spec (or
> info) ?

Yes, go ahead.


Regards,
Clemens
