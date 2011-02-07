Return-path: <mchehab@pedra>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53852 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752701Ab1BGNw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 08:52:28 -0500
Date: Mon, 7 Feb 2011 13:52:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: matti.j.aaltonen@nokia.com, alsa-devel@alsa-project.org,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110207135225.GJ10564@opensource.wolfsonmicro.com>
References: <1297075922.15320.31.camel@masi.mnp.nokia.com>
 <4D4FDED0.7070008@redhat.com>
 <20110207120234.GE10564@opensource.wolfsonmicro.com>
 <4D4FEA03.7090109@redhat.com>
 <20110207131045.GG10564@opensource.wolfsonmicro.com>
 <4D4FF821.4010701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4FF821.4010701@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 07, 2011 at 11:48:17AM -0200, Mauro Carvalho Chehab wrote:
> Em 07-02-2011 11:10, Mark Brown escreveu:

> > There is an audio driver for this chip and it is using those functions.

> Where are the other drivers that depend on it?

Nothing's been merged yet to my knowledge, Matti can comment on any
incoming boards which will use it (rx51?).

Note that due to the decomposed nature of embedded audio hardware the
audio part of the chip needs to be represended within the audio
subsystem even if the control were all in the media side - this isn't an
isolated bit of hardware on an expansion card, it's fairly tightly
coupled into the rest of the system.
