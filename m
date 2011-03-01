Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:9050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab1CANuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:50:44 -0500
Date: Tue, 1 Mar 2011 14:50:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	mchehab@redhat.com, hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [PATCH v22 3/3] ASoC: WL1273 FM radio: Access I2C IO functions
 through pointers.
Message-ID: <20110301135040.GB4543@sortiz-mobl>
References: <1298985037-2714-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298985037-2714-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1298985037-2714-3-git-send-email-matti.j.aaltonen@nokia.com>
 <1298985037-2714-4-git-send-email-matti.j.aaltonen@nokia.com>
 <20110301132315.GD9662@opensource.wolfsonmicro.com>
 <1298987085.29371.123.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298987085.29371.123.camel@masi.mnp.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 01, 2011 at 03:44:45PM +0200, Matti J. Aaltonen wrote:
> On Tue, 2011-03-01 at 13:23 +0000, ext Mark Brown wrote:
> > On Tue, Mar 01, 2011 at 03:10:37PM +0200, Matti J. Aaltonen wrote:
> > > These changes are needed to keep up with the changes in the
> > > MFD core and V4L2 parts of the wl1273 FM radio driver.
> > > 
> > > Use function pointers instead of exported functions for I2C IO.
> > > Also move all preprocessor constants from the wl1273.h to
> > > include/linux/mfd/wl1273-core.h.
> > > 
> > > Also update the year in the copyright statement.
> > > 
> > > Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > *Please* keep acks unless you're making substantial changes to
> > repostings.
> 
> OK, I see, I should have added the ACKs to the relevant driver files
> instead of copying them to the cover letter...
Yes, it makes it easier for the maintainer taking your patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
