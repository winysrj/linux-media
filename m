Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56966 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab2KWRU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 12:20:58 -0500
Message-ID: <50AFB05B.6020209@iki.fi>
Date: Fri, 23 Nov 2012 19:20:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Mysterious USB device ID change on Hauppauge HVR-900 (em28xx)
References: <50AFABDA.9050309@googlemail.com>
In-Reply-To: <50AFABDA.9050309@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2012 07:01 PM, Frank Schäfer wrote:
> Hi,
>
> I've got a Hauppauge HVR-900 (65008/A1C0) today. First,  the device
> showed up as USB device 7640:edc1 (even after several unplug - replug
> cycles), so I decided to add this VID:PID to the em28xx driver to see
> what happens.
> That worked fine, em2882/em2883, tuner xc2028/3028 etc. were detected
> properly.
> Later I noticed, that the device now shows up as 2040:6500, which is the
> expected ID for this device.
> Since then, the device maintains this ID. I also checked if Windows is
> involved, but it shows up with the same ID there.
>
> Does anyone have an idea what could have happened ???
> I wonder if we should add this ID to the em28xx driver...

em28xx chip reads USB ID from the external eeprom using I2C just after 
it was powered. After USB ID is got it connects to the USB bus using 
that ID. If there is no external eeprom it uses chipset default USB ID, 
which is 0xeb1a as vendor ID and some other number defined for chip 
model as device ID. In that case those wrong IDs seems to be total 
garbage, which indicates there is some hardware problems when 
communicating towards eeprom.

That method is not only Empia USB interface chips but almost all chipset 
uses just similar method.


regard
Antti

-- 
http://palosaari.fi/
