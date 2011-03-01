Return-path: <mchehab@pedra>
Received: from mga01.intel.com ([192.55.52.88]:9814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab1CALoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 06:44:07 -0500
Date: Tue, 1 Mar 2011 12:43:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v21 1/3] MFD: WL1273 FM Radio: MFD driver for the FM
 radio.
Message-ID: <20110301114353.GA4543@sortiz-mobl>
References: <1298966450-31814-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298966450-31814-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298966450-31814-2-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

On Tue, Mar 01, 2011 at 10:00:48AM +0200, Matti J. Aaltonen wrote:
> This is the core of the WL1273 FM radio driver, it connects
> the two child modules. The two child drivers are
> drivers/media/radio/radio-wl1273.c and sound/soc/codecs/wl1273.c.
> 
> The radio-wl1273 driver implements the V4L2 interface and communicates
> with the device. The ALSA codec offers digital audio, without it only
> analog audio is available.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Mauro, I suppose you're taking this one ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
