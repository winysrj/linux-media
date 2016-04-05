Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33696 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcDEXAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 19:00:11 -0400
Received: by mail-lf0-f52.google.com with SMTP id e190so19513043lfe.0
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2016 16:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57043D56.2020708@iki.fi>
References: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
	<570400DE.9040306@iki.fi>
	<CAO8Cc0oHFwaRHAZaY5BZUAyYwCWRoD7s_97gr0vLF5YLgGAntA@mail.gmail.com>
	<57043D56.2020708@iki.fi>
Date: Wed, 6 Apr 2016 01:00:09 +0200
Message-ID: <CAO8Cc0qj-=y2E6Ur+UW+_sz8sOt4RtVS82hhEQR7WT9zZ350Mg@mail.gmail.com>
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 6, 2016 at 12:33 AM, Antti Palosaari <crope@iki.fi> wrote:
> I found one stick having AF9035 + MXL5007T. It is HP branded A867, so it
> should be similar. It seems to work all three 12.13.15.0 6.20.15.0
> firmwares:
> http://palosaari.fi/linux/v4l-dvb/firmware/af9035/
>
> mxl5007t 5-0060: creating new instance
> mxl5007t_get_chip_id: unknown rev (3f)
> mxl5007t_get_chip_id: MxL5007T detected @ 5-0060
>
> That is what AF9035 reports (with debug) as a chip version:
> dvb_usb_af9035: prechip_version=00 chip_version=03 chip_type=3802
>
>
> Do you have different chip version?
>

I have a Sky Italy DVB stick with the same chip version.  I see that
you get the 0x3f response as well... that should be fixed by the I2C
patch I proposed.  However, your stick seems to handle the read
properly and process subsequent I2C commands - something that doesn't
happen with mine.  The vendor drivers in linux and windows never seem
issue the USB I2C commands to read from the tuner.  I'll test with
other firmware versions to see if something changes.

Regards,
Alessandro
