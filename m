Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0EWSfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:35:32 -0400
Message-ID: <4BF9756E.2020507@redhat.com>
Date: Sun, 23 May 2010 15:35:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: Q: Setting up a GIT repository on linuxtv.org
References: <1274635044.2275.11.camel@localhost>
In-Reply-To: <1274635044.2275.11.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Hi,
> 
> I'm a GIT idiot, so I need a little help on getting a properly setup
> repo at linuxtv.org.  Can someone tell me if this is the right
> procedure:
> 
> $ ssh -t awalls@linuxtv.org git-menu
>         (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)

Whatever name you choose. v4l-dvb is just a suggestion. 

> $ git clone \
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
>         v4l-dvb
> $ cd v4l-dvb
> $ git remote add linuxtv http://linuxtv.org/git/v4l-dvb.git
> $ git remote add awalls ssh://linuxtv.org/git/awalls/v4l-dvb.git
> $ git remote update
> 
> and then what? 

See at wiki:
	http://www.linuxtv.org/wiki/index.php/Maintaining_Git_trees
	http://www.linuxtv.org/wiki/index.php/Using_a_git_driver_development_tree

> Something like
> 
> $ git checkout -b cxfoo linuxtv/master   

Something like that. You need to create a working branch, based on one of the
remote branches, and work on it.

The last changes are currently at devel/for_v2.6.34 (with some patches that will
go soon to upstream). So, in order to work against them, you would need to use,
instead:

	$ git checkout -b cxfoo linuxtv/devel/for_v2.6.34

> 
> to develop changes for some Conexant chips for example???
> 
> 
> Thanks,
> Andy
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
