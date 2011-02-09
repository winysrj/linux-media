Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:23868 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1BIHPV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 02:15:21 -0500
Subject: RE: [alsa-devel] WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "ext Bensaid, Selma" <selma.bensaid@intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
In-Reply-To: <2A84145621092446B6659B8A0F28E26F47010C2B07@irsmsx501.ger.corp.intel.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <20110207131045.GG10564@opensource.wolfsonmicro.com>
	 <4D4FF821.4010701@redhat.com>
	 <20110207135225.GJ10564@opensource.wolfsonmicro.com>
	 <1297088242.15320.62.camel@masi.mnp.nokia.com>
	 <4D501704.6060504@redhat.com> <4D5109B3.60504@nokia.com>
	 <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
	 <4D5122CF.3010403@nokia.com>
	 <2A84145621092446B6659B8A0F28E26F47010C2B07@irsmsx501.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:14:26 +0200
Message-ID: <1297235666.15320.65.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-08 at 13:47 +0000, ext Bensaid, Selma wrote:
> > > For both configuration we have a set of HCI commands to configure the FM
> > audio
> > > path and one of my concerns is to know if the wl1273_codec should handle the
> > audio path configuration
> > > and the switch between FM and BT SCO?
> > 
> > It would be better if the codec could handle the configuration,
> > depending on which DAI is in use. If we can send HCI commands from
> > kernel, I think that would be the cleanest way.
> If we use the Combined Interface Mode (host controls both the BT and FM 
> radio via BT HCI) this could be possible. However, you use the Separate 
> Interface (FM controlled vi I2C). 
> Is there a plan to handle also the Combined Interface Mode for WL1273 FM Radio driver?

We haven't yet had need for the UART interface but it has been the idea
to have them both eventually...

Cheers,
Matti



> 
> Selma.
> > --
> > Péter
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 


