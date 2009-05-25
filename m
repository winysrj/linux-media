Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48519 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751423AbZEYCKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 22:10:49 -0400
Date: Sun, 24 May 2009 22:10:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Pete Zaitcev <zaitcev@redhat.com>,
	USB list <linux-usb@vger.kernel.org>
cc: David <david@unsolicited.net>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	<linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dbrownell@users.sourceforge.net>, <leonidv11@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked
  down
In-Reply-To: <4A1967A2.4050906@unsolicited.net>
Message-ID: <Pine.LNX.4.44L0.0905242208260.15195-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 24 May 2009, David wrote:

> Alan Stern wrote:
> > But if not then this is a genuine bug and it should be reported
> > separately on the linux-usb mailing list.
> >
> >
> >   
> 
> Stranger and stranger. I started usbmon on the quad core and (at the
> console) cat /sys/kernel/debug/usbmon/0u worked fine for the keyboard
> and mouse. I then plugged in the S-2400 and was greeted with this kernel
> panic (jpg attached).
> 
> David

Pete, you should look at this.  It appears to be a problem with the DMA
mapping in usbmon.  Probably the same sort of thing you were working on
about a week ago (trying to access device memory).

Alan Stern

