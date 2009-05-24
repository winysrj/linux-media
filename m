Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40638 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998AbZEXBCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 21:02:40 -0400
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
	down
From: hermann pitton <hermann-pitton@arcor.de>
To: David <david@unsolicited.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net, leonidv11@gmail.com,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4A189187.4020407@unsolicited.net>
References: <Pine.LNX.4.44L0.0905231657210.22430-100000@netrider.rowland.org>
	 <4A189187.4020407@unsolicited.net>
Content-Type: text/plain
Date: Sun, 24 May 2009 02:54:33 +0200
Message-Id: <1243126473.3705.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 24.05.2009, 01:15 +0100 schrieb David:
> Alan Stern wrote:
> > It's not obvious what could be causing this, so let's start out easy.  
> > Try collecting two usbmon traces (instructions are in
> > Documentation/usb/usbmon.txt), showing what happens with and without
> > the reversion.  Maybe some difference will stick ou
> >   
> Traces attached. Took a while as my quad core hangs solid when 0u is
> piped to a file (I had to compile on a laptop and take the logs there).
> 
> Cheers
> David
> 
> 

just a note, since you said it is some ATI chipset.

Is it the SB700?

We have lots of reports about disconnects, but then also claimed to be
fixed in between, and i don't know the current status ...

Cheers,
Hermann




