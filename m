Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35648 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbcCDK61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2016 05:58:27 -0500
Date: Fri, 4 Mar 2016 07:58:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l2-mc.h: fix PM/pipeline stub definitions
Message-ID: <20160304075821.3e65ff11@recife.lan>
In-Reply-To: <1457086419-261550-1-git-send-email-arnd@arndb.de>
References: <1457086419-261550-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Mar 2016 11:13:36 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> The newly added functions have an extra semicolon, which
> prevents compilation, and they need to be marked inline:
> 
> In file included from ../include/media/tuner.h:23:0,
>                  from ../drivers/media/tuners/tuner-simple.c:10:
> ../include/media/v4l2-mc.h:233:1: error: expected identifier or '(' before '{' token
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: a77bf7048add ("v4l2-mc.h: Add stubs for the V4L2 PM/pipeline routines")

Hans sent a fix almost of the same time as yours.

I'm merging your SOB on his patch (with has an additional hunk removing
an uneeded return).

Thanks!
Mauro
