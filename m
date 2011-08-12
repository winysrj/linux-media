Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54369 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752155Ab1HLKLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 06:11:52 -0400
Date: Fri, 12 Aug 2011 11:11:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Alan Stern <stern@rowland.harvard.edu>,
	Hans de Goede <hdegoede@redhat.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Message-ID: <20110812111112.722cce3a@lxorguk.ukuu.org.uk>
In-Reply-To: <4E443C6E.8040808@infradead.org>
References: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org>
	<alpine.LNX.2.00.1108111235400.27040@banach.math.auburn.edu>
	<4E443C6E.8040808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> instead of using the V4L2 device node to access the stored images, it probably makes 
> more sense to use a separate device for that, that will handle a separate set of 
> ioctl's, and just use read() to retrieve the image data, after selecting the desired
> image number, via ioctl().

How will you handle the permission model, what about devices where you
need the V4L2 controls to take the picture in the first place ?

It seems it should really be the same device and just a minor tweak to
the API. V4L2 already provides frame reading and mapping functionality
and the media layer provides post processing services which I could
conceive some setups needing to use.

gphoto would just open the v4l device ask for still image stuff and
discover it wasn't available.
