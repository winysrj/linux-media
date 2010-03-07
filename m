Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1287 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0CGRZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 12:25:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Daily build: added git support
Date: Sun, 7 Mar 2010 18:25:30 +0100
Cc: linux-media@vger.kernel.org,
	=?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
References: <201003071650.02137.hverkuil@xs4all.nl> <4B93D469.6080709@infradead.org>
In-Reply-To: <4B93D469.6080709@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003071825.30891.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 07 March 2010 17:29:29 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> > Hi all,
> > 
> > It took longer than I intended, but I finally added git support to the daily
> > build process. Note that I am only building the drivers/media subdirectory and
> > not a full kernel build as that takes too long.
> > 
> > Also note that I am building against the media-master branch. I think that is
> > sufficient, but if not, then let me know.
> 
> Maybe you might also add drivers/staging, enabling just the pertinent drivers
> (tm6000/cx25821/go7007). Anyway, I always compile here before pushing it. So, I
> expect no surprises, at least with make allyesconfig.

Added these staging drivers for the i686 and x86_64 architectures.

Regards,

	Hans

> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
