Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:37066 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZC0U7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 16:59:46 -0400
Date: Fri, 27 Mar 2009 21:59:23 +0100
From: Janne Grunau <j@jannau.net>
To: David Brownell <david-b@pacbell.net>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>, linux-usb@vger.kernel.org
Subject: Re: v4l parent for usb device interface or device?
Message-ID: <20090327205923.GA6064@aniel>
References: <20232.62.70.2.252.1237993114.squirrel@webmail.xs4all.nl> <49CB7545.2050301@redhat.com> <20090327005124.GD2349@aniel> <200903261831.55746.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903261831.55746.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 26, 2009 at 06:31:55PM -0700, David Brownell wrote:
> On Thursday 26 March 2009, Janne Grunau wrote:
> 
> > I noticed a problem after 
> > changing the hdpvr driver accordingly.
> > 
> > With parent set to the usb interface there is no longer easy access to
> > the usb device properties like the serial number through sysfs. I know
> > that a couple of user with more than one device use the serial number
> > to set static device nodes through udev.
> 
> The serial number is still available, but it's coupled to the USB
> device not its interface.  Make your udev script hop up a level or
> two in the driver model tree, as appropriate.

yes, ATTRS{} still matches. There are udev howtos around which suggest
ATTRS{} just matches one level up and not the entire path. I tried it but
had unfortunately a typo in the udev rule. Sorry for the noise.

Janne
