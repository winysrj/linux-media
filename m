Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep16.mx.upcmail.net ([62.179.121.36]:49315 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaG3Fdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 01:33:47 -0400
Message-ID: <1406697205.2591.13.camel@bjoern-W35xSTQ-370ST>
Subject: Re: ddbridge -- kernel 3.15.6
From: Bjoern <lkml@call-home.ch>
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Date: Wed, 30 Jul 2014 07:13:25 +0200
In-Reply-To: <53CAAF9D.6000507@kaiser-linux.li>
References: <53C920FB.1040501@grumpydevil.homelinux.org>
	 <53CAAF9D.6000507@kaiser-linux.li>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hello Rudy
> 
> I use a similar card from Digital Devices with Ubuntu 14.04 and kernel 3.13.0-32-generic. Support for this card was not build into the kernel and I had to compile it myself. I had to use media_build_experimental from Mr. Endriss.
> 
> http://linuxtv.org/hg/~endriss/media_build_experimental
> 
> Your card should be supported with this version.
> 
> Regards, Thomas

Hi Rudy,

What Thomas writes is absolutely correct...

This is unfortunately the worst situation I've ever run across in
Linux... There was a kernel driver that worked and was supported by
Digital Devices. Then, from what I read, changes to how the V4L drivers
have to be written was changed - Digital Devices doesn't like that and
they force users to use "experimental" builds which are the "old
style". 

This is total rubbish imo - if this is how it was decided that the
drivers have to be nowadays then adjust them. Why am I paying such a lot
of money others right, these DD cards are really not cheap?

Some attempts have been made by people active here to adapt the drivers
and make them work in newer kernels, but so far no one has succeeded.
Last attempt was in Jan 2014 iirc, since then - silence.

I wish I could help out, I can code but Linux is well just a bit more
"difficult" I guess ;-)

Cheers,
Bjoern

