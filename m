Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:37929 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab1BGORm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 09:17:42 -0500
Subject: Re: WL1273 FM Radio driver...
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	alsa-devel@alsa-project.org, lrg@slimlogic.co.uk,
	hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
In-Reply-To: <20110207135225.GJ10564@opensource.wolfsonmicro.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
	 <4D4FDED0.7070008@redhat.com>
	 <20110207120234.GE10564@opensource.wolfsonmicro.com>
	 <4D4FEA03.7090109@redhat.com>
	 <20110207131045.GG10564@opensource.wolfsonmicro.com>
	 <4D4FF821.4010701@redhat.com>
	 <20110207135225.GJ10564@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 16:17:22 +0200
Message-ID: <1297088242.15320.62.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-02-07 at 13:52 +0000, ext Mark Brown wrote:
> On Mon, Feb 07, 2011 at 11:48:17AM -0200, Mauro Carvalho Chehab wrote:
> > Em 07-02-2011 11:10, Mark Brown escreveu:
> 
> > > There is an audio driver for this chip and it is using those functions.
> 
> > Where are the other drivers that depend on it?
> 
> Nothing's been merged yet to my knowledge, Matti can comment on any
> incoming boards which will use it (rx51?).

Yes, nothing's been merged yet. There are only dependencies between the
parts of this driver... I cannot comment on upcoming boards, I just hope
we could agree on a sensible structure for this thing.

Matti.




