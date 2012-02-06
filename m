Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63904 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2BFCdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 21:33:11 -0500
Received: by eekc14 with SMTP id c14so2002260eek.19
        for <linux-media@vger.kernel.org>; Sun, 05 Feb 2012 18:33:09 -0800 (PST)
Message-ID: <4F2F3BE1.7030801@gmail.com>
Date: Mon, 06 Feb 2012 03:33:05 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andrej Podzimek <andrej@podzimek.org>
CC: linux-media@vger.kernel.org
Subject: Re: AverTV Volar HD PRO
References: <4F2F145C.6000405@podzimek.org>
In-Reply-To: <4F2F145C.6000405@podzimek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 06/02/2012 00:44, Andrej Podzimek ha scritto:
> Hello,
> 
> this USB stick (07ca:a835) used to work fine with the 3.0 and 3.1 kernel
> series, using one of the howtos in this thread:
> http://forum.ubuntu-it.org/index.php/topic,384436.msg3370690.html
> 
> However, there were some build errors with my current kernel 3.2.4, so I
> tried to update the entire media tree instead, as described here:
> http://git.linuxtv.org/media_build.git
> 
> Unfortunately, the device doesn't work. These are the dmesg messages
> that appear after plugging the receiver in:
> 
> 
> Surprisingly, the tda18218 module doesn't load automatically (I guess it
> should) and loading it manually doesn't help. So the device doesn't get
> initialized at all and there are no messages about firmware loading.
> (The firmware file is in /lib/firmware, of course.)
> 
> Is it possible to make the device work somehow? The receiver worked fine
> with older kernels (using the howto from ubuntu-it.org linked above) and
> the remote controller was usable as well.
> 

Hi Andrej,
here you can find an updated version of the af9035 patch:

http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob_plain;f=recipes/linux/linux-etxx00/dvb-usb-af9035.patch;hb=HEAD

There are several improvements, including support for newer kernels (3.2
and 3.3) as well as the current media_build tree.
I also added the missing "select" directives for the tda18218 and
mxl5007T tuners, so the modules auto-loads correctly now.

In this version there is no remote support.

Please let me know if it works fine for you.

Regards,
Gianluca
