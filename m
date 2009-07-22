Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:40426 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGVPGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 11:06:13 -0400
Received: by yxe35 with SMTP id 35so401547yxe.33
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 08:06:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6729CF.8080804@powercraft.nl>
References: <4A6666CC.7020008@eyemagnet.com>
	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	 <4A66E59E.9040502@powercraft.nl>
	 <829197380907220748kab85c63g6ebbaad07084c255@mail.gmail.com>
	 <4A6729CF.8080804@powercraft.nl>
Date: Wed, 22 Jul 2009 11:06:12 -0400
Message-ID: <829197380907220806p4ed7a02bw3beff7c6776a858a@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-media@vger.kernel.org >> \"linux-media@vger.kernel.org\""
	<linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 22, 2009 at 11:01 AM, Jelle de
Jong<jelledejong@powercraft.nl> wrote:
> Funky timing of those mails :D.
>
> I saw only after sending my mail that Steve was talking about analog and
> that this is indeed different. Dual analog tuner support should be
> possible right? Maybe with some other analog usb chipsets? I don't know
> what the usb blocksize is or if they are isochronous transfers or bulk
> or control.
>
> I assume the video must be uncompressed transferred over usb because the
> decoding chip is on the usb device is not capable of doing compression
> encoding after the analog video decoding? Are there usb devices that do
> such tricks?

There were older devices that did compression, mainly designed to fit
the stream inside of 12Mbps USB.  However, they required onboard RAM
to buffer the frame which added considerable cost (in addition to the
overhead of doing the compression), and as a result pretty much all of
the USB 2.0 designs I have seen do not do any on-chip compression.

The example which comes to mind is the Hauppauge Win-TV USB which uses
the usbvision chipset.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
