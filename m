Return-path: <mchehab@pedra>
Received: from relay01.digicable.hu ([92.249.128.189]:37345 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0JQOhs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 10:37:48 -0400
Message-ID: <4CBB0A36.6000000@freemail.hu>
Date: Sun, 17 Oct 2010 16:37:42 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Marius_Bj=F8rnstad?= <pmb@fa2k.net>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx in v4l-dvb destroyed my USB TV card
References: <4CBAF4BD.20906@fa2k.net>
In-Reply-To: <4CBAF4BD.20906@fa2k.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
Marius Bjørnstad wrote:
> A problem with the em28xx driver was brought up in June by Thorsten
> Hirsch: http://www.spinics.net/lists/linux-media/msg20588.html . I also
> have a "TerraTec Cinergy Hybrid T USB XS". When I used my device with
> Linux, it would take a long time to be recognised by the OS, and this
> would get worse. At this point, the device is not recognised, and almost
> completely dead.
> 
> When I plug it in, I get errors like
> ---------------------------------------------
> Oct 17 14:34:55 muon kernel: [ 7111.324875] hub 1-1:1.0: unable to
> enumerate USB device on port 2
> Oct 17 14:34:55 muon kernel: [ 7111.580618] hub 1-1:1.0: unable to
> enumerate USB device on port 2
> Oct 17 14:34:55 muon kernel: [ 7111.840481] hub 1-1:1.0: unable to
> enumerate USB device on port 2
> Oct 17 14:34:55 muon kernel: [ 7112.092358] hub 1-1:1.0: unable to
> enumerate USB device on port 2
> ----------------------------------------------
> and these keep coming until the device is removed. The device is also
> not available in windows.

The "unable to enumerate USB device on port ..." error message usually means that
the USB hardware what you connect itself is damaged. At that time the v4l-dvb driver
is not yet started, only the low level USB enumeration is running. It is also possible
that the USB cable causes the problem, if any. I had an USB device which had wrong
soldering and that one gave the same error message. That device was degraded as time
passed.

You might want to try the device on different USB port, different USB cable, or even
on different computer to see exactly which hardware component is not working properly.

	Márton Németh

