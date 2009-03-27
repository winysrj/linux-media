Return-path: <linux-media-owner@vger.kernel.org>
Received: from n5a.bullet.mud.yahoo.com ([209.191.126.232]:46794 "HELO
	n5a.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932696AbZC0Bhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 21:37:42 -0400
From: David Brownell <david-b@pacbell.net>
To: Janne Grunau <j@jannau.net>
Subject: Re: v4l parent for usb device interface or device?
Date: Thu, 26 Mar 2009 18:31:55 -0700
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>, linux-usb@vger.kernel.org
References: <20232.62.70.2.252.1237993114.squirrel@webmail.xs4all.nl> <49CB7545.2050301@redhat.com> <20090327005124.GD2349@aniel>
In-Reply-To: <20090327005124.GD2349@aniel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261831.55746.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 March 2009, Janne Grunau wrote:
> 
> While I generally agree that setting parent to the usb interface is
> probably correct for multifunction devices

Make that "all" devices.  :)


> I noticed a problem after 
> changing the hdpvr driver accordingly.
> 
> With parent set to the usb interface there is no longer easy access to
> the usb device properties like the serial number through sysfs. I know
> that a couple of user with more than one device use the serial number
> to set static device nodes through udev.

The serial number is still available, but it's coupled to the USB
device not its interface.  Make your udev script hop up a level or
two in the driver model tree, as appropriate.






