Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:47930 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab0LNMdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 07:33:49 -0500
Message-ID: <4D076425.9050602@infradead.org>
Date: Tue, 14 Dec 2010 10:33:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Sergej Pupykin <pupykin.s@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [patch v2] [media] bttv: take correct lock in bttv_open()
References: <20101210033304.GX10623@bicker> <4D01D4BE.1080000@gmail.com> <20101212165812.GG10623@bicker> <4D054FE9.80000@gmail.com> <20101214103658.GL1620@bicker>
In-Reply-To: <20101214103658.GL1620@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 14-12-2010 08:36, Dan Carpenter escreveu:
> On Mon, Dec 13, 2010 at 01:42:49AM +0300, Sergej Pupykin wrote:
>> mutex_lock(&btv->lock);
>> *fh = btv->init;
>> mutex_unlock(&btv->lock);
>>
>> Probably it is overkill and may be incorrect, but it starts working.
>>
> 
> Mauro would be the one to know for sure.
>  
>> Also I found another issue: tvtime hangs on exit in D-state, so it
>> looks like there is a problem near bttv_release function or
>> something like this.
> 
> Speaking of other bugs in this driver, I submitted a another fix
> that hasn't been merged yet.  I've attached it.  Don't know if it's
> related at all to the other bug you noticed but it can't hurt.

I'm preparing one machine in order to test bttv and try to fix the 
locking issues. Hopefully, I'll have something today.

Cheers,
Mauro

