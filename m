Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:34713 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZKPU4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 15:56:09 -0500
Received: by gv-out-0910.google.com with SMTP id r4so741256gve.37
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 12:56:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B01BABE.4060609@gmail.com>
References: <4AFE92ED.2060208@gmail.com> <4AFEAB15.9010509@gmail.com>
	 <829197380911140634j49c05cd0s90aed57b9ae61436@mail.gmail.com>
	 <4AFF1203.3080401@gmail.com>
	 <829197380911150719w7ea0749ei2a1350f1e12b866d@mail.gmail.com>
	 <4B001ECD.9030609@gmail.com>
	 <829197380911152055w233edf18ve36b821571198d04@mail.gmail.com>
	 <4B01B168.50403@gmail.com>
	 <829197380911161228u425db80ag20d01359aa4b7472@mail.gmail.com>
	 <4B01BABE.4060609@gmail.com>
Date: Mon, 16 Nov 2009 15:56:14 -0500
Message-ID: <829197380911161256r58a44e03j6ab93255549a3cd6@mail.gmail.com>
Subject: Re: [PATCH] em28xx: fix for Dikom DK300 hybrid USB tuner (aka Kworld
	VS-DVB-T 323UR ) (digital mode)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 16, 2009 at 3:49 PM, Andrea.Amorosi76@gmail.com
<Andrea.Amorosi76@gmail.com> wrote:
> The usb is the following:
> Bus 002 Device 010: ID eb1a:e312 eMPIA Technology, Inc.
> (I don't remember what it was previously, but it seems wrong how can I be
> sure about that?).
> I have put back the driver to the original state, but still it doesn't work.
> Did I have to reprogram the eprom? If so, it is possible via usb?
> Thank you,
> Andrea
>
> PS I've found an old dmesg.
> The USB ID is wrong! The old one was eb1a:e323

Ok, so that confirms that indeed the eeprom was corrupted.  I would
suggest you hack the USB_DEVICE() entry in em28xx-cards.c to be
eb1a:e312.  This will allow the driver to load and the i2c device to
be setup.  Then use the eeprom repair script to rewrite the eeprom.
At that point you should be able to remove the hack, because the USB
ID will be back to eb1a:e323.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
