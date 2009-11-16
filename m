Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40826 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZKPU2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 15:28:39 -0500
Received: by yxe17 with SMTP id 17so200690yxe.33
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 12:28:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B01B168.50403@gmail.com>
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com>
	 <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com>
	 <4AFF1203.3080401@gmail.com>
	 <829197380911150719w7ea0749ei2a1350f1e12b866d@mail.gmail.com>
	 <4B001ECD.9030609@gmail.com>
	 <829197380911152055w233edf18ve36b821571198d04@mail.gmail.com>
	 <4B01B168.50403@gmail.com>
Date: Mon, 16 Nov 2009 15:28:43 -0500
Message-ID: <829197380911161228u425db80ag20d01359aa4b7472@mail.gmail.com>
Subject: Re: [PATCH] em28xx: fix for Dikom DK300 hybrid USB tuner (aka Kworld
	VS-DVB-T 323UR ) (digital mode)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 16, 2009 at 3:09 PM, Andrea.Amorosi76@gmail.com
> Hi Devin,
> I think I've done a big mistake.
> I've wrongly inserted digital_default in the analog tuner section and I've
> compiled and tested the device.
> It hasn't worked and so I've realized the mistake and the fact that the
> device eprom was changed.
> So I've tried with the rewrite eprom script to correct the problem, but now
> the device doesn't work any more.
> When I plug it in this is the dmesg message:
>
> [  919.319963] usb 2-2: USB disconnect, address 10
> [  921.520069] usb 2-2: new high speed USB device using ehci_hcd and address
> 11
> [  921.656306] usb 2-2: configuration #1 chosen from 1 choice
>
> And if I try to rewrite the eprom it says a lot of messages like this:
>
> Error: Could not open file `/dev/i2c-6' or `/dev/i2c/6': No such file or
> directory
>
> I've loaded  the i2c_dev and the em28xx manually but nothing has changed.
> Please don't tell me that I've destroyed my device :-(
> Andrea

What does "lsusb" report as the USB ID of the device?  If that value
is wrong, then you indeed did trash your eeprom and would need to
manually reprogram it.

Did you put the driver back to the state where the analog_gpio no
longer points to default_digital?  Or is the driver code still in the
wrong state?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
