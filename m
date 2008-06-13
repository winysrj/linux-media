Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1K7CtM-0002cJ-64
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 19:16:49 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K2E002YRVYXPX60@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 13 Jun 2008 13:16:10 -0400 (EDT)
Date: Fri, 13 Jun 2008 13:16:08 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080613163914.GA31437@opus.istwok.net>
To: David Engel <david@istwok.net>
Message-id: <4852AB58.9010806@linuxtv.org>
MIME-version: 1.0
References: <20080613163914.GA31437@opus.istwok.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] A couple HVR-1800 questions
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

David Engel wrote:
> Hi,

Hi David,

> 
> Due to limited PCI slots, I'm thinking of getting a Hauppauge HVR-1800
> card when I do some hardware upgrades on my MythTV backend.  I have a
> couple of questions regarding the 1800 that I hope someone can answer.

:)

> 
> First, what is the status of the analog capture capability?  My search
> of the mailing list archives indicates that it was sort of working but
> the driver work was not complete.  In addition, from checking the
> Mercurial logs, it doesn't look like much new development has been
> done since January.

The analog encoder is running with the tree form linuxtv.org. It has 
some cleanup video ioctl2 rework going on by another dev here, but it's 
functional as is. It's usable today.

> 
> Second, as far as I can tell, the hardware can perform simultaneous
> analog and digital captures.  Is that correct and, if so, does/will
> the Linux driver support it?

Yes and yes.

Typically the analog video devices are exposed as /dev/video0 (analog 
preview) /dev/video1 (encoder output) and /dev/dvb/... for the digital side.

Trying to view analog preview and the encoder at the same time has some 
quirks, best to avoid that but other than that you should be good to go. 
I don't personally use Myth, so if anyone has any MyTh related tips then 
  they should chime in here.

Firmwares and stuff are generally available from 
http://steventoth.net/linux/hvr1800

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
