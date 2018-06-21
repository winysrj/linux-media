Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbeFUSg6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 14:36:58 -0400
Date: Fri, 22 Jun 2018 03:36:40 +0900
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, niklas.soderlund@ragnatech.se,
        jerry.w.hu@intel.com, mario.limonciello@dell.com
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180622033640.298f6ee1@vela.lan>
In-Reply-To: <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
References: <20180620203838.GA13372@amd>
        <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jun 2018 16:57:59 -0400
Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:

> The IPU3 sensor produce a vendor specific form of bayer. If we manage
> to implement support for this format, it would likely be done in
> software. I don't think anyone can answer your other questions has no
> one have ever implemented this, hence measure performance.

Decoding that bayer-like specific format is something that we currently
do at libv4lconvert. IMHO, we should have support for it inside the
library, even if the device is capable of decoding it via a mem2mem
device. If not for usage in "production", being able to read it from
the sensor directly helps to test it. It might also be used on some
applications where there would be no need for 3A algorithms to run
(for example, on industrial cameras where the light and the distance of
the objects don't change).


Cheers,
Mauro
