Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:46235 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaDXL3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Apr 2014 07:29:25 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4J00BJI990VW30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Apr 2014 07:29:24 -0400 (EDT)
Date: Thu, 24 Apr 2014 08:29:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Daniel Exner <dex@dragonslave.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
Message-id: <20140424082919.66f7eab1@samsung.com>
In-reply-to: <5358279C.5060108@dragonslave.de>
References: <535823E6.8020802@dragonslave.de>
 <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
 <5358279C.5060108@dragonslave.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Apr 2014 22:50:36 +0200
Daniel Exner <dex@dragonslave.de> escreveu:

> Hi,
> 
> Am 23.04.2014 22:42, schrieb Devin Heitmueller:
> > On Wed, Apr 23, 2014 at 4:34 PM, Daniel Exner <dex@dragonslave.de> wrote:
> > You can get the firmware via the following procedure:
> > 
> > http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware
> > 
> > or if you're on Ubuntu it's already packaged in
> > linux-firmware-nonfree.  The file itself is 66220 bytes and has an MD5
> > checksum of 293dc5e915d9a0f74a368f8a2ce3cc10.
> 
> I used that procedure and have exactly that file in my /lib/firmware dir.
> 
> > Note that if you have that file in /lib/firmware, it's entirely
> > possible that the driver is just broken (this happens quite often).
> > The values read back by dmesg are from the device itself, so if the
> > chip wasn't properly initialized fields such as the version will
> > contain garbage values.
> On the page you linked above older firmware versions are mentions that
> should be supported by the driver.
> 
> My Question is: how to get them?
> 
> But you may be right, because "Device is Xceive 34584" seems also wrong
> (didn't find any hint such a device exists..)
> 
> I'm willing to invest some time to repair the driver.
> Anyone interested in helping me in getting this thing back to work?

That doesn't seem to be a driver issue, but a badly extracted
firmware. The firmware version should be 2.7. It the version doesn't
match, that means that the firmware was not properly loaded.

The driver checks if the firmware version loaded matches the version
of the file, and prints warnings via dmesg.

Are you sure that the md5sum of the firmware is 
293dc5e915d9a0f74a368f8a2ce3cc10?

-- 

Regards,
Mauro
