Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:46163 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab0FVEHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 00:07:52 -0400
Subject: Re: Laptop failing to suspend when WinTV-HVR950 installed.
From: hermann pitton <hermann-pitton@arcor.de>
To: David Hagood <david.hagood@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1277173153.3399.10.camel@pc07.localdom.local>
References: <1277169560.6715.6.camel@chumley>
	 <1277173153.3399.10.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Tue, 22 Jun 2010 05:58:10 +0200
Message-Id: <1277179090.3145.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 22.06.2010, 04:19 +0200 schrieb hermann pitton:
> Hi David,
> 
> Am Montag, den 21.06.2010, 20:19 -0500 schrieb David Hagood:
> > I have a 100% repeatable failure for my laptop runing Lucid 64 bit to
> > suspend when my WinTV-HVR950 is installed, and a 100% success rate on it
> > suspending when the device is not installed.
> > 
> > If I put the device in, remove the device, and suspend (e.g. by closing
> > the lid) it will suspend. There are no processes opening the device (as
> > confirmed by lsof | grep dvb).
> > 
> > Additionally, most of the time the failure to suspend occurs, the
> > machine becomes unresponsive, and I have to hard power off to get it
> > back.
> > 
> > Has anybody else seen this?
> 
> just as a hint.
> 
> You need some cloud of users, that somebody sticks in.
> 
> I still have cases, where a single user claims on the wiki, all Asus
> stuff is rubbish, but he still is exactly the only one failing after
> years.

To stop joking, well noticed from you.

The dvb subsystem never had any way to suspend and recover reliable.

Cheers,
Hermann


