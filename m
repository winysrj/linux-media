Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:50429 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbZICVbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 17:31:55 -0400
Date: Thu, 3 Sep 2009 23:32:26 +0200
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@redhat.com>,
	linux-media@vger.kernel.org,
	Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
Message-ID: <20090903213226.GF7962@aniel.lan>
References: <200909011019.35798.jarod@redhat.com>
 <1251855051.3926.34.camel@palomino.walls.org>
 <4A9DE5FE.8060409@wilsonet.com>
 <4A9F38EE.7020104@wilsonet.com>
 <1251978607.22279.36.camel@morgan.walls.org>
 <30AAA297-A772-40B1-8C03-441CC6D3C5BC@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30AAA297-A772-40B1-8C03-441CC6D3C5BC@wilsonet.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 03, 2009 at 04:02:12PM -0400, Jarod Wilson wrote:
> On Sep 3, 2009, at 7:50 AM, Andy Walls wrote:
> 
> >> Hrm. A brief google search suggests the 1250 IR part isn't enabled. I
> >> see a number of i2c devices in i2cdetect -l output, but none that say
> >> anything about IR... I could just plug the hdpvr in there and see  
> >> what
> >> happens, I suppose...
> >
> > You should try that.  It was an issue of legacy I2C driver probing  
> > that
> > caused the hdpvr module to have problems.  The cx18 driver simply
> > stimulated the i2c subsystem to do legacy probing (via the tuner  
> > modules
> > IIRC)?  See the email I sent you.
> 
> So from what I can tell, the i2c changes in 2.6.31 *should* prevent  
> that from happening, and now that I've got everything working on  
> 2.6.31 too, I'll try hooking up my hdpvr to my box w/an hvr-1250,  
> hvr-1800 and pchdtv hd-3000 in it and see what blows up (hopefully  
> nothing...).

We still need something to prevent it from happening with older kernels.
Easiest solution would be to disable it for 2.6.30 and earlier.

Janne
