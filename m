Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32209 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaBYMRS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 07:17:18 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1J00277X3V6480@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Feb 2014 07:23:55 -0500 (EST)
Date: Tue, 25 Feb 2014 09:17:13 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Peter Fassberg <pf@leissner.se>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with PCTV Systems nanoStick T2 290e and frontends
Message-id: <20140225091713.10a4975a@samsung.com>
In-reply-to: <alpine.BSF.2.00.1402250918400.31790@nic-i.leissner.se>
References: <201402242314.s1ONEjtD003815@mailgate.leissner.se>
 <alpine.BSF.2.00.1402250918400.31790@nic-i.leissner.se>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Feb 2014 09:22:28 +0100 (SNT)
Peter Fassberg <pf@leissner.se> escreveu:

> 
> Hi!
> 
> I have an PCTV Systems nanoStick T2 290e.
> 
> It shows up very differently with different kernels, and it seems to work better (DVB-C support) in an OLDER kernel.
> 
> Old kernel is using em28xx and showing two frontends (as stated on the wiki docs). New kernel is using em28174

The driver is the same. The printed messages were improved: they now
prints the exact chipset name (em28174, on your case), instead of
em28xx (where "xx" is an alias for "whatever").

> and showing only a DVB-T frontend.

Is this device capable of streaming with both DVB-C and DVB-T at the same
time? E. g., does it have two separate frontend chips?

If not, then the driver is actually detecting the device right,
and it is likely exporting just one frontend with is capable of either
work with DVB-T or DVB-C (with is configurable via the DVBv5 API).

If you're using an application that only implements the legacy DVBv3 API,
then you can use the "dvb-fe-tool" tool (part of v4l-utils) to manually
switch between DVB-T2, DVB-T and DVB-C modes.

> 
> Is there a way to force the new kernel to use em28xx instead?
> 
> 
> Excerpt from log:
> 
> Using Linux debian 3.2.0-4-amd64 #1 SMP Debian 3.2.54-2 x86_64 GNU/Linux:
> 
> [   90.006701] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> [   90.007281] em28xx #0: chip ID is em28174
> [   90.333600] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
> [   90.377066] em28xx #0: v4l2 driver version 0.1.3
> [   90.447548] em28xx #0: V4L2 video device registered as video0
> [   90.447584] usbcore: registered new interface driver em28xx
> [   90.447586] em28xx driver loaded
> [   90.520717] tda18271 0-0060: creating new instance
> [   90.551187] TDA18271HD/C2 detected @ 0-0060
> [   91.341140] tda18271 0-0060: attaching existing instance
> [   91.341145] DVB: registering new adapter (em28xx #0)
> [   91.341150] DVB: registering adapter 0 frontend 0 (Sony CXD2820R (DVB-T/T2))...
> [   91.342477] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...

Yeah, from this log, it is clear that your device has only one frontend:
Sony CXD2820R. This frontend could be used for DVB-T/T2/C, but not at the
same time.

> [   91.345700] em28xx #0: Successfully loaded em28xx-dvb
> [   91.345706] Em28xx: Initialized (Em28xx dvb Extension) extension
> 
> 
> And from Linux debian 3.12-1-amd64 #1 SMP Debian 3.12.9-1 (2014-02-01) x86_64 GNU/Linux:
> 
> [207774.334552] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> [207774.334557] em28xx: DVB interface 0 found: isoc
> [207774.335059] em28xx: chip ID is em28174
> [207774.734814] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
> [207774.734821] em28174 #0: v4l2 driver version 0.2.0
> [207774.814336] em28174 #0: V4L2 video device registered as video0
> [207774.814341] em28174 #0: dvb set to isoc mode.
> [207774.823844] usbcore: registered new interface driver em28xx
> [207774.895574] tda18271 1-0060: creating new instance
> [207774.926952] TDA18271HD/C2 detected @ 1-0060
> [207775.290440] DVB: registering new adapter (em28174 #0)
> [207775.290453] usb 1-1: DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...

And the Sony frontend now is properly mapped as just one device.

> [207775.294597] em28174 #0: Successfully loaded em28xx-dvb
> [207775.294602] Em28xx: Initialized (Em28xx dvb Extension) extension
> 
> Linux debian 3.12-1-amd64 #1 SMP Debian 3.12.9-1 (2014-02-01) x86_64 GNU/Linux
> 
> 
> Best regards,
> 
> -- Peter
> 

Regards,
-- 

Cheers,
Mauro
