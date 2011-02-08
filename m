Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:19300 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1BHLDN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Feb 2011 06:03:13 -0500
Message-ID: <4D5122CF.3010403@nokia.com>
Date: Tue, 08 Feb 2011 13:02:39 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
MIME-Version: 1.0
To: "ext Bensaid, Selma" <selma.bensaid@intel.com>
CC: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"matti.j.aaltonen@nokia.com" <matti.j.aaltonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>		<4D4FDED0.7070008@redhat.com>		<20110207120234.GE10564@opensource.wolfsonmicro.com>		<4D4FEA03.7090109@redhat.com>		<20110207131045.GG10564@opensource.wolfsonmicro.com>		<4D4FF821.4010701@redhat.com>		<20110207135225.GJ10564@opensource.wolfsonmicro.com>	<1297088242.15320.62.camel@masi.mnp.nokia.com>	<4D501704.6060504@redhat.com> <4D5109B3.60504@nokia.com> <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
In-Reply-To: <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/08/11 12:09, ext Bensaid, Selma wrote:
> 2 Digital interfaces are possible for FM WL1273:
> - the external connection: the I2S lines are used for the FM PCM samples
> - the internal connection: the BT PCM interface is used for the FM PCM samples

Yes, that is correct, I just did not wanted to go into details.
Currently the ASoC codec driver only supports the BT/FM PCM interface.
Adding the dedicated I2S interface for the FM radio should not be a big
effort, we just need to add another dai to the codec driver, and connect
that to the host processor.
As I said before, we only implemented the BT/FM PCM interface support,
since we do not have HW, where we could verify the dedicated FM I2S
lines. But adding the support should not be a big deal IMHO (and can be
done even without any means of testing it).

> For both configuration we have a set of HCI commands to configure the FM audio 
> path and one of my concerns is to know if the wl1273_codec should handle the audio path configuration 
> and the switch between FM and BT SCO?

It would be better if the codec could handle the configuration,
depending on which DAI is in use. If we can send HCI commands from
kernel, I think that would be the cleanest way.

-- 
Péter
