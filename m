Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp08.wxs.nl ([195.121.247.22]:63790 "EHLO psmtp08.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbZKCPpM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 10:45:12 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp08.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KSJ004L0IFGFB@psmtp08.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 03 Nov 2009 16:45:16 +0100 (MET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by localhost (8.14.3/8.14.3/Debian-6) with ESMTP id nA3FjFLD002255	for
 <linux-media@vger.kernel.org>; Tue, 03 Nov 2009 16:45:16 +0100
Date: Tue, 03 Nov 2009 16:45:15 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Trying to compile for kernel version 2.6.28
To: linux-media@vger.kernel.org
Message-id: <4AF0500B.3070401@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At this moment, I cannot figure out how to compile v4l with kernel 
version 2.6.28.
I see, however, that the daily build reports:
linux-2.6.28-i686: OK

I have the same problem as in the old message:
http://www.spinics.net/lists/linux-media/msg10047.html
I have included the text of that message below.

How do I revert the latest changepatch to videobuf-dma-config ?


And could somebody preferably put  a kernel-version-dependent #if around 
that changepatch ?


-------------------

>/ /
>/ Then I made it here:/
>/ /
>/   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-core.o/
>/   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-sg.o/
>/   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o/
>/ /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c: In function/
>/ 'videobuf_dma_contig_user_get':/
>/ /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c:164: error:/
>/ implicit declaration of function 'follow_pfn'/
>/ make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o] Error 1/
>/ make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2/
>/ make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'/
>/ make[1]: *** [default] Error 2/
>/ make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'/
>/ make: *** [all] Error 2/
>/ /
>/ Its kinda annoying that a year ago this was super easy.../
>/ /
>/ I dont really want to bump up to 2.6.31 seeing it just came out a few days ago./

Ok, this is the usual backport issues we have every time we need to backport patches upstream. This should be solved soon, but currently my priority is to merge the pending patches at the tree. Up to then, you may do a:
	make menuconfig

and select only the drivers you need, or just revert the latest changepatch to videobuf-dma-config.




Cheers,
Mauro

