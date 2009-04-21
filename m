Return-path: <linux-media-owner@vger.kernel.org>
Received: from studserv.stud.uni-hannover.de ([130.75.176.2]:57225 "EHLO
	studserv.stud.uni-hannover.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbZDUQAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 12:00:09 -0400
Message-ID: <20090421175958.114064f4lhh5szum@www.stud.uni-hannover.de>
Date: Tue, 21 Apr 2009 17:59:58 +0200
From: Soeren.Moch@stud.uni-hannover.de
To: linux-media@vger.kernel.org
Subject: Re: Nova-TD usb dual tuner issue
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> When I connect my Nova-TD dual tuner usb stick to my debian/sid box with
> 2.6.29.1 kernel I can only use the second tuner (mplayer
> dvb://2@<tvchannel>). When trying to use the first one (dvb://1...@...)
> tuning is extremely bad and an image barely appears with many errors.
>
> I tried switching the antennas to no avail, the problem persists.
>
> Is this a know problem, or do I just have a bad stick ?

Due to my experience the gain and frequency response of the internal  
amplifiers at both antenna inputs is different, so the same antenna  
can work fine at one port and not so good at the other, at least for  
some channel. I had problems with strong antenna signals, so I used an  
attenuator to improve reception.

HTH,
Soeren


