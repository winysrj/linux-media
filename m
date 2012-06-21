Return-path: <linux-media-owner@vger.kernel.org>
Received: from v38276.1blu.de ([88.84.155.223]:39101 "EHLO barth.jannau.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2FUNLZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 09:11:25 -0400
Date: Thu, 21 Jun 2012 15:02:39 +0200
From: Janne Grunau <janne@jannau.net>
To: sitten74490@mypacks.net
Cc: linux-media@vger.kernel.org
Subject: Re: hdpvr lockup with audio dropouts
Message-ID: <20120621130239.GJ24416@jannau.net>
References: <17385433.1339252296523.JavaMail.root@elwamui-little.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17385433.1339252296523.JavaMail.root@elwamui-little.atl.sa.earthlink.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-06-09 10:31:36 -0400, sitten74490@mypacks.net wrote:
> >
> >On Thu, Jun 7, 2012 at 7:53 PM,  <sitten74490@mypacks.net> wrote:
> >> Apparently there is a known issue where the HD-PVR cannot handle the loss
> >> of audio signal over SPDIF while recording.  If this happens, the unit
> >> locks up requiring it to be power cycled before it can be used again. This
> >> behavior can easily be reproduced by pulling the SPDIF cable during
> >> recording.  My question is this:  are there any changes that could be made
> >> to the hdpvr driver that would make it more tolerant of brief audio
> >> dropouts?
> >
> >Does it do this under Windows?  If it does, then call Hauppauge and get them
> >to fix it (and if that results in a firmware fix, then it will help Linux
> >too).  If it works under Windows, then we know it's some sort of driver
> >issue which would be needed.
> >
> >It's always good when it's readily reproducible.  :-)
> >
> 
> Well, I tested it in Windows and no, the HD-PVR does not lock up when the
> audio signal is lost.  It does pause, but when the signal comes back it
> resumes playing normally.  So if I understand you correctly, this would most
> likely be a Linux driver bug rather than a firmware problem.

Yes, it's a driver bug (although iirc the device locked up when I wrote
the driver). If you have usb traffic logs from the windows driver I'll
look at them. If not I'll try to set my hdpvr up in the next days.

Janne
