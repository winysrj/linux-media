Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:63190 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab1AHLYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 06:24:14 -0500
From: "Daniel O'Connor" <darius@dons.net.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Date: Sat, 8 Jan 2011 21:26:23 +1030
Subject: Failure to build media_build
To: linux-media@vger.kernel.org
Message-Id: <771EA60D-3B3B-4C28-AD20-2CADDF57E26E@dons.net.au>
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I am trying to build using media_build to see if head has resolved an issue with my dual tuner card (ie only one works) however I get the following..
[mythtv 20:48] ~/media_build >./build.sh
***********************************************************
* This script will download the latest tarball and build it
* Assuming that your kernel is compatible with the latest  
[snip]
  CC [M]  /home/myth/media_build/v4l/firedtv-dvb.o
  CC [M]  /home/myth/media_build/v4l/firedtv-fe.o
  CC [M]  /home/myth/media_build/v4l/firedtv-1394.o
/home/myth/media_build/v4l/firedtv-1394.c:22:17: error: dma.h: No such file or directory
/home/myth/media_build/v4l/firedtv-1394.c:23:21: error: csr1212.h: No such file or directory
/home/myth/media_build/v4l/firedtv-1394.c:24:23: error: highlevel.h: No such file or directory
/home/myth/media_build/v4l/firedtv-1394.c:25:19: error: hosts.h: No such file or directory

etc...

I don't need/want 1394 (I am testing a cx23885 FusionHDTV) but I don't know how to disable them :(

I tried make config but I have no idea what the "usual" answers would be.. Is there a way to generate a file of the default options which I can review and edit?

Thanks

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






