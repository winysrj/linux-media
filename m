Return-path: <mchehab@pedra>
Received: from mga11.intel.com ([192.55.52.93]:42177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab1B1Qu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 11:50:27 -0500
Date: Mon, 28 Feb 2011 17:50:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v20 1/3] MFD: Wl1273 FM radio core: Add I2C IO
 functions.
Message-ID: <20110228165023.GD5263@sortiz-mobl>
References: <1298890951-23339-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298890951-23339-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298890951-23339-2-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

On Mon, Feb 28, 2011 at 01:02:29PM +0200, Matti J. Aaltonen wrote:
> Add I2C IO functions.
> Change the IO operation from read to write in wl1273_fm_set_volume.
> Update the year of the copyright statement.
> Remove two unnecessary calls to i2c_set_clientdata.
Provided that you add a changelog relevant to the patch itself, and not to the
v1->v2 diff:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
