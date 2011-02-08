Return-path: <mchehab@pedra>
Received: from mga11.intel.com ([192.55.52.93]:62306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1BHKJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 05:09:51 -0500
From: "Bensaid, Selma" <selma.bensaid@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"matti.j.aaltonen@nokia.com" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Tue, 8 Feb 2011 10:09:33 +0000
Subject: RE: [alsa-devel] WL1273 FM Radio driver...
Message-ID: <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
		<4D4FDED0.7070008@redhat.com>
		<20110207120234.GE10564@opensource.wolfsonmicro.com>
		<4D4FEA03.7090109@redhat.com>
		<20110207131045.GG10564@opensource.wolfsonmicro.com>
		<4D4FF821.4010701@redhat.com>
		<20110207135225.GJ10564@opensource.wolfsonmicro.com>
	<1297088242.15320.62.camel@masi.mnp.nokia.com>	<4D501704.6060504@redhat.com>
 <4D5109B3.60504@nokia.com>
In-Reply-To: <4D5109B3.60504@nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> The wl1273 as such is designed for embedded systems.
> It can be connected in several ways to the system:
> - analog only
> In this way the RX/TX is connected to some codec's Line IN/OUT
> For this to work, we don't need any audio driver for the FM chip
> (basically the same configuration as rx51 has in regards of FM radio)
> 
> - Digital interfaces
> The I2S lines are connected to the main processor. In this way the
> wl1273 acts as a codec.
> In order to provide platform independent driver we need to use ASoC
> framework. ASoC have broad main processor side support, and it is easy
> to switch the arch, if we have proper ASoC codec driver for the wl1273.
> It is also better to keep the codec implementation under
> sound/soc/codecs.
> 
2 Digital interfaces are possible for FM WL1273:
- the external connection: the I2S lines are used for the FM PCM samples
- the internal connection: the BT PCM interface is used for the FM PCM samples
For both configuration we have a set of HCI commands to configure the FM audio 
path and one of my concerns is to know if the wl1273_codec should handle the audio path configuration 
and the switch between FM and BT SCO?

> I have not looked deeply into the wl1273 datasheets, but I'm sure
> there's a way to nicely divide the parts between the MFD, V4L, and ASoC.
> 
> --
> Péter
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

