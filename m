Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bokomoko.de ([37.120.169.230]:55316 "EHLO
	netcup.bokomoko.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbcAPXnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2016 18:43:19 -0500
From: Rainer Dorsch <ml@bokomoko.de>
To: Andy Furniss <adf.lists@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Pinnacle PCTV DVB-S2 Stick (461e) - HD Streams with artefacts
Date: Sun, 17 Jan 2016 00:43:21 +0100
Message-ID: <2761448.7zDNhWqk2x@blackbox>
In-Reply-To: <569ACF59.7090700@gmail.com>
References: <13463113.ozc26Vzdzi@blackbox> <569ACF59.7090700@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

thanks for your reply.

On Saturday 16 January 2016 23:16:41 you wrote:
> Rainer Dorsch wrote:
> > Hi,
> > 
> > I have a Pinnacle PCTV DVB-S2 Stick (461e) and did connect it to a
> > cubox-i running openelec.
> > 
> > The known issues on
> > 
> > http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_DVB-S2_Stick_%28461e%29
> > 
> >  seem to be gone (at least I did not hit them).
> > 
> > Instead there seems to be another (new?) issue, that HD streams have
> > artefacts, see
> > 
> > http://forum.kodi.tv/showthread.php?tid=220129
> > 
> > and
> > 
> > https://tvheadend.org/boards/5/topics/19582?r=19584#message-19584
> > 
> > I tried to add that to the wiki, but my registration attempt was
> > rejected.
> > 
> > Can somebody with write access to
> > http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_DVB-S2_Stick_%28461e%29
> > please add the new issue?
> > 
> > Certainly any hint how to solve this issue is welcome.
> 
> I added a comment on the tvh forum - will paste here as well in case
> anyone is interested -
> 
> You could try spinning up you cpu(s) with
> 
> nice -19 dd if=/dev/urandom of=/dev/null

I added four of these, but if at all then there was only a minor impact.

> 
> If you have multiple cores maybe start more than one.
> 
> I have a couple of DVB-T2 PCTV sticks and got some usb/power save/xhci
> issues on my h/w.
> 
> Above would mostly fix. Rather than do that I found that the issue was
> far less if I disabled USB3 in bios to avoid using the xhci driver.

The cubox-i has no USB 3 port and no bios :-/

> Of course your issue may be totally different - but it's worth a try.

> Your symptoms do point to ts packet loss - which I know from my
> experience can be at usb level. There are posts on here from the past
> where people with PCIE cards also had to do similar.

Sounds reasonable. Can I enable logs which would make these drops explicit?

Thanks,
Rainer

-- 
Rainer Dorsch
http://bokomoko.de/
