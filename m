Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:41323 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab1CANpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:45:05 -0500
Subject: Re: [PATCH v22 3/3] ASoC: WL1273 FM radio: Access I2C IO functions
 through pointers.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <20110301132315.GD9662@opensource.wolfsonmicro.com>
References: <1298985037-2714-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1298985037-2714-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1298985037-2714-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1298985037-2714-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <20110301132315.GD9662@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 15:44:45 +0200
Message-ID: <1298987085.29371.123.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-03-01 at 13:23 +0000, ext Mark Brown wrote:
> On Tue, Mar 01, 2011 at 03:10:37PM +0200, Matti J. Aaltonen wrote:
> > These changes are needed to keep up with the changes in the
> > MFD core and V4L2 parts of the wl1273 FM radio driver.
> > 
> > Use function pointers instead of exported functions for I2C IO.
> > Also move all preprocessor constants from the wl1273.h to
> > include/linux/mfd/wl1273-core.h.
> > 
> > Also update the year in the copyright statement.
> > 
> > Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> *Please* keep acks unless you're making substantial changes to
> repostings.

OK, I see, I should have added the ACKs to the relevant driver files
instead of copying them to the cover letter...

Cheers,
Matti

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


