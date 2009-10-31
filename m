Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZJaJIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 05:08:30 -0400
Date: Sat, 31 Oct 2009 07:07:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
Message-ID: <20091031070701.4ccf27d5@caramujo.chehab.org>
In-Reply-To: <200910120034.58943.laurent.pinchart@ideasonboard.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
	<ef810b1f134d8b5f07b849b13751445d7d49956b.1254884776.git.joe@perches.com>
	<200910120034.58943.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Em Mon, 12 Oct 2009 00:34:58 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> As this will go through the linuxtv v4l-dvb tree, I'll have to add backward
> compatibility code (that will not make it to mainline). If that's ok with you
> it will be easier for me to test and apply that part of the patch through my
> tree once the vsprintf extension gets in. 

I'm assuming that those printk patches from Joe to uvc will go via your tree,
so please submit a pull request when they'll be ready for upstream.




Cheers,
Mauro
