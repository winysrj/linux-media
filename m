Return-path: <mchehab@gaivota>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:55445 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0LLWmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 17:42:54 -0500
Received: by ewy10 with SMTP id 10so3588953ewy.4
        for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 14:42:52 -0800 (PST)
Message-ID: <4D054FE9.80000@gmail.com>
Date: Mon, 13 Dec 2010 01:42:49 +0300
From: Sergej Pupykin <pupykin.s@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [patch v2] [media] bttv: take correct lock in bttv_open()
References: <20101210033304.GX10623@bicker> <4D01D4BE.1080000@gmail.com> <20101212165812.GG10623@bicker>
In-Reply-To: <20101212165812.GG10623@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12.12.2010 19:58, Dan Carpenter wrote:
> We're trying to make sure that no one is writing to the btv->init struct
> while we copy it over to the newly allocated "fh" struct.  The original
> code doesn't make sense because "fh->cap.vb_lock" hasn't been
> initialized and no one else can be writing to it anyway.
>
This patch also crashes the system. Unfortunately machine hangs, so I 
can not copy-paste trace. It was something about nosemaphore called from 
bttv_open. (something like previous reports)

I replace lock with btv->lock:

mutex_lock(&btv->lock);
*fh = btv->init;
mutex_unlock(&btv->lock);

Probably it is overkill and may be incorrect, but it starts working.

Also I found another issue: tvtime hangs on exit in D-state, so it looks 
like there is a problem near bttv_release function or something like this.
