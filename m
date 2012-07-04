Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37856 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2GDNsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2012 09:48:14 -0400
Received: by gglu4 with SMTP id u4so6448921ggl.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2012 06:48:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4Xxq8CpCMtNP=sPSMhsWs4K1qULXWBtGzbu1ENqs1pgBBs3Q@mail.gmail.com>
References: <CAD4Xxq_s4zbRKBrjcQAfn4v5Dp0sytU=8_=XUViice98aQFysQ@mail.gmail.com>
	<CAD4Xxq9LXGXQKRiNsU_tE8LcyJY64Wk5H4OFzEyhhXtsJJy3dw@mail.gmail.com>
	<CAD4Xxq8c_SBbJsZc764oFwNjRDeGKuVEX_042ry=xeZBY_ZH-A@mail.gmail.com>
	<CAD4Xxq8CpCMtNP=sPSMhsWs4K1qULXWBtGzbu1ENqs1pgBBs3Q@mail.gmail.com>
Date: Wed, 4 Jul 2012 09:48:13 -0400
Message-ID: <CAGoCfiwO_sJcqoUQyn5ks1_p1Kf1DG-XtNv_gQSP1L+8myFy3A@mail.gmail.com>
Subject: Re: ATI theatre 750 HD tuner USB stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Fisher Grubb <fisher.grubb@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 4, 2012 at 9:27 AM, Fisher Grubb <fisher.grubb@gmail.com> wrote:
> I was in contact with AMD today regarding this tuner haveing no
> support on Linux and I was given a link for a feedback form and told
> to get specific needs from www.linuxtv.org to help the cause and if
> there were enough people, then the AMD developers may help.

I'm not sure why they would direct you to linuxtv.org.  *They* are the
ones with all the information that the linuxtv community would need.

> Of course I wouldn't be surprised if people will have to reverse
> engineer it from the windows drivers but I thought I would mention it.
>  I could not find any info on this 750 HD on www.linuxtv.org regarding
> where it stands.  What help is needed for it?

1.  Datasheets for the 750 (under NDA is fine), but they need to agree
to allow them to be used to author a GPL driver.
2.  Reference driver sources which can be legally incorporated into a
GPL driver.
3.  Firmware with a license that permits free redistribution.

I attempted to work with them back in 2009 on the T316 chip (an
ATSC/ClearQAM demodulator), and they couldn't provide all of the
above.  Perhaps things have changed since then but I doubt it (in
particular, the sale of their TV chip unit to Broadcom left all sorts
of unknowns regarding who owns the relevant intellectual property).

Finally, even if you get the above, there still needs to be some
developer who has the time/interest to do the work.  While three years
ago the big challenge was getting access to the datasheets, nowadays a
much bigger problem is there are no developers who are both qualified
and not already too busy with other work.  Bootstrapping a new chip
like that is probably a 50-100 hour investment for somebody who is
experienced in this area, which is a fairly big chunk of time if the
developer doesn't have any vested interest.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
