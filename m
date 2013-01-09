Return-path: <linux-media-owner@vger.kernel.org>
Received: from microschulz.de ([79.140.41.212]:47197 "EHLO microschulz.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3AIWI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 17:08:26 -0500
Date: Wed, 9 Jan 2013 22:30:43 +0100
From: Nikolaus Schulz <mail@microschulz.de>
To: Soby Mathew <soby.linuxtv@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: global mutex in dvb_usercopy (dvbdev.c)
Message-ID: <20130109213043.GB7500@zorro.zusammrottung.local>
References: <CAGzWAsgZGu8_JTrE1GvnpbR+W92fvRycfFhAX2NbZ9VZqorJ6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGzWAsgZGu8_JTrE1GvnpbR+W92fvRycfFhAX2NbZ9VZqorJ6w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 08, 2013 at 12:05:47PM +0530, Soby Mathew wrote:
> Hi Everyone,
>     I have a doubt regarding about the global mutex lock in
> dvb_usercopy(drivers/media/dvb-core/dvbdev.c, line 382) .
> 
> 
> /* call driver */
> mutex_lock(&dvbdev_mutex);
> if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
> err = -EINVAL;
> mutex_unlock(&dvbdev_mutex);
> 
> 
> Why is this mutex needed? When I check similar functions like
> video_usercopy, this kind of global locking is not present when func()
> is called.

I cannot say anything about video_usercopy(), but as it happens, there's
a patch[1] queued for Linux 3.9 that will hopefully replace the mutex in
dvb_usercopy() with more fine-grained locking.

Nikolaus

[1] http://git.linuxtv.org/media_tree.git/commit/30ad64b8ac539459f8975aa186421ef3db0bb5cb
