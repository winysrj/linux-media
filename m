Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:47553 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbZBSIxU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 03:53:20 -0500
Date: Thu, 19 Feb 2009 09:51:09 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Manu <eallaud@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Re : Re : TT 3650
Message-ID: <20090219095109.7cbe2c49@free.fr>
In-Reply-To: <1234999838.7508.0@manu-laptop>
References: <20090218092217.232120@gmx.net>
	<20090218103353.64bf6400@free.fr>
	<1234961317.5755.0@manu-laptop>
	<20090218204455.19b867a0@free.fr>
	<1234999838.7508.0@manu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 19:30:37 -0400
Manu <eallaud@gmail.com> wrote:

> Le 18.02.2009 15:44:55, Jean-Francois Moine a écrit :
> > Yes. I use it to look at FTA channels on AB3 5°W:
> > 
> > - France 24 (12674.00 H - DVB-S2 - QPSK) is good.
> > 
> > - I can also get the transponder 11636.00 V (DVB Newtec - QPSK), but
> > not
> >   the transponder 11139.00 V (DVB Newtec - 8PSK turbo) 
> > 
> > - For some time, there were clear channels (M6 and W9) in the
> >   transponder 11471.00 V (DVB-S2 - 8PSK). Both were fine.
> 
> Just to make things clear, can you prodvide symbol rate and FEC for
> all these transponders.

I don't understand the question!

I think the symbol rate is mandatory, but the FEC may found
automatically. For example, I use vlc for the 2 different transponders:

#EXTINF:0,orange
#EXTVLCOPT:dvb-frequency=11512000
#EXTVLCOPT:dvb-srate=29947000
#EXTVLCOPT:dvb-voltage=13
dvb://
#EXTINF:0,france
#EXTVLCOPT:dvb-frequency=11590000
#EXTVLCOPT:dvb-srate=20000000
#EXTVLCOPT:dvb-voltage=13
dvb://

The first transponder is FEC 7/8, and the second 2/3.

For the other transponders (DVB-S2 / 8PSK), if use szap-s2 + dvbstream.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
