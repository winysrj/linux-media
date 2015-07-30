Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55168 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbbG3RN4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:13:56 -0400
Subject: Re: [PATCH 00/27] Export I2C and OF module aliases in missing drivers
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1438273132-20926-1-git-send-email-javier@osg.samsung.com>
 <20150730163517.GA13165@dtor-ws> <20150730163708.GB13165@dtor-ws>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
	Mark Brown <broonie@kernel.org>, linux-iio@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-leds@vger.kernel.org,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	lm-sensors@lm-sensors.org, Sebastian Reichel <sre@kernel.org>,
	linux-input@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jean Delvare <jdelvare@suse.com>,
	Jonathan Cameron <jic23@kernel.org>,
	linux-media@vger.kernel.org, rtc-linux@googlegroups.com,
	linux-pm@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Takashi Iwai <tiwai@suse.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
	Lee Jones <lee.jones@linaro.org>,
	Bryan Wu <cooloney@gmail.com>, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-usb@vger.kernel.org,
	linux-spi@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	linuxppc-dev@lists.ozlabs.org
Message-ID: <55BA5B48.1050005@osg.samsung.com>
Date: Thu, 30 Jul 2015 19:13:44 +0200
MIME-Version: 1.0
In-Reply-To: <20150730163708.GB13165@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dmitry,

Thanks a lot for your feedback.

On 07/30/2015 06:37 PM, Dmitry Torokhov wrote:
> On Thu, Jul 30, 2015 at 09:35:17AM -0700, Dmitry Torokhov wrote:
>> Hi Javier,
>>
>> On Thu, Jul 30, 2015 at 06:18:25PM +0200, Javier Martinez Canillas wrote:
>>> Hello,
>>>
>>> Short version:
>>>
>>> This series add the missing MODULE_DEVICE_TABLE() for OF and I2C tables
>>> to export that information so modules have the correct aliases built-in
>>> and autoloading works correctly.
>>>
>>> Longer version:
>>>
>>> Currently it's mandatory for I2C drivers to have an I2C device ID table
>>> regardless if the device was registered using platform data or OF. This
>>> is because the I2C core needs an I2C device ID table for two reasons:
>>>
>>> 1) Match the I2C client with a I2C device ID so a struct i2c_device_id
>>>    is passed to the I2C driver probe() function.
>>>
>>> 2) Export the module aliases from the I2C device ID table so userspace
>>>    can auto-load the correct module. This is because i2c_device_uevent
>>>    always reports a MODALIAS of the form i2c:<client->name>.
>>
>> Why are we not fixing this? We emit specially carved uevent for
>> ACPI-based devices, why not the same for OF? Platform bus does this...
> 
> Ah, now I see the 27/27 patch. I think it is exactly what we need. And

Yes, patch 27/27 is needed but the problem is as I explained before that
there are drivers relying on the current behavior. The item c) in the list
of issues that I mentioned. So those drivers need to be fixed before that
patch is merged...

> probably for SPI bus as well.
>

Yes, I didn't mention SPI because the cover letter became too long
already but it does indeed have the same issue and I discussed this
with  Mark already some time ago [0].

Once I2C uevent report is fixed, I plan to do the same for SPI.

> Thanks.
> 

[0]: https://lkml.org/lkml/2014/9/11/458

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
