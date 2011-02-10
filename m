Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60865 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751947Ab1BJNXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 08:23:31 -0500
Date: Thu, 10 Feb 2011 13:23:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: "ext Bensaid, Selma" <selma.bensaid@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
Message-ID: <20110210132328.GC28336@opensource.wolfsonmicro.com>
References: <4D5109B3.60504@nokia.com>
 <2A84145621092446B6659B8A0F28E26F47010C29F1@irsmsx501.ger.corp.intel.com>
 <4D5122CF.3010403@nokia.com>
 <1297236165.15320.70.camel@masi.mnp.nokia.com>
 <2A84145621092446B6659B8A0F28E26F4703CC3968@irsmsx501.ger.corp.intel.com>
 <1297332223.15320.95.camel@masi.mnp.nokia.com>
 <20110210110205.GA28336@opensource.wolfsonmicro.com>
 <1297339840.15320.101.camel@masi.mnp.nokia.com>
 <20110210122842.GA29013@opensource.wolfsonmicro.com>
 <1297342667.15320.103.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297342667.15320.103.camel@masi.mnp.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Feb 10, 2011 at 02:57:47PM +0200, Matti J. Aaltonen wrote:

> And a comment to the above from the earlier mentioned local BT expert:
> "It would need some hack to generic hci code. Or maybe some kind of
> management api extension. That should be a few line only.. but getting
> it to upstream sounds like mission impossible."

I don't see any particular problem getting something like that upstream
if it works over multiple devices; we've already got stuff like that for
the Amstrad Delta platform.
