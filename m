Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63218 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab2BNVct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:32:49 -0500
Received: by vbjk17 with SMTP id k17so324185vbj.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 13:32:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANOx78GENFQXfuX0OeYPa=YCHREk3H2OKmKQhkEsQx9qFieksg@mail.gmail.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
	<CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
	<20111020170811.GD7530@jannau.net>
	<CAGoCfiz38bdpnz0dLfs2p4PjLR1dDm_5d_y34ACpNd6W62G7-w@mail.gmail.com>
	<CAOTqeXpJfk-ENgxhELo03LBHqdtf957knXQzOjYo0YO7sGcAbg@mail.gmail.com>
	<CAOTqeXpY3uvy7Dq3fi1wTD5nRx1r1LMo7=XEfJdxyURY2opKuw@mail.gmail.com>
	<4EB7CD59.1010303@redhat.com>
	<CAOTqeXoavdYLkfp+FRLj3v24z2m+xZHiKhnOOiHJhZ+Y858y9w@mail.gmail.com>
	<CANOx78GENFQXfuX0OeYPa=YCHREk3H2OKmKQhkEsQx9qFieksg@mail.gmail.com>
Date: Tue, 14 Feb 2012 16:32:48 -0500
Message-ID: <CAGoCfiwH8pYmJLB_4rkXF7gqfe2_PhFDz3XyNFO6VHsUQq=8tw@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Taylor Ralph <taylor.ralph@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 14, 2012 at 3:43 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> Looks sane to me, and really needs to get in ASAP. I'd even suggest we
> get it sent to stable, as these newer firmware HDPVR are pretty wonky
> with any current kernel.
>
> Acked-by: Jarod Wilson <jarod@redhat.com>
> Reviewed-by: Jarod Wilson <jarod@redhat.com>
> CC: stable@vger.kernel.org

Where did the process break down here?  Taylor did this patch *months*
ago, and there has been absolutely no comment with why it wouldn't go
upstream.  If he hadn't been diligent in pinging the ML repeatedly, it
would have been lost.

Are there other patches that have hit the ML that aren't getting upstream?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
