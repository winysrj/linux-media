Return-path: <linux-media-owner@vger.kernel.org>
Received: from csldevices.com ([77.75.105.137]:44563 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756585AbZKWLeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 06:34:22 -0500
Message-ID: <4B0A6CCE.8080506@csldevices.co.uk>
Date: Mon, 23 Nov 2009 11:06:54 +0000
From: Philip Downer <phil@csldevices.co.uk>
MIME-Version: 1.0
To: Stacey <cardcaptorstacey@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: V4L-DVB modules not loading
References: <4B09A834.3000309@gmail.com>
In-Reply-To: <4B09A834.3000309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stacey wrote:
> I've built the module okay. It installed correctly and copied the files
> into /lib/modules/2.6.31-14-generic/kernel/drivers/media/dvb/dvb-usb.
> After that I rebooted (since it was easier for me). Then I got to the
> "If the Modules load correctly" section to find that nothing has worked
> at all.
>
> I've checked my system log and it's recognising the USB device when I
> enter it but it isn't doing anything with it. The tutorial says you
> should be able to see the modules in /proc/modules but the modules
> folder doesn't even exist. The /dev/dvb/ folder has not been created
> either.

Could you post the output of dmesg (just run the command 'dmesg' from a 
terminal) to the list, that should give us an idea of what is going on. 
You might want to do this after a clean reboot (with the adapter plugged 
in) so that there isn't too much information to wade through.

Phil
