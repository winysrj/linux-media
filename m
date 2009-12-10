Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33365 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761047AbZLJQeU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 11:34:20 -0500
Subject: Re: [PATCH] uvcvideo: add another YUYV format GUID
From: Daniel Ritz <daniel.ritz@gmx.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200912100246.27827.laurent.pinchart@ideasonboard.com>
References: <1259711324.13720.20.camel@MacRitz2>
	 <200912032115.30431.laurent.pinchart@ideasonboard.com>
	 <1259892337.2335.34.camel@MacRitz2>
	 <200912100246.27827.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 17:34:25 +0100
Message-ID: <1260462865.2138.8.camel@MacRitz2>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-10 at 02:46 +0100, Laurent Pinchart wrote:
> Hi Daniel,
> 
> On Friday 04 December 2009 03:05:37 Daniel Ritz wrote:
> > Hi Laurent
> > 
> > On Thu, 2009-12-03 at 21:15 +0100, Laurent Pinchart wrote:
> > > Hi Daniel,
> > >
> > > On Wednesday 02 December 2009 00:48:44 Daniel Ritz wrote:
> > > > For some unknown reason, on a MacBookPro5,3 the iSight
> > >
> > > Could you please send me the output of lsusb -v both with the correct and
> > > wrong GUID ?
> > 
> > sure. i attached three files:
> >   isight-good.txt, isight-bad.txt, isight-good2.txt
> > 
> > this is three reboots in a row from like 10 minutes ago. the first
> > boot into linux was actually rebooting from OSX...first cold boot
> > today directly into linux had the right GUID.
> 
> Thanks. diff'ing the descriptors shows something interesting (from good to 
> good2):
> 
> @@ -264,7 +264,7 @@
>          dwMaxVideoFrameBufferSize      614400
>          dwDefaultFrameInterval         333333
>          bFrameIntervalType                 11
> -        dwFrameInterval( 0)         3758429717
> +        dwFrameInterval( 0)            333333
>          dwFrameInterval( 1)            363636
>          dwFrameInterval( 2)            400000
>          dwFrameInterval( 3)            444444
> 
> 3758429717 is 0xe0051615 in hex, and 333333 is 0x00051615.
> 
> I wonder what other parts of the descriptors could get corrupted that way.

hmm..dunno..but even with this it just worked. 

> 
> > > > _sometimes_ report a different video format GUID.
> > >
> > > Sometimes only ? Now that's weird. Is that completely random ?
> > 
> > yes, sometimes only. it seems to be related to reboots, but i don't
> > know what exactly triggers it. rmmod/modprobe doesn't trigger it.
> > also, when the wrong GUID is reported, the only way of fixing it is
> > to reboot. it really is just the GUID. even when the wrong one is
> > reported, the device works just fine.
> > 
> > i started with a plain ubuntu 9.10, kernel 2.6.31 which was supposed
> > to fail, so i upgraded to a 2.6.32-rc8 to fix the iSight and some other
> > things, just to see it fail again. a reboot later and it worked, some
> > time and reboot later it failed again...
> 
> All of those are warm reboots, and you don't boot any alternative OS in-
> between, right ?

yes, linux only.

> 
> Does Linux reload the iSight firmware at every boot ? If it does, could you 
> try to reload the firmware manually when you get a "bad" GUID to see if it 
> helps ? You will probably need to unload the uvcvideo driver before reloading 
> the firmware.
> 
linux does not load isight firmware at all. the new macbooks don't 
require to load FW the device just "works".
FW loading is only required for the devices with ID 0x05AC:0x8300,
what i have is 05ac:8507....

rgds
-daniel


