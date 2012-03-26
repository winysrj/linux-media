Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54597 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2CZOqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 10:46:19 -0400
Received: by vbbff1 with SMTP id ff1so2655554vbb.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 07:46:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de>
References: <assp.243108522f.1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de>
Date: Mon, 26 Mar 2012 10:46:18 -0400
Message-ID: <CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Neumann <sneumann@ipb-halle.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 25, 2012 at 4:09 PM, Steffen Neumann <sneumann@ipb-halle.de> wrote:
> Hi,
>
> I am trying to get a Hauppauge WinTV HVR 930C-HD
> to work under Ubuntu 12.04 with the vanilla 3.3 kernel from [1].
> After (manually) loading the em28xx module,
> there are no additional messages in kern.log,
> only "registered new interface driver em28xx".
>
> What is odd is that lsusb shows for this card "ID 2040:b130 Hauppauge",
> while from [2] I think it should be [2040:1605],
> see below for the full lsusb -v output. The card
> was purchased this week.
>
> Do I have a new revision of the 930C ?
> I tried "modprobe em28xx card=81", but no change.
> Did I miss anything else ?

2040:b130 isn't an em28xx based device.  It uses cx231xx.  That said,
it's not supported under Linux not because of the cx231xx driver but
because there is no driver for the demodulator (si2163).

Nobody is working on such a driver, and there is no support planned
for this device at this time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
