Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.urz.uni-halle.de ([141.48.3.13]:44704 "EHLO
	mailgate.urz.uni-halle.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab2CZQqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 12:46:47 -0400
From: "Neumann, Steffen" <sneumann@ipb-halle.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV HVR 930C-HD - new USB ID 2040:b130 ?
Date: Mon, 26 Mar 2012 16:46:43 +0000
Message-ID: <assp.6432a3f11c.wbu9dt7xo6ww5ofhwd2i132p.1332780438773@email.android.com>
References: <1332706154.31585.245.camel@paddy.ipb-sub.ipb-halle.de>,<CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
In-Reply-To: <CAGoCfix+iDFg86nYKqQOn1=DKHWp8Fj+iFdKZgcQjxKKf4uyow@mail.gmail.com>
Content-Language: en-GB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Not the answer I was looking for,
But thanks everybody for the clarification.
I'll try to register for the wiki and add
That information.

Yours, Steffen


Devin Heitmueller <dheitmueller@kernellabs.com> schrieb:


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
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
