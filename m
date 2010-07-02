Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33527 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab0GBJDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 05:03:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Samuel Xu <samuel.xu.tech@gmail.com>
Subject: Re: Question on uvcvideo driver's power management
Date: Fri, 2 Jul 2010 11:03:56 +0200
Cc: linux-media@vger.kernel.org
References: <AANLkTil-iWbMyCkKYfjWUUjG95iGjbo_h-y1snt0D444@mail.gmail.com>
In-Reply-To: <AANLkTil-iWbMyCkKYfjWUUjG95iGjbo_h-y1snt0D444@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007021103.57386.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

On Tuesday 29 June 2010 12:12:13 Samuel Xu wrote:
> Question on uvcvideo driver's power management:
> Q1: We found some USB material mentioned : Relationship between ACPI
> Dx states and USB PM states (active/suspended) is orthogonal.
> Suspend/resume might not effect device Dx state(e.g. D0/D1/D3). Is it
> a correct statement for general usb device and uvcvideo usb device?
> Q2: How to tell USB uvcvideo device’s ACPI Dx state. It seems lsusb
> can’t tell us those info. (lspci works for PCI device’s Dx state)
> Q3: How to tell USB uvcvideo device’s suspension state? will any query
> via urb will cause resume of uvcvideo device?
> Q4: should USB uvcvideo device driver response to do some
> device-specific power action (e.g. device register writing) to put a
> specific USB camera into low power state when responding to suspend
> action? (I didn't find such device-specific power code inside uvcvideo
> src code)
> Q5: If Q4 is Yes, should device vendor respond for those device-specific
> code?

Power management for UVC devices is handled at the USB level. There's nothing 
UVC-specific to it. You've received answers to those questions on the linux-
usb list so I won't go into a lot of details (there are developers more 
knowledgeable about USB power management on linux-usb).

In a nutshell, USB devices have a single "suspended" state instead of ACPI Dx 
states. Devices must suspend themselves if they don't see any bus activity for 
at 3ms (idle bus). Activity doesn't require the driver to perform any action 
explicitly, the USB host controller will send a Start Of Frame packet every 
millisecond on its own.

Stopping activity is achieved by sending a SET_FEATURE(PORT_SUSPEND) request 
to the hub the device is connected to (either root hub, or external hub) 
asking it to stop USB traffic on the device port. Resuming activity is then 
done with the CLEAR_FEATURE(PORT_SUSPEND) request.

The job of the driver, before suspend, is to save the device state (if 
required) and kill all URBs. On resume the driver will then restore the device 
state and resubmit the URBs.

-- 
Regards,

Laurent Pinchart
