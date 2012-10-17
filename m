Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55257 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2JQKCG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 06:02:06 -0400
Message-ID: <507E8205.2050705@iki.fi>
Date: Wed, 17 Oct 2012 13:01:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: AF9035 firmware repository
References: <507E7872.8030300@schinagl.nl>
In-Reply-To: <507E7872.8030300@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Oliver

On 10/17/2012 12:20 PM, Oliver Schinagl wrote:
> Hey antti, list,
>
> whilst trying to help some Asus U3100+ users with the recent patches I
> ran into an issue. For some strange reason his chip_id was 0xff. I'd
> hope this is somehow supplied by the firmware. I think I had the exact
> same issue until I used Antti's latest firmware for the AF9035.
>
> Having said that, I know antti currently hosts the latest firmware for
> the af9035, but there seem to be several out in the wild and people
> googling for the firmware tend to find the really old one.

Yes, it is the firmware. AF9035/AF9033 firmware is aware of used tuner 
and there is some logic inside firmware for each tuner, like calculating 
signal strength and handling of tuner I2C bus. Same applies for 
AF9015/AF9013 too where this has caused some notable problems - I have 
asked few times if someone could reverse and fix that fw to behave better.

> I'm pretty certain that Afa-tech, IT-tech etc won't allow the firmware
> to live in the kernel, or simply refuse to answer shuch a plead? They
> could be persuaded by the maintainer to at least have it live in
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git or
> if that fails, have it pulled by Documentation/dvb/get_dvb_firmware?
> (Btw, why is it get_dvb_firmware? I didn't find a generic script or
> other devices that did the same).

Feel free to try. I tried it ages back in 2009 but failed.

Someone should make some study of these firmwares and list what are 
differences, supported tuners etc. That was discussed at the time af9035 
was merged to the Kernel... As rule of thumb test first newest firmware.

Currently there is no 100% automated script to dump those firmwares from 
the binary. AF9035 driver seems to contain multiple firmwares. Maybe 
making script that finds and dumps all firmwares found from binary could 
be handy.

> I'll update the af9035 wikipage to link to antti's firmware for now.

Good!

regards
Antti

-- 
http://palosaari.fi/
