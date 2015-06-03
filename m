Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35616 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932559AbbFCOPY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:15:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Z09Rh-0005F8-IT
	for linux-media@vger.kernel.org; Wed, 03 Jun 2015 16:15:06 +0200
Received: from 190-1-59-90.bvconline.com.ar ([190-1-59-90.bvconline.com.ar])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 16:15:05 +0200
Received: from luciano.faletti by 190-1-59-90.bvconline.com.ar with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 03 Jun 2015 16:15:05 +0200
To: linux-media@vger.kernel.org
From: Luciano <luciano.faletti@hotmail.com>
Subject: Re: ISDB Dongle MyGica S2870
Date: Wed, 3 Jun 2015 03:43:38 +0000 (UTC)
Message-ID: <loom.20150603T053209-426@post.gmane.org>
References: <CACha5riDu2q1wztAny5he+s0W26rkY2_YuTZLNox7O2m8N=9UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicolas Antonio Corrarello <ncorrare <at> gmail.com> writes:

> 
> Hey Everyone,
> I just bought this new dongle, and while the parts seem to be
> supported, the usb id is not recognised.
> It seems to be based on the dibcom 0700 IC and it identifies itself as
> STK8096-PVR.
> 
> I tried the patch in
> http://www.spinics.net/lists/linux-media/msg63445.html on the latest
> linux media tree, but while the dib0700 module now loads
> automatically, I don't see anything on dmesg showing that its loading
> the firmware, and I most definitely don't get a /dev/dvb directory.
> 

Hi Nicolas,

Could you make this work?

I'm having the same results as you with the same device. Below is my output:

[  154.192777] usb 3-1: new high-speed USB device number 4 using xhci_hcd
[  154.209368] usb 3-1: New USB device found, idVendor=10b8, idProduct=1faa
[  154.209375] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  154.209379] usb 3-1: Product: STK8096-PVR
[  154.209382] usb 3-1: Manufacturer: Geniatech
[  154.209385] usb 3-1: SerialNumber: 1

Installed the latest drivers from the git repo.
Any help much appreciated.

Thanks,
Luciano

