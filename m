Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:48652 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab1CQVaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 17:30:03 -0400
Date: Thu, 17 Mar 2011 22:29:54 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: add dvb-t fr-All frequency
Message-ID: <20110317222954.6e6a66d2@mat-laptop>
In-Reply-To: <AANLkTik8A3XftMuSm=rZ=GYQaJJKXqnQ=N2gQq3EA6Lb@mail.gmail.com>
References: <4D7FC1F8.4090101@free.fr>
	<AANLkTik8A3XftMuSm=rZ=GYQaJJKXqnQ=N2gQq3EA6Lb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le Wed, 16 Mar 2011 16:46:38 +0100,
Christoph Pfister <christophpfister@gmail.com> a écrit :

> 2011/3/15 matthieu castet <castet.matthieu@free.fr>:
> > Hi,
> >
> > can this file be added to dvb-apps/util/scan/dvb-t
> 
> No. Use "auto-Normal" [1] (or the +-167kHz file if needed).
> 
Ok, thanks I wasn't aware of the auto files.

How does the offset version works ?
The scan tools is clever enough to not duplicate freq, freq-offset,
freq+offset and choose the one with best signal ?

BTW in theory in France, offset can be :  - 0,166 MHz /+ 0,166
MHz /+ 0,332 MHz /+ 0,498 MHz.

Matthieu
