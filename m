Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:27688 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1BJM6j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 07:58:39 -0500
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "ext Bensaid, Selma" <selma.bensaid@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
In-Reply-To: <20110210122842.GA29013@opensource.wolfsonmicro.com>
References: <1297088242.15320.62.camel@masi.mnp.nokia.com>
	 <4D501704.6060504@redhat.com> <4D5109B3.60504@nokia.com>
	 <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
	 <4D5122CF.3010403@nokia.com> <1297236165.15320.70.camel@masi.mnp.nokia.com>
	 <2A84145621092446B6659B8A0F28E26F4703CC3968@irsmsx501.ger.corp.intel.com>
	 <1297332223.15320.95.camel@masi.mnp.nokia.com>
	 <20110210110205.GA28336@opensource.wolfsonmicro.com>
	 <1297339840.15320.101.camel@masi.mnp.nokia.com>
	 <20110210122842.GA29013@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 14:57:47 +0200
Message-ID: <1297342667.15320.103.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-02-10 at 12:28 +0000, ext Mark Brown wrote:
> On Thu, Feb 10, 2011 at 02:10:40PM +0200, Matti J. Aaltonen wrote:
> 
> > But I got the following quick comment from a local BT expert: "No you
> > cannot change line discipline if bt is already in use. And it's not uart
> > interface but hci interface. uart can be replaced with sdio for example
> > and you still have the same hci interface."
> 
> Yes, it only works when the device is idle - if your device needs to be
> shared with other bits of the system while doing this you'd need to
> present a virtual interface up the way.

And a comment to the above from the earlier mentioned local BT expert:
"It would need some hack to generic hci code. Or maybe some kind of
management api extension. That should be a few line only.. but getting
it to upstream sounds like mission impossible."

