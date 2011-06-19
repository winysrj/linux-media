Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44189 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1FSMmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 08:42:54 -0400
Received: by wwe5 with SMTP id 5so1746776wwe.1
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 05:42:53 -0700 (PDT)
Subject: Re: dvb_usb symbols from media_build disagree on Linux 2.6.32-32
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4DFCF1C1.6090509@hoogenraad.net>
References: <4DFCF1C1.6090509@hoogenraad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 13:42:46 +0100
Message-ID: <1308487366.2095.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-06-18 at 20:43 +0200, Jan Hoogenraad wrote:
> Trying to compile and install media_build on an Ubuntu Lucid computer
> Linux 2.6.32-32-generic-pae #62-Ubuntu SMP Wed Apr 20 22:10:33 UTC 2011 
> i686 GNU/Linux
> 
> I can compile, but cannot use dvb-usb. With the snapshot of june 11th, I 
> was able to do this with no problem.
> Can somebody help me ?
> 
> sudo modprobe dvb-usb
> yields
> FATAL: Error inserting dvb_usb 
> (/lib/modules/2.6.32-32-generic-pae/kernel/drivers/media/dvb/dvb-usb/dvb-usb.ko): 
> Unknown symbol in module, or unknown parameter (see dmesg)
> 
Yes, I have had a similar problem with Ubuntu Natty 2.6.38-10

The solution is to rminstall using the old media_build before installing
the latest media_build. Otherwise, you will have to reinstall the latest
Ubuntu kernel.

For some reason an old dvb-usb(or dependants) module isn't being removed
with the latest media_build.

tvboxspy

