Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:17446 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1BHJQD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Feb 2011 04:16:03 -0500
Message-ID: <4D5109B3.60504@nokia.com>
Date: Tue, 08 Feb 2011 11:15:31 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
MIME-Version: 1.0
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
CC: matti.j.aaltonen@nokia.com, alsa-devel@alsa-project.org,
	sameo@linux.intel.com,
	ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	hverkuil@xs4all.nl, lrg@slimlogic.co.uk,
	linux-media@vger.kernel.org
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>		<4D4FDED0.7070008@redhat.com>		<20110207120234.GE10564@opensource.wolfsonmicro.com>		<4D4FEA03.7090109@redhat.com>		<20110207131045.GG10564@opensource.wolfsonmicro.com>		<4D4FF821.4010701@redhat.com>		<20110207135225.GJ10564@opensource.wolfsonmicro.com>	<1297088242.15320.62.camel@masi.mnp.nokia.com> <4D501704.6060504@redhat.com>
In-Reply-To: <4D501704.6060504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 02/07/11 18:00, ext Mauro Carvalho Chehab wrote:
> We don't need any brand names or specific details, but it would be good to 
> have an overview, in general lines, about the architecture, in order to help 
> you to map how this would fit. In particular, the architecturre of 
> things that are tightly coupled and can't be splitted by some bus abstraction.

The wl1273 as such is designed for embedded systems.
It can be connected in several ways to the system:
- analog only
In this way the RX/TX is connected to some codec's Line IN/OUT
For this to work, we don't need any audio driver for the FM chip
(basically the same configuration as rx51 has in regards of FM radio)

- Digital interfaces
The I2S lines are connected to the main processor. In this way the
wl1273 acts as a codec.
In order to provide platform independent driver we need to use ASoC
framework. ASoC have broad main processor side support, and it is easy
to switch the arch, if we have proper ASoC codec driver for the wl1273.
It is also better to keep the codec implementation under
sound/soc/codecs.

I have not looked deeply into the wl1273 datasheets, but I'm sure
there's a way to nicely divide the parts between the MFD, V4L, and ASoC.

-- 
Péter
