Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:51360 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZJAT1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 15:27:00 -0400
Received: by mail-ew0-f227.google.com with SMTP id 27so599459ewy.40
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2009 12:27:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>
References: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>
Date: Thu, 1 Oct 2009 15:27:03 -0400
Message-ID: <37219a840910011227r155d4bc1kc98935e3a52a4a17@mail.gmail.com>
Subject: Re: How to make my device work with linux?
From: Michael Krufky <mkrufky@kernellabs.com>
To: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 1, 2009 at 2:38 PM, Wellington Terumi Uemura
<wellingtonuemura@gmail.com> wrote:
> Hello everyone!
>
> I've a ISDB-Tb device from TBS-Tech that doesn't work with linux yet,
> it uses this chip sets:
> http://www.linuxtv.org/wiki/index.php/TBS_USB_ISDB-T_Stick
>
> Tuner - NXP TDA18271HD
> Demodulator - Fujitsu_MB86A16
> USB interface - Cypress Semiconductor EZ-USB FX2LP CY7C68013A
> Other - Shenzen First-Rank Technology T24C02A EEPROM 256 x 8 (2K bits)
>
> Using information available on the internet I've dumped the required
> firmware from the driver files using dd:
> http://www.4shared.com/file/136823880/6c2d23d9/TBS-Techfw.html
>
> As the linuxtv wiki shows, linux detect the device but to make it work
> I think is a hole different issue because is not just place the
> firmware in to the right place, the kernel have to know what to do
> with it and how to interface with the device. I was playing with
> fx2pipe trying to load the firmware and program returns that there is
> no device connected to any USB ports and I don't know if this is the
> right tool to play with.
>
> I hope to find some light on this issue.
>
> Thank you.

For a first step, I'd recommend to read up on using USB sniffers to
capture the windows driver traffic.  The drivers for the FX2 parts
tend to be relatively easy to sniff.  We already have a linux driver
for the TDA18271, I *think* there is a driver available for that
Fujitsu demod but it's not in the v4l-dvb master repository.
Support for ISDB-T was recently added to dvb-core, so many of the
major parts are available...

Unfortunately, to bring up the device driver to completion probably
wont be as easy as you might hope, but the best place to start is a
sniffed usb driver log.

It might actually be an easier task to simply find a device based on
the dib8000 that Patrick Boettcher recently added ISDB-T support for.
Other than that, I'm not sure if anybody here has the expertise to
help you support your hardware without having a stick of their own to
play with as well.

Good Luck,

Mike
