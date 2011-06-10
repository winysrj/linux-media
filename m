Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:33268 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1FJPH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 11:07:29 -0400
Message-ID: <4DF23322.1020503@infradead.org>
Date: Fri, 10 Jun 2011 12:07:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
References: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-06-2011 11:48, Alan Stern escreveu:
> On Fri, 10 Jun 2011, Hans de Goede wrote:
> 
> 
> As Felipe has mentioned, this sounds like the sort of problem that 
> can better be solved in userspace.  A dual-mode device like the one 
> you describe really is either a still-cam or a webcam, never both at 
> the same time.  Hence what users need is a utility program to switch 
> modes (by loading/unloading the appropriate programs or drivers). 

Unloading a driver in order to access the hardware via userspace?
This sounds a very bad idea do me. What happens if another hardware 
is using the same driver?

Cheers,
Mauro.
