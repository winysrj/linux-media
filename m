Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58397 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3BOJjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:39:33 -0500
Message-ID: <511E0200.6080508@iki.fi>
Date: Fri, 15 Feb 2013 11:38:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alexander List <alex@list.priv.at>
CC: linux-media@vger.kernel.org
Subject: Re: DMB-H USB Sticks: MagicPro ProHDTV Mini 2 USB
References: <511D8DF9.7060508@list.priv.at>
In-Reply-To: <511D8DF9.7060508@list.priv.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/15/2013 03:23 AM, Alexander List wrote:
> Hi,
>
> frustrated that I couldn't watch the Chinese New Years' Fireworks on TVB
> Jade using my RTL2832U based DVB-T stick in Hong Kong, I just bought a
>
> MagicPro ProHDTV Mini 2
>
> USB stick. Given that HK is now part of China (somehow), they decided to
> follow the mainland DTV standard, so it's DTMB (DMB-T/H) over here.
>
> The package says it only supports Windows, but I never believe the
> packaging, and I believe in Linux hackers :)
>
> lsusb -v says:
>
> Bus 001 Device 008: ID 1b80:d39f Afatech
>
> This looks *very* similar to the RTL2832U, in fact dmesg says it's a
> Realtek chip:
>
> [58773.739843] usb 1-1.1: new high-speed USB device number 8 using ehci_hcd
> [58773.835657] usb 1-1.1: New USB device found, idVendor=1b80,
> idProduct=d39f
> [58773.835665] usb 1-1.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [58773.835670] usb 1-1.1: Product: usbtv
> [58773.835673] usb 1-1.1: Manufacturer: realtek
>
> Full lsusb -v output is attached.

It didn't looked very similar than RTL2831U or RTL2832U USB interface. 
Very likely different USB interface.

> I checked here but it's not listed, but other (PCIe) devices from the
> same manufacturer are:
>
> http://linuxtv.org/wiki/index.php/DMB-T/H_PCIe_Cards
>
> I'm more than willing to get this thing supported under Linux - just let
> me know what I can do to help.
>
> I have
>
> a) the stick
> b) the Windows driver/software CD (soon as an ISO)
>
> What I can provide is
>
> a) help getting more info on the hardware (taking it apart etc.)
> b) provide remote access to a box with the stick plugged in if necessary
> c) test new code / patches

First thing to do is identify used chips. Open the box and find out 3 
biggest chip. There may be 1, 2 or 3 big chips depending on integration 
level.

regards
Antti

-- 
http://palosaari.fi/
