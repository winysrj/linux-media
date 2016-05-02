Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbcEBHG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2016 03:06:28 -0400
Date: Mon, 2 May 2016 09:06:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160502070626.GD13215@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <20160427164529.GB11779@amd>
 <20160427165928.GB8156@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160427165928.GB8156@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> On Wed, Apr 27, 2016 at 06:45:29PM +0200, Pavel Machek wrote:
> > > I don't have pre-production N900s. The phone I use for development
> > > is HW revision 2101 with Finish keyboard layout. Apart from that
> > > I have my productive phone, which is rev 2204 with German layout.
> > 
> > How do you check hw revision?
> 
> 0xFFFF tells you the HW revision (e.g. when executed with -I, but
> also during normal kernel loading operation). Apart from that there
> is /proc/cpuinfo.

/proc/cpuinfo says revision : 0000. 0xFFFF says:

Initializing NOLO...
Device: RX-51
HW revision: 2101
NOLO version: 1.4.14

... So I seem to have 2101. Ok, and the prepared initrd seems to work
for me. (Thanks!)

length: 640256 offset: 4501504 timestamp type: monotonic
Buffer 7 mapped at address 0xb68fb000.
Press enter to start capture

0 (0) [-] 0 640256 bytes 532.452761 532.452913 28.544 fps
1 (1) [-] 1 640256 bytes 532.518129 532.518221 15.298 fps

/camera$ ./yavta --capture=8 --pause --skip 0 --format UYVY --size
656x488 /dev/video6 --file=/tmp/delme#
/camera$ md5sum /tmp/delme*
541b8dfeab4f56824274aa7b61c88dcf  /tmp/delme000000
9b685af72dedd12ed519bdc68475e671  /tmp/delme000001
67128a3af14be16c94f7e26c365f2b21  /tmp/delme000002
0d411d0052710b15af05b6a7e51a43f1  /tmp/delme000003
74a44a4a0f33354b86af6e419e624308  /tmp/delme000004
38842dc2e7cdc1163012f4811f2c293c  /tmp/delme000005
78b88cfe381560fd6e3b8647ec553f10  /tmp/delme000006
58d0fc91cc0d1d3cee1a900eb8ee5094  /tmp/delme000007

So yes, it seems to work here. At least as a random generator :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
