Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:55201 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1LLMWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 07:22:00 -0500
Message-ID: <4EE5F1E6.3060908@mlbassoc.com>
Date: Mon, 12 Dec 2011 05:21:58 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Robert_=C5kerblom-Andersson?= <robert.nr1@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: I2C and mt9p031 on Overo
References: <CABiSWBhYe6QL41mCvDyrZekzn0YjG3F9Lx70Tix0j=Hzsy4rYw@mail.gmail.com>
In-Reply-To: <CABiSWBhYe6QL41mCvDyrZekzn0YjG3F9Lx70Tix0j=Hzsy4rYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-12-11 13:25, Robert Åkerblom-Andersson wrote:
> Hi, I trying to get the mt9p031 to work on the Overo board.
>
> So far I have it working in the Beagleboard xM, and now I have sort of
> ported/used the same files to get it to work with Overo. My problem
> now is that when I probe the camera board (LI-5M03 with an adapter
> board in between providing extra voltage levels) it seams fine.
>
> OMAP3ISP loads without any bigger error but the mt9p031 driver can't
> find the device, but it does not seam to be a driver problem rather a
> board problem. I think this since I've been debugging with "i2cdetect
> -y -r 3" to scan the bus for the camera. Most of the times I get
> nothing, but a couple of times (out of hundreds or more, I used a
> while loop with i2cdetect and then a sleep 1) it showed up with it's
> address. I think it happens when I just inserted the board but I'm
> sure or if I get it into some "weird" state just adding it. It could
> be a contact error but I have a felling it is something else I have
> missed. Some pin configuration or something that stops it from
> working.
>
> Do you have any tips on how to debug further or on what might the my
> problem? I have tried to lower the i2c speed to 100 KHz but it did not
> seam to make any difference.
>

I too had problems with this device.  I have [yet another] different DM3750
board which uses this sensor, so my experience is not exactly the same as
yours on the Overo.  However, I found that I had to have a pretty substantial
delay (500ms) between the time that the MT9P031 was taken out of reset (I have this
on a GPIO pin) and when the I2C bus is scanned for the device (mt9p031_probe called).

With the delay, the device is discovered and works great.  Without it, the
device is never seen on the I2C bus.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
