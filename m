Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35413 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbcAPXQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2016 18:16:59 -0500
Received: by mail-wm0-f44.google.com with SMTP id r129so11535095wmr.0
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2016 15:16:59 -0800 (PST)
Subject: Re: Pinnacle PCTV DVB-S2 Stick (461e) - HD Streams with artefacts
To: Rainer Dorsch <ml@bokomoko.de>, linux-media@vger.kernel.org
References: <13463113.ozc26Vzdzi@blackbox>
From: Andy Furniss <adf.lists@gmail.com>
Message-ID: <569ACF59.7090700@gmail.com>
Date: Sat, 16 Jan 2016 23:16:41 +0000
MIME-Version: 1.0
In-Reply-To: <13463113.ozc26Vzdzi@blackbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rainer Dorsch wrote:
> Hi,
>
> I have a Pinnacle PCTV DVB-S2 Stick (461e) and did connect it to a
> cubox-i running openelec.
>
> The known issues on
>
> http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_DVB-S2_Stick_%28461e%29
>
>  seem to be gone (at least I did not hit them).
>
> Instead there seems to be another (new?) issue, that HD streams have
> artefacts, see
>
> http://forum.kodi.tv/showthread.php?tid=220129
>
> and
>
> https://tvheadend.org/boards/5/topics/19582?r=19584#message-19584
>
> I tried to add that to the wiki, but my registration attempt was
> rejected.
>
> Can somebody with write access to
> http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_DVB-S2_Stick_%28461e%29
> please add the new issue?
>
> Certainly any hint how to solve this issue is welcome.

I added a comment on the tvh forum - will paste here as well in case
anyone is interested -

You could try spinning up you cpu(s) with

nice -19 dd if=/dev/urandom of=/dev/null

If you have multiple cores maybe start more than one.

I have a couple of DVB-T2 PCTV sticks and got some usb/power save/xhci
issues on my h/w.

Above would mostly fix. Rather than do that I found that the issue was
far less if I disabled USB3 in bios to avoid using the xhci driver.

Of course your issue may be totally different - but it's worth a try.

Your symptoms do point to ts packet loss - which I know from my
experience can be at usb level. There are posts on here from the past
where people with PCIE cards also had to do similar.
