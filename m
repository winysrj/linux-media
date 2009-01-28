Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:42627 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZA1Ogw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 09:36:52 -0500
Received: by qyk4 with SMTP id 4so7942429qyk.13
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 06:36:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49806755.9000902@ingegneria.unime.it>
References: <49806755.9000902@ingegneria.unime.it>
Date: Wed, 28 Jan 2009 09:36:50 -0500
Message-ID: <412bdbff0901280636o731e5c34gc085cb3d5157743d@mail.gmail.com>
Subject: Re: empire USB portable media station
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Giancarlo Iannizzotto <ianni@ingegneria.unime.it>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 28, 2009 at 9:10 AM, Giancarlo Iannizzotto
<ianni@ingegneria.unime.it> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I recently bought the USB hybrid card named "empire USB portable media
> station". My Ubuntu 8.10 linux box does not recognize it:
>
> dmesg:
> ...
> [ 377.610947] usb 4-1: new high speed USB device using ehci_hcd and
> address 4
> [ 377.743974] usb 4-1: configuration #1 chosen from 1 choice
>
> the lsusb command returns:
> ...
> Bus 004 Device 004: ID 1b80:e025
>
> and the detailed information about the chips inside the card (as
> described in http://forum.html.it/forum/showthread/t-1263514.html)
> are:
> Tuner: NXP TDA18271
> Demod： NXP TDA10048
> A/V Decoder: NXP SAA7136E
> USB Bridge:Cypress 68013A
>
> I really would like to keep and use this device. Please, could anyone
> give me some hints?
>
> Thank you in advance
> ianni

Hello Ianni,

I am working on a driver for the saa7136, but I have been slightly
distracted in the last few days on a separate project.  Also, the chip
is ridiculously complicated compared to other decoders, so even with
the driver it will be quite difficult to make new devices work.  I am
hoping to have something in a few weeks.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
