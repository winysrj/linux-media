Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:48934 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757625Ab1FJPV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 11:21:59 -0400
Date: Fri, 10 Jun 2011 11:21:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans de Goede <hdegoede@redhat.com>, <linux-usb@vger.kernel.org>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	<linux-media@vger.kernel.org>,
	<libusb-devel@lists.sourceforge.net>,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, <hector@marcansoft.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	<pbonzini@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <4DF23322.1020503@infradead.org>
Message-ID: <Pine.LNX.4.44L0.1106101119300.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 10 Jun 2011, Mauro Carvalho Chehab wrote:

> Em 10-06-2011 11:48, Alan Stern escreveu:
> > On Fri, 10 Jun 2011, Hans de Goede wrote:
> > 
> > 
> > As Felipe has mentioned, this sounds like the sort of problem that 
> > can better be solved in userspace.  A dual-mode device like the one 
> > you describe really is either a still-cam or a webcam, never both at 
> > the same time.  Hence what users need is a utility program to switch 
> > modes (by loading/unloading the appropriate programs or drivers). 
> 
> Unloading a driver in order to access the hardware via userspace?
> This sounds a very bad idea do me. What happens if another hardware 
> is using the same driver?

A kernel driver wouldn't have to be unloaded.  It could simply be 
unbound from the device via sysfs or usbfs.

Alan STern

