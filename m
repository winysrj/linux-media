Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42317 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbZKBNhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 08:37:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Rod <martin.rod@email.cz>
Subject: Re: MSI StarCam Racer - No valid video chain found
Date: Mon, 2 Nov 2009 14:37:05 +0100
Cc: linux-media@vger.kernel.org
References: <4AED4C3B.3020706@email.cz>
In-Reply-To: <4AED4C3B.3020706@email.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021437.05207.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Sunday 01 November 2009 09:52:11 Martin Rod wrote:
> Hi,
> 
> I use MSI StarCam Racer  on Debian Linux Lenny 2.6.26-1-686 and video
> works without problem:
> 
> usb 4-4: New USB device found, idVendor=0c45, idProduct=62e0
> usb 4-4: New USB device strings: Mfr=2, Product=1,SerialNumber=0
> usb 4-4: Product: USB 2.0 Camera
> usb 4-4: Manufacturer: Sonix Technology Co., Ltd.
> 
> I  plan use this camera on OpenWrt, (UBNT Router Station, kernel
> 2.6.30.9) and kernel didn't open this device:
> 
> Linux video capture interface: v2.00
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (v0.1.0)
> usb 1-1: new high speed USB device using ar71xx-ehci and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62e0)
> uvcvideo: No valid video chain found.
> 
> Do you have any idea?

Have you tried upgrading to a more recent kernel, or to install the latest 
uvcvideo driver ? If the latest driver still doesn't work, please send me the 
output of

lsusb -v -d 0c45:62e0

using usbutils 0.72 or newer (0.73+ preferred). Thanks.

-- 
Regards,

Laurent Pinchart
