Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp115.rog.mail.re2.yahoo.com ([68.142.225.231]:38032 "HELO
	smtp115.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752003AbZBVUdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 15:33:14 -0500
Message-ID: <49A1B688.6040909@rogers.com>
Date: Sun, 22 Feb 2009 15:33:12 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: Jonathan Isom <jeisom@gmail.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Michele <aspeltami@gmail.com>, linux-media@vger.kernel.org
Subject: Re: firmware
References: <200902152115.58993.aspeltami@gmail.com> <4999A9A6.2080809@rogers.com> <1767e6740902161024y2820036dhcd461c40edf30e82@mail.gmail.com> <200902170944.37882.zzam@gentoo.org>
In-Reply-To: <200902170944.37882.zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matthias Schwarzott wrote:
> Btw. I also had a longer look at the firmeware page in wiki and removed that 
> note about gentoo using hotplug-scripts as that is false since a long time. 
> CityK you are right, I think most (if not all) current distributions use udev 
> to create device nodes and upload firmware into the kernel.
>
>
> Yes this ebuild is there. But it is in some respect outdated, due to lack of 
> maintaining. This ebuild fetches the original files get_dvb_firmware also 
> fetches and the runs get_firmware to unpack them. (All this due to 
> license/re-distribution issues as you all know).
>   
Okay, thanks Matthias.

> But: These URLs tend to no longer work after some time, as manufacturers 
> update their drivers or web-pages :(
>
> So there should either be someone continuously updating them (in 
> get_dvb_firmware and also here in copy).
> Or: We find someone ignoring the licenses and hosting the extracted files 
> somewhere.
>
> Regards
> Matthias

I think we are stuck with the former.  But, fortunately, it looks like
schollsky is willing to be the point man :)
