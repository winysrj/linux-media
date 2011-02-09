Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:63433 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1BIH2R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 02:28:17 -0500
Subject: Re: [alsa-devel] WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	alsa-devel@alsa-project.org, sameo@linux.intel.com,
	ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
	hverkuil@xs4all.nl, lrg@slimlogic.co.uk,
	linux-media@vger.kernel.org
In-Reply-To: <4D5109B3.60504@nokia.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <20110207131045.GG10564@opensource.wolfsonmicro.com>
	 <4D4FF821.4010701@redhat.com>
	 <20110207135225.GJ10564@opensource.wolfsonmicro.com>
	 <1297088242.15320.62.camel@masi.mnp.nokia.com>
	 <4D501704.6060504@redhat.com>  <4D5109B3.60504@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:27:32 +0200
Message-ID: <1297236452.15320.74.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-08 at 11:15 +0200, Peter Ujfalusi 
> 
> I have not looked deeply into the wl1273 datasheets, but I'm sure
> there's a way to nicely divide the parts between the MFD, V4L, and ASoC.
> 

I don't think there's much to be moved between the sub-systems after
moving the I2C communication to the MFD driver (which has almost been
agreed on).

Cheers,
Matti



