Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55040 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1AHMYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:24:03 -0500
Received: by wwa36 with SMTP id 36so19335690wwa.1
        for <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 04:24:01 -0800 (PST)
Subject: Re: Failure to build media_build
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Daniel O'Connor <darius@dons.net.au>
Cc: linux-media@vger.kernel.org
In-Reply-To: <771EA60D-3B3B-4C28-AD20-2CADDF57E26E@dons.net.au>
References: <771EA60D-3B3B-4C28-AD20-2CADDF57E26E@dons.net.au>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Jan 2011 12:23:56 +0000
Message-ID: <1294489436.2467.2.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-08 at 21:26 +1030, Daniel O'Connor wrote:
> Hi,
> I am trying to build using media_build to see if head has resolved an issue with my dual tuner card (ie only one works) however I get the following..
> [mythtv 20:48] ~/media_build >./build.sh
> ***********************************************************
> * This script will download the latest tarball and build it
> * Assuming that your kernel is compatible with the latest  
> [snip]
>   CC [M]  /home/myth/media_build/v4l/firedtv-dvb.o
>   CC [M]  /home/myth/media_build/v4l/firedtv-fe.o
>   CC [M]  /home/myth/media_build/v4l/firedtv-1394.o
> /home/myth/media_build/v4l/firedtv-1394.c:22:17: error: dma.h: No such file or directory
> /home/myth/media_build/v4l/firedtv-1394.c:23:21: error: csr1212.h: No such file or directory
> /home/myth/media_build/v4l/firedtv-1394.c:24:23: error: highlevel.h: No such file or directory
> /home/myth/media_build/v4l/firedtv-1394.c:25:19: error: hosts.h: No such file or directory
> 
> etc...
> 
> I don't need/want 1394 (I am testing a cx23885 FusionHDTV) but I don't know how to disable them :(
> 
> I tried make config but I have no idea what the "usual" answers would be.. Is there a way to generate a file of the default options which I can review and edit?
> 
> Thanks
> 

edit v4l/.config and change firedtv to n.



