Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0CGQ3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 11:29:34 -0500
Message-ID: <4B93D469.6080709@infradead.org>
Date: Sun, 07 Mar 2010 13:29:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: Daily build: added git support
References: <201003071650.02137.hverkuil@xs4all.nl>
In-Reply-To: <201003071650.02137.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi all,
> 
> It took longer than I intended, but I finally added git support to the daily
> build process. Note that I am only building the drivers/media subdirectory and
> not a full kernel build as that takes too long.
> 
> Also note that I am building against the media-master branch. I think that is
> sufficient, but if not, then let me know.

Maybe you might also add drivers/staging, enabling just the pertinent drivers
(tm6000/cx25821/go7007). Anyway, I always compile here before pushing it. So, I
expect no surprises, at least with make allyesconfig.


-- 

Cheers,
Mauro
