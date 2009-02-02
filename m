Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:49858 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752808AbZBBQEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 11:04:55 -0500
Received: from ::ffff:71.117.247.66 ([71.117.247.66]) by xenotime.net for <linux-media@vger.kernel.org>; Mon, 2 Feb 2009 08:04:49 -0800
Message-ID: <498719A2.9030908@xenotime.net>
Date: Mon, 02 Feb 2009 08:04:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] newport: newport_*wait() return 0 on timeout
References: <49846E63.8070507@gmail.com>	 <20090202100852.733c6c8e@caramujo.chehab.org> <25e057c00902020532p7a22f9d6pbfdc4f26c85c4dfd@mail.gmail.com>
In-Reply-To: <25e057c00902020532p7a22f9d6pbfdc4f26c85c4dfd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

roel kluin wrote:
> 2009/2/2 Mauro Carvalho Chehab <mchehab@infradead.org>:
>> Hi Roel,
>>
>> It seems that you've sent this driver to the wrong ML. Video adapters are not handled on those ML's.
> 
> Any idea where it should be sent?

drivers/video/* generally go to here AFAIK:

FRAMEBUFFER LAYER
P:	Antonino Daplas
M:	adaplas@gmail.com
L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
W:	http://linux-fbdev.sourceforge.net/
S:	Maintained



~Randy
