Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42572 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2BOR3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 12:29:45 -0500
Received: by wgbdt10 with SMTP id dt10so1155194wgb.1
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2012 09:29:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Wed, 15 Feb 2012 11:29:44 -0600
Message-ID: <CABcw_OmQEV2K0Hgvnh7xtCNQUmf5pa4ftZJwRFdkM68Hftp=Rg@mail.gmail.com>
Subject: OMAP CCDC with sensors that are always on...
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maybe this is more of a OMAP specific question, but I'm using a
beagleboard-xm with a custom image sensor on a 3.0.17 kernel.

Everything configures ok with:

media-ctl -r
media-ctl -l '"xrtcam 2-0048":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -f '"xrtcam 2-0048":0 [Y8 640x1440]'
media-ctl -f '"OMAP3 ISP CCDC":1 [Y8 640x1440]'
media-ctl -e 'OMAP3 ISP CCDC output'

root@beagleboard:~# ./setup.sh
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
Setting up format Y8 640x1440 on pad irtcam 2-0048/0
Format set: Y8 640x1440
Setting up format Y8 640x1440 on pad OMAP3 ISP CCDC/0
Format set: Y8 640x1440
Setting up format Y8 640x1440 on pad OMAP3 ISP CCDC/1
Format set: Y8 640x1440
/dev/video2

But when I go to capture, with:
yavta -c2 -p -F --skip 0 -f Y8 -s 640x1440 /dev/video2

I don't seem to get any interrupts.  Actually I get some HS_VS_IRQ
after I launch yavta, but before I press return at the "Press enter to
start capture" prompt.  After that, I don't believe I am getting any
interrupts.

The one problem I see is that my sensor is always spewing data into
the CCDC on HS,VS, PCLK, and D0 to D7.

I know I have been told with other sensors that I need to only turn
XCLK on to the sensor when I am capturing.

Could this be my problem here?  What exactly happens if you are always
sending data?  Does the ISP get hung up?

Thanks for any pointers,
Chris
