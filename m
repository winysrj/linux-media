Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484AbZFCKDh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 06:03:37 -0400
Message-ID: <4A264A78.5060602@gmx.de>
Date: Wed, 03 Jun 2009 12:03:36 +0200
From: "Soeren D. Schulze" <soeren.d.schulze@gmx.de>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Aspect ratio change does not take effect (DVB-S)
References: <4A259071.3070500@gmx.de> <alpine.DEB.2.01.0906030752150.5194@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.01.0906030752150.5194@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BOUWSMA Barry schrieb:
> Moin Sören,
> 
> On Tue, 2 Jun 2009, Soeren D. Schulze wrote:
> 
>> right now, but there seems to be a little bug:  When watching the TV
>> stream using and szap and mplayer, changes in the aspect ratio of the TV
>> program do not take effect until mplayer is restarted.  This used to
>> work with the former device!
> 
> This should be an issue with `mplayer' -- the aspect ratio is
> simply part of the datastream sent as an MPEG transport stream
> as encoded by the broadcaster.
> 
> `mplayer' is known to have this issue with the option `-vc mpeg12'
> while in recent mplayer, the default is `-vc ffmpeg12' where this
> aspect ratio switching works properly.  Try adding that latter
> option and see if it works as expected.

Gotcha.  It works.  Thanks again.


Sören
