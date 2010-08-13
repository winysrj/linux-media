Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:52923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0HMSkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 14:40:51 -0400
Message-ID: <4C6591C7.7010300@infradead.org>
Date: Fri, 13 Aug 2010 15:41:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: commpile error in function  =?UTF-8?B?4oCYdjRsMl9jdHJsX2hhbmQ=?=
 =?UTF-8?B?bGVyX2luaXTigJk=?=
References: <201008132022.42925.toralf.foerster@gmx.de>
In-Reply-To: <201008132022.42925.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 13-08-2010 15:22, Toralf Förster escreveu:
> Hello,
> 
> I get this with current git :
>   CC [M]  drivers/media/video/v4l2-ctrls.o
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_init’:
> drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of function 
> ‘kzalloc’
> drivers/media/video/v4l2-ctrls.c:767: warning: assignment makes pointer from 
> integer without a cast
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_handler_free’:
> drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of function 
> ‘kfree’
> drivers/media/video/v4l2-ctrls.c: In function ‘handler_new_ref’:
> drivers/media/video/v4l2-ctrls.c:896: warning: assignment makes pointer from 
> integer without a cast
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_ctrl_new’:
> drivers/media/video/v4l2-ctrls.c:975: warning: assignment makes pointer from 
> integer without a cast
> drivers/media/video/v4l2-ctrls.c: In function ‘v4l2_g_ext_ctrls’:
> drivers/media/video/v4l2-ctrls.c:1528: error: implicit declaration of function 
> ‘kmalloc’
> drivers/media/video/v4l2-ctrls.c:1528: warning: assignment makes pointer from 
> integer without a cast
> drivers/media/video/v4l2-ctrls.c: In function ‘try_set_ext_ctrls’:
> drivers/media/video/v4l2-ctrls.c:1752: warning: assignment makes pointer from 
> integer without a cast
> make[3]: *** [drivers/media/video/v4l2-ctrls.o] Error 1
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....

It should be solved by this commit:
 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1547ac893acbf87738ded0b470e2735fdfba6947

Cheers,
Mauro.
