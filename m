Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:59357 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0ABJu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jan 2010 04:50:56 -0500
Date: Sat, 2 Jan 2010 10:50:52 +0100
From: Thierry Merle <thierry.merle@free.fr>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Cc: DUBOST Brice <dubost@crans.ens-cachan.fr>
Subject: Re: [linux-dvb] SheevaBox as a media Server and a Fit-PC as a
 streaming client?
Message-ID: <20100102105052.39a4d13f@gorbag.houroukhai.org>
In-Reply-To: <4B3E062E.3060709@crans.ens-cachan.fr>
References: <938B2714-17EB-476A-8EB0-5C42894E60DC@lollisoft.de>
	<d9def9db1001010622g7a3a6cafh759e4d1d9e17589a@mail.gmail.com>
	<4B3E062E.3060709@crans.ens-cachan.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le Fri, 01 Jan 2010 15:26:54 +0100,
DUBOST Brice <dubost@crans.ens-cachan.fr> a écrit :

> Markus Rechberger a écrit :
> > Hi,
> > 
> > On Wed, Dec 16, 2009 at 4:12 PM, Lothar Behrens
> > <lothar.behrens@lollisoft.de> wrote:
> >> Hi,
> >>
> >> I am new here and start with a setup question.
> >>
> >> The media or NAS server I think about: http://plugcomputer.org/
> >>
> >> It has a high speed USB 2.0 port and a gigabit Lan.
> >>
> > 
> > http://support.sundtek.com/index.php/topic,179.0.html (english)
> > http://support.sundtek.com/index.php/topic,178.0.html (german)
> > 
> > This might be interesting for you.
> > 
> > Markus
> > 
> 
> hello
> 
> MuMuDVB is reported to work fine on a sheevaplug
> 

I use my sheevaplug without any problem with a CinergyT2, and I know
someone who runs with an empia-based hybrid tuner (Terratec Cinergy
hybrid XS)
The main bottleneck of the sheevaplug and all ARMv5TE compliant
processors is the lack of FPU, if you have to do transcoding stuff
(mpeg4->mpeg2 for example) before streaming. To my mind the 'TE'
extension should be used for such transcoding but this is off topic.

Otherwise, it is perfect to host a streaming server like vlc or
MuMuDVB, to stream untouched video frames coming from DVB tuners.

Cheers,
Thierry
