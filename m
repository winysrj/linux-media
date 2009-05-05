Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55868 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZEEB4L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2009 21:56:11 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M19tC-0004JN-4m
	for linux-media@vger.kernel.org; Tue, 05 May 2009 01:56:10 +0000
Received: from alltalk.demon.co.uk ([80.177.3.49])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 May 2009 01:56:10 +0000
Received: from drbob by alltalk.demon.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 May 2009 01:56:10 +0000
To: linux-media@vger.kernel.org
From: drbob <drbob@gmx.co.uk>
Subject: Re: EC168 "dvb_usb: Unknown symbol release_firmware"
Date: Tue, 5 May 2009 01:55:59 +0000 (UTC)
Message-ID: <gto6be$f0e$1@ger.gmane.org>
References: <gtnj58$p21$2@ger.gmane.org> <49FF7BAD.7010108@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 04 May 2009 19:35:09 -0400, CityK wrote:

> drbob,
> 
> Off_Topic: that name takes me back: http://muppet.wikia.com/wiki/Dr._Bob

And I thought I'd picked that name at random. The muppets must have had a 
deeper effect on my subconscious than I realised...

> 
> On_Topic:  You have built the drivers but you haven't installed them
> into the system as intended, consequently you will run into the set of
> observations that you have.  Have a read through:
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain%
2C_Build_and_Install_V4L-DVB_Device_Drivers

Thanks for the link. It put me on the right track. I needed to load the 
"firmware-class" kernel module before dvb-usb - modprobe resolves module 
dependencies automatically, insmod does not. dvb-usb also relies on 
i2c_core but that was already loaded on my system.

So to manually load the ec168 modules I need to execute:

sudo modprobe firmware-class

Bdefore the the insmod commands.

For testing purposes I wanted to explicity load the new modules with 
insmod rather than install them and overwrite all the modules included 
with the kernel, which I know have been passed as stable. That seemed 
more sensible than the course of action suggested by the wiki article.


