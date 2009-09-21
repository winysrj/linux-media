Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:42983 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZIULvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 07:51:14 -0400
Received: by fxm12 with SMTP id 12so2111034fxm.18
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 04:51:17 -0700 (PDT)
Date: Mon, 21 Sep 2009 14:51:22 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Roman <lists@hasnoname.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MSI Digivox mini III Remote Control
Message-ID: <20090921115122.GA2269@moon>
References: <200909202026.27086.lists@hasnoname.de> <20090921081933.GA29884@moon> <200909211253.49766.lists@hasnoname.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909211253.49766.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just grab that patch and apply it to the current vl4-dvb, no need to mess
with old repository.
http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/raw-rev/914ded6d921d

Now if the current tree doesn't compile, thats another issue, probably
something with kernel headers, etc.

Actually thats interesting, I will test it on 64-bit Windows 7 when I get
home, will RMA that stick if remote doesn't work.

As for channel switching, it's most likely a tv viewing software issue, 
buffering or something like that. For me this tuner locks to transponder
in aprox. 1 second.

On Mon, Sep 21, 2009 at 12:53:49PM +0200, Roman wrote:
> Hi,
> 
> thx for the tip, i jusst tested it on Windows 7 and i was amazed....
> Not only the remote worked perfectly out of the box, also the software used 
> (some media-center from ArcSoft), worked flawless. (I last used a Hauppauge 
> TV-Card about 2 years ago on windows).
> One thing to note is the channel switching was a LOT faster (max. 1sec.) than 
> on linux (sometimes > 5sec.).
> 
> Anyway, the remote works on windows, no i am trying to compile the mentioned 
> repository, but it seems to fail compiling.
> I already sent a mail to the msi-support...
> 
> #------
> make[2]: Entering directory `/home/strowi/src/zen-sources'
>   CC [M]  /home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.o
> In file included from /home/strowi/src/af9015-digivox3_remote/v4l/dmxdev.h:33,
>                  from /home/strowi/src/af9015-digivox3_remote/v4l/au0828.h:29,
>                  
> from /home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.c:22:
> /home/strowi/src/af9015-digivox3_remote/v4l/compat.h:385: error: redefinition 
> of 'usb_endpoint_type'
> include/linux/usb/ch9.h:377: error: previous definition of 'usb_endpoint_type' 
> was here
> make[3]: *** [/home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.o] 
> Error 1
> #------
> 
> Am Monday 21 September 2009 10:19:33 schrieb Aleksandr V. Piskunov:
> > Well, it seems there is a patch for Digivox mini III remote control at
> > http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/, perhaps Antti
> > can tell you more about it.
> >
> > I got this tuner, and no, IR receiver doesn't work for me, it doesn't
> > even work in WinXP with bundled drivers and software, tested with
> > USB snoop, no reaction to keypresses. Maybe a hardware defect at
> > receiver part, maybe something is missing in a firmware, no idea.
> >
> > So check it on some Windows system first, then try patch..
> >
> 
> greetings,
> Roman
> -- 
> Iron Law of Distribution:
> 	Them that has, gets.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
