Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbZB1AdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 19:33:15 -0500
Date: Fri, 27 Feb 2009 21:32:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [cron job] ERRORS: armv5 armv5-ixp armv5-omap2 i686 m32r mips
 powerpc64 x86_64 v4l-dvb build
Message-ID: <20090227213242.722e0257@pedra.chehab.org>
In-Reply-To: <200902271849.n1RInuKh050681@smtp-vbr14.xs4all.nl>
References: <200902271849.n1RInuKh050681@smtp-vbr14.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Feb 2009 19:49:56 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> (This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.)
> 
> Results of the daily build of v4l-dvb:
> 
> linux-2.6.16.61-i686: ERRORS
> linux-2.6.17.14-i686: ERRORS
> linux-2.6.18.8-i686: ERRORS
> linux-2.6.19.5-i686: ERRORS
> linux-2.6.20.21-i686: ERRORS
> linux-2.6.21.7-i686: ERRORS
> linux-2.6.22.19-i686: ERRORS
> linux-2.6.23.12-i686: ERRORS
> linux-2.6.24.7-i686: ERRORS
> linux-2.6.25.11-i686: ERRORS
> linux-2.6.26-i686: ERRORS
> linux-2.6.27-i686: ERRORS
> linux-2.6.28-i686: ERRORS
> linux-2.6.29-rc5-i686: ERRORS

Wow! Lots of errors!

Ok, I've removed tvmixer and marked the minimal version for firedtv. This
should fix the issues.

Cheers,
Mauro
