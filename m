Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:56337 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab0AFUVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 15:21:43 -0500
Date: Wed, 6 Jan 2010 21:21:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a
Message-ID: <20100106212140.11b02d0f@hyperion.delvare>
In-Reply-To: <4B44E026.3060906@aster.pl>
References: <4B324EF0.7090606@aster.pl>
	<20100106153909.6bce3183@hyperion.delvare>
	<4B44CF62.5060405@aster.pl>
	<20100106194059.061636d3@hyperion.delvare>
	<4B44E026.3060906@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 06 Jan 2010 20:10:30 +0100, Daro wrote:
> W dniu 06.01.2010 19:40, Jean Delvare pisze:
> > On Wed, 06 Jan 2010 18:58:58 +0100, Daro wrote:
> >    
> >> It is not the error message itself that bothers me but the fact that IR
> >> remote control device is not detected and I cannot use it (I checked it
> >> on Windows and it's working). After finding this thread I thought it
> >> could have had something to do with this error mesage.
> >> Is there something that can be done to get my IR remote control working?
> >>      
> > Did it ever work on Linux?
> 
> I have no experience on that. I bought this card just few weeks ago and 
> tried it only on Karmic Koala.

OK.

You could try loading the saa7134 driver with option card=146 and see
if it helps.

-- 
Jean Delvare
