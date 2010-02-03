Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab0BCQTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 11:19:39 -0500
Message-ID: <4B69A206.2010304@redhat.com>
Date: Wed, 03 Feb 2010 14:19:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: git problem with uvcvideo
References: <4B5CBC31.5090701@freemail.hu> <201001251907.18266.laurent.pinchart@ideasonboard.com> <4B5DF582.1080602@infradead.org>
In-Reply-To: <4B5DF582.1080602@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> However, the html URL is currently broken:
> 
> $ rm -rf uvcvideo/ && git clone -l --bare /git/linux-2.6.git/ uvcvideo && cd uvcvideo && git remote add uvcvideo http://linuxtv.org/git/pinchartl/uvcvideo.git && git remote update 
> Initialized empty Git repository in /home/mchehab/tst/uvcvideo/uvcvideo/
> Updating uvcvideo
> 
> Probably, the rewrite rules at the server for http are incomplete. I'll see if I can fix it.

Fixed. 

Basically, for http: to work, the http server shouldn't call gitweb handler. So, a different URL
is needed for gitweb and for git pull... Also, I needed to enable an post-update hook to be sure that
some references are generated after a push.

I've updated the gitweb to display the proper URL's.

Basically, the gitweb interface is available via http://git.linuxtv.org. 

So, for uvcvideo, we have:
	http://git.linuxtv.org/pinchartl/uvcvideo.git	(gitweb interface, for browsing)

For adding a remote to that tree, you should use either:
	git remote add uvcvideo git://linuxtv.org/pinchartl/uvcvideo.git
		or
	git remote add uvcvideo http://linuxtv.org/git/pinchartl/uvcvideo.git

Both is working, but using the git: URL is better. The http: URL should be used only when
behind a firewall that blocks the git port (tcp port 9418).

-- 

Cheers,
Mauro
