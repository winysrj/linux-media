Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbZHaNTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 09:19:43 -0400
Date: Mon, 31 Aug 2009 10:19:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4l: add NULL pointer check
Message-ID: <20090831101932.526dfdbc@pedra.chehab.org>
In-Reply-To: <200908310852.38847.laurent.pinchart@ideasonboard.com>
References: <4A9A3EB0.8060304@freemail.hu>
	<200908302333.20933.laurent.pinchart@ideasonboard.com>
	<4A9B64E0.9040003@freemail.hu>
	<200908310852.38847.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2009 08:52:38 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> >  - dereferencing a NULL pointer is not always result segfault, see [1] and
> >    [2]. So dereferencing a NULL pointer can be treated also as a security
> >    risk.  

>From kernelspace drivers POV, any calls sending a NULL pointer should
result in an error as soon as possible, to avoid any security risks.
Currently, this check is left to the driver, but we should consider
implementing such control globally, at video_ioctl2 and at compat32 layer.

IMHO, libv4l should mimic the driver behavior of returning an error instead of
letting the application to segfault, since, on some critical applications,
like video-surveillance security systems, a segfault could be very bad.



Cheers,
Mauro
