Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47689 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0IODLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 23:11:24 -0400
Received: by ywh1 with SMTP id 1so2564686ywh.19
        for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 20:11:24 -0700 (PDT)
Message-ID: <4C9039E7.3040809@gmail.com>
Date: Tue, 14 Sep 2010 23:13:43 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: How to handle independent CA devices
References: <19593.22297.612764.560375@valen.metzler>	<20100914144339.GA9525@linuxtv.org> <19600.3015.410234.367070@valen.metzler>
In-Reply-To: <19600.3015.410234.367070@valen.metzler>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

rjkm a écrit :
> Hi Johannes,
>
>
> Johannes Stezenbach writes:
>  > > So, I would like to hear your opinions about how to handle such CA devices 
>  > > regarding device names/types, the DVB API and user libraries.
>  > 
>  > it looks like there isn't much interest from DVB developers
>  > in that topic...  I'll try...
>  > 
>  > 
>  > IMHO there are three sub topics:
>  > 
>  > 1. be compatible with existing applications
>  >    (I guess this means: feed stream from frontend through CI transparently)
>  > 2. create an API which would also work for CI-only
>  >    devices like this Hauppauge WinTV-CI USB thingy
>  > 3. how to switch between these modes?
>  > 
>  > This sec0 device is history (unused and deprecated for years), right?
>
> Yes, the former DiSEqC, etc. device. I only use it because it is is
> unused and I do not have to change anything in dvb-core this way.
> But trivial to change it or add ci0.
>
>
>  > How about the following:
>  > Rename it to ci0.  When ci0 is closed the stream is routed
>  > transparently from frontend through CI, if it's opened one needs to
>  > read/write the stream from userspace.
>
>
> You still need a mechanism to decide which tuner gets it. First one
> which opens its own ca device?
> Sharing the CI (multi-stream decoding) in such an automatic way 
> would also be complicated.
> I think I will only add such a feature if there is very high demand
> and rather look into the separate API solution.
>
>
>  > If you can't get responses here I guess you could talk to
>  > vdr or other application developers.  After all they'll have
>  > to use the API.
>
> I am in contact with some.
> Just wanted to check what people think about it on this list.
>
> Thanks for your comments.
>
>   
You might also want to check on mythtv-dev list, there was a guy (James 
Courtier-Dutton) who wanted to hack exactly this in mythtv. I guess he 
would have the user space point-of-view.
Hope you succeed, because having an independant CI would be perfect to 
enable real multirec for DVB cards by decoding after the fact.
Bye
Manu
