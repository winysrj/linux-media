Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39512 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0CXWNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 18:13:35 -0400
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate03.web.de (Postfix) with ESMTP id 28397147C38CB
	for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 23:13:34 +0100 (CET)
Received: from [92.193.211.8] (helo=[192.168.2.4])
	by smtp05.web.de with asmtp (WEB.DE 4.110 #4)
	id 1NuYpR-0002Xi-00
	for linux-media@vger.kernel.org; Wed, 24 Mar 2010 23:13:34 +0100
Subject: Re: [linux-dvb] saa716x driver status
From: Martin Pauly <martinpauly@web.de>
To: linux-media@vger.kernel.org
In-Reply-To: <1269427550.2680.54.camel@localhost.localdomain>
References: <1269427550.2680.54.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 23:13:33 +0100
Message-ID: <1269468813.4428.3.camel@martin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 24.03.2010, 21:45 +1100 schrieb Rodd Clarkson:
> Hi All,
> 
> I've recently acquired a AverMedia Hybrid NanoExpress tv tuner and I'm
> trying to get it working with Fedora 13 and Fedora 12.
> 
> I've found drivers at http://www.jusst.de/hg/saa716x/
> 
> On f12 the driver build and install, but I have missing symbols when I
> try to modprobe the drivers.
> 
> On f13 the drivers fail to build.
> 
> I've tried contacting Manu Abraham (whom I believe is the developer)
> about the f12 issues, but haven't heard back.
> 
> I've searched google for everything from saa716x, AverMedia Hybrid Nano
> Express, HC82 and 1461:0555 (the pci address, I guess).  There's bits
> and pieces about this driver in the results, but most are that they can
> build the driver, but it doesn't work.
> 
> I'm happy to 'risk' my card and try stuff to get this to work, but I'm
> curious about whether or not development is ongoing and how I can help
> (not being a c coder)
> 
> I'll attach the output of the build attempt on f13 in case someone can
> advise what is going wrong.  The build log was captured using:
> 
> $ make &> /tmp/saa716x.build.log.f13
> 
> regards 
> 
> 
> Rodd
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi,
i have a avertv hybrid nano express over here and managed to solve some
build problems by copying some v4l files into the downloaded
directories. but after installation finished succesfully, the driver
unfortunately didnt work. so if you have any success please let me know
regards
martin


