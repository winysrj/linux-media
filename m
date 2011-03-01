Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53655 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751011Ab1CALyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 06:54:39 -0500
Date: Tue, 1 Mar 2011 11:54:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v21 3/3] ASoC: WL1273 FM radio: Access I2C IO functions
 through pointers.
Message-ID: <20110301115436.GA9662@opensource.wolfsonmicro.com>
References: <1298966450-31814-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298966450-31814-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1298966450-31814-3-git-send-email-matti.j.aaltonen@nokia.com>
 <1298966450-31814-4-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298966450-31814-4-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 01, 2011 at 10:00:50AM +0200, Matti J. Aaltonen wrote:
> These changes are needed to keep up with the changes in the
> MFD core and V4L2 parts of the wl1273 FM radio driver.
> 
> Use function pointers instead of exported functions for I2C IO.
> Also move all preprocessor constants from the wl1273.h to
> include/linux/mfd/wl1273-core.h.
> 
> Also update the year in the copyright statement.

It's not actually doing that:

> - * Copyright:   (C) 2010 Nokia Corporation
> + * Copyright:   (C) 2011 Nokia Corporation

It's replacing it - portions are still 2010.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
