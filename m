Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:37996 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZFRTWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 15:22:42 -0400
Subject: Re: ok more details: Re: bttv problem loading takes about several
	minutes
From: hermann pitton <hermann-pitton@arcor.de>
To: Halim Sahin <halim.sahin@t-online.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
In-Reply-To: <20090618140129.GA13370@halim.local>
References: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl>
	 <20090618140129.GA13370@halim.local>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 21:21:44 +0200
Message-Id: <1245352904.3924.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 18.06.2009, 16:01 +0200 schrieb Halim Sahin:
> Hi,
> you can see at my dmesg output
> [ 2282.430209] bttv: driver version 0.9.18 loaded
> 
> i have done
> hg clone http://linuxtv.org/hg/v4l-dvb
> cd v4l-dvb
> make && make install 
> reboot
> No idea why I don't have the audiodev modparam?
> Regards
> Halim
> 

Halim, we should get that in sync.

parm:           autoload:obsolete option, please do not use anymore (int)
parm:           audiodev:specify audio device:
                -1 = no audio
                 0 = autodetect (default)
                 1 = msp3400
                 2 = tda7432
                 3 = tvaudio (array of int)
parm:           saa6588:if 1, then load the saa6588 RDS module, default (0) is to use the card definition.
parm:           no_overlay:allow override overlay default (0 disables, 1 enables) [some VIA/SIS chipsets are known to have problem with overlay] (int)

Hopefully we don't need to fall back on Konfuzius for it ;)

Cheers,
Hermann



