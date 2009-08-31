Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37056 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZHaUQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 16:16:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] libv4l: add NULL pointer check
Date: Mon, 31 Aug 2009 22:16:14 +0200
Cc: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4A9A3EB0.8060304@freemail.hu> <200908310852.38847.laurent.pinchart@ideasonboard.com> <20090831101932.526dfdbc@pedra.chehab.org>
In-Reply-To: <20090831101932.526dfdbc@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908312216.14184.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 August 2009 15:19:32 Mauro Carvalho Chehab wrote:
> Em Mon, 31 Aug 2009 08:52:38 +0200
>
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > >  - dereferencing a NULL pointer is not always result segfault, see [1]
> > > and [2]. So dereferencing a NULL pointer can be treated also as a
> > > security risk.
>
> From kernelspace drivers POV, any calls sending a NULL pointer should
> result in an error as soon as possible, to avoid any security risks.
> Currently, this check is left to the driver, but we should consider
> implementing such control globally, at video_ioctl2 and at compat32 layer.
>
> IMHO, libv4l should mimic the driver behavior of returning an error instead
> of letting the application to segfault, since, on some critical
> applications, like video-surveillance security systems, a segfault could be
> very bad.

And uncaught errors would be even better. A segfault will be noticed right 
away, while an unhandled error code might slip through to the released 
software. If a security-sensitive application passes a NULL pointer where it 
shouldn't I'd rather see the development machine burst into flames instead of 
silently ignoring the problem.

-- 
Laurent Pinchart
