Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212]:34256 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab0BXVTe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 16:19:34 -0500
Received: by ewy4 with SMTP id 4so1291247ewy.28
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 13:19:32 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Subject: Re: Elgato EyeTV DTT deluxe v2 - i2c enumeration failed
Date: Wed, 24 Feb 2010 22:19:29 +0100
Cc: linux-media@vger.kernel.org
References: <4B858AD1.5070502@tls-tautenburg.de>
In-Reply-To: <4B858AD1.5070502@tls-tautenburg.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242219.29385.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 24 February 2010 21:23:45 Bringfried Stecklum wrote:
> Hi, I recently purchased the Elgato EyeTV DTT deluxe v2 stick. I am running
> Ubuntu 8.10 with Linux 2.6.28-15-generic. I installed v4l-dvb from
>  mercurial with a slight change of
>  linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h to account for the USB ID of
>  the device (#define USB_PID_ELGATO_EYETV_DTT_Dlx 0x002c). After insertion
>  the stick is recognized, however no frontend is activated since the i2c
>  enumeration failed. This might be related to a missing udev rule. 

Most likely Elgato has changed the USB ID of their product, because it is not 
the same product. In general (I'd say 50% of the cases) changing the USB ID is 
not the right solution to get the hardware work.

If you can, open the stick to see on which hardware the device is based on, or 
search the internet to find out.

If you're lucky another minor quirk in this or another driver is sufficient to 
make it work.

-- 
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
