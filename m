Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:38718 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3IPRiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 13:38:51 -0400
Received: by mail-we0-f173.google.com with SMTP id w62so3937499wes.18
        for <linux-media@vger.kernel.org>; Mon, 16 Sep 2013 10:38:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52363EA6.7060402@sca-uk.com>
References: <5235CED8.3080804@sca-uk.com>
	<CAGoCfiyuvXAhBS=n=_3bZKnCSTZYMrHFJ73MfRnoiuW44Y=zKg@mail.gmail.com>
	<52363EA6.7060402@sca-uk.com>
Date: Mon, 16 Sep 2013 13:38:50 -0400
Message-ID: <CAGoCfix7r_bp7w-6HyXYz_XOZz-zFk_SLUzA6-Br6Z-LLsTy-g@mail.gmail.com>
Subject: Re: Hauppauge ImpactVCB-e 01381 PCIe driver resolution.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 15, 2013 at 7:11 PM, Steve Cookson <it@sca-uk.com> wrote:
> Hi Devin,
>
> Thanks for responding.
>
> So my question would be then, is it worth fixing?
>
> I can't find any PCIe cards that give me a reasonable quality.
>
> If I use an external card like the Dazzle it seems quite fast and better
> quality than many s-video cards.
>
> Could the ImpactVCB-e be better than the Dazzle?

Hi Steve,

Whether it's worth fixing, it's largely a question of "worth it to
whom"?  Apparently nobody had noticed it was broken until now, hence
making it questionable how important it is to the general community.

It's worth noting that the problem isn't specific to the ImpactVCB-e;
it would happen with any cx23885 based board.

The quality will probably be comparable to the Dazzle.  In terms of
"quite fast", they should both be the exact same speed since they are
both delivering raw video in realtime.  One key advantage of the
ImpactVCB-e is that you can have multiple installed in a single
system, while in the case of the Dazzle you will likely only be able
to use one device since it uses more than half of the USB bus
bandwidth.

I'm not sure what other cards you've tried.  Nowadays they should all
deliverable comparable performance for s-video (since no chroma
separation is involved), if they don't then it's almost certainly a
Linux driver bug.

If you have a commercial need for the device to work, we can discuss
offlist doing some consulting to resolve the issue.  However if not
then you're pretty much at the mercy of the community in terms of the
state of quality/support.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
