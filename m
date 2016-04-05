Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39281 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933764AbcDEWeD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 18:34:03 -0400
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
To: Alessandro Radicati <alessandro@radicati.net>
References: <CAO8Cc0qvJxO2Z63HJd1_df+mY8HHB-UrUUZLPqBHQuoyD=TAkQ@mail.gmail.com>
 <570400DE.9040306@iki.fi>
 <CAO8Cc0oHFwaRHAZaY5BZUAyYwCWRoD7s_97gr0vLF5YLgGAntA@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <57043D56.2020708@iki.fi>
Date: Wed, 6 Apr 2016 01:33:58 +0300
MIME-Version: 1.0
In-Reply-To: <CAO8Cc0oHFwaRHAZaY5BZUAyYwCWRoD7s_97gr0vLF5YLgGAntA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found one stick having AF9035 + MXL5007T. It is HP branded A867, so it 
should be similar. It seems to work all three 12.13.15.0 6.20.15.0 
firmwares:
http://palosaari.fi/linux/v4l-dvb/firmware/af9035/

mxl5007t 5-0060: creating new instance
mxl5007t_get_chip_id: unknown rev (3f)
mxl5007t_get_chip_id: MxL5007T detected @ 5-0060

That is what AF9035 reports (with debug) as a chip version:
dvb_usb_af9035: prechip_version=00 chip_version=03 chip_type=3802


Do you have different chip version?

regards
Antti

-- 
http://palosaari.fi/
