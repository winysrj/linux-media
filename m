Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47399 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZDXAGF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 20:06:05 -0400
Subject: Re: recommendation for hd atsc usb device?
From: Andy Walls <awalls@radix.net>
To: b3782802@columbus.rr.com
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <20090423114955.724f5b48.b3782802@columbus.rr.com>
References: <gspqam$n8a$1@ger.gmane.org>
	 <412bdbff0904230647x8eb2b34u5ddebba380e70ade@mail.gmail.com>
	 <gspu0p$b54$1@ger.gmane.org>
	 <20090423114955.724f5b48.b3782802@columbus.rr.com>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 21:07:12 -0400
Message-Id: <1240535232.3231.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-04-23 at 11:49 -0400, b3782802@columbus.rr.com wrote:
> Neal Becker wrote:
> 
> > My ATSC reception is marginal.  
> > Are there any recommendations for devices that give better ATSC performance (I 
> > think the main issue in my location is multipath)
> 
> Yes! 
> 
> Get a highly directional antenna. 
> A big honkin' UHF Yagi[1] should do the trick. 
> Better yet, mount it high (like on a chimney). 
> Better yet, use an antenna rotor[2]. 
> 
> [1] http://en.wikipedia.org/wiki/Yagi_antenna
>     E.g. http://www.radioshack.com/product/index.jsp?productId=2417011
> [2] http://en.wikipedia.org/wiki/Antenna_rotor


Well, be advised that when the US DTV transition is complete, some
stations will have moved back to VHF allocations.  You'll need more than
a UHF antenna.

As far as improving signal goes:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

And Winegard sells some good antenna amplifiers.  Just remember, too
much amplification can overdrive the front end of tuners and the
intermodulation products that result will be equivalent to a rise in
noise.  Also, FM radio stations that are very strong in your antenna
beam will show up as a herring-bone pattern (and thus noise) on analog
TV stations on channels in the high-VHF and UHF bands.

It's best to install your antenna and antenna amp and ajdust the FM trap
while analog stations still are broadcasting so you can see gradual
visual effects due to over-amplification on analog stations and correct
them.

-Andy


