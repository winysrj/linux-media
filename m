Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42637 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761264Ab2BNWJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 17:09:56 -0500
Received: by pbcun15 with SMTP id un15so830823pbc.19
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 14:09:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwH8pYmJLB_4rkXF7gqfe2_PhFDz3XyNFO6VHsUQq=8tw@mail.gmail.com>
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
	<CAGoCfiwH8pYmJLB_4rkXF7gqfe2_PhFDz3XyNFO6VHsUQq=8tw@mail.gmail.com>
Date: Tue, 14 Feb 2012 17:09:55 -0500
Message-ID: <CANOx78GKYv9fdHx6ZVABojMBHJCXH3Y8YCGg2nK+HrBjPw-74g@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Jarod Wilson <jarod@wilsonet.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Taylor Ralph <taylor.ralph@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 14, 2012 at 4:32 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Feb 14, 2012 at 3:43 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> Looks sane to me, and really needs to get in ASAP. I'd even suggest we
>> get it sent to stable, as these newer firmware HDPVR are pretty wonky
>> with any current kernel.
>>
>> Acked-by: Jarod Wilson <jarod@redhat.com>
>> Reviewed-by: Jarod Wilson <jarod@redhat.com>
>> CC: stable@vger.kernel.org
>
> Where did the process break down here?  Taylor did this patch *months*
> ago, and there has been absolutely no comment with why it wouldn't go
> upstream.  If he hadn't been diligent in pinging the ML repeatedly, it
> would have been lost.

It looks like for some reason, the v3 patch got eaten. :\

http://patchwork.linuxtv.org/patch/8183/ is the v2, in state Changes
Requested, but you can see in the comments a mail that says v3 is
attached, which contains the requested change (added s-o-b). A v3
patch object is nowhere to be found though. The patch *was* indeed
attached to the mail though, I've got it here in my linux-media
mailbox.

So at least on this one, I think I'm blaming patchwork, but it would
be good to better understand how that patch got eaten, and to know if
indeed its happened to other patches as well.

-- 
Jarod Wilson
jarod@wilsonet.com
