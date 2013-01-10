Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3AJRR0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 12:17:26 -0500
Date: Thu, 10 Jan 2013 15:16:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [dvb] Question on dvb-core re-structure
Message-ID: <20130110151646.14ff8fe4@redhat.com>
In-Reply-To: <20718.58869.396398.764373@morden.metzler>
References: <000801cdef1f$70667580$51336080$@codeaurora.org>
	<50EEA240.4060803@iki.fi>
	<000901cdef28$9ba87050$d2f950f0$@codeaurora.org>
	<20130110121304.1a24d5d3@redhat.com>
	<20718.58869.396398.764373@morden.metzler>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Jan 2013 17:01:57 +0100
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Mauro Carvalho Chehab writes:
>  > Em Thu, 10 Jan 2013 13:49:52 +0200
>  > "Hamad Kadmany" <hkadmany@codeaurora.org> escreveu:
>  > 
>  > > On 01/10/2013 1:13 PM, Antti Palosaari wrote:
>  > > > I could guess that even for the SoCs there is some bus used internally. 
>  > > > If it is not one of those already existing, then create new directly just
>  > > like one of those existing and put it there.
>  > > 
>  > > Thanks for the answer. I just wanted to clarify - it's integrated into the
>  > > chip and accessed via memory mapped registers, so I'm not sure which
>  > > category to give the new directory (parallel to pci/mms/usb). Should I just
>  > > put the adapter's sources directory directly under media directory?
>  > 
>  > That's the case of all other drivers under drivers/media/platform: they're
>  > IP blocks inside the SoC chip. I think that all arch-dependent drivers are
>  > there.
>  > 
>  > The menu needs to be renamed to "Media platform drivers" when the first DVB
>  > driver arrives there (it currently says V4L, as there's no DVB driver there
>  > yet). Feel free to add such patch on your patch series at the time you
>  > submit your driver, if nobody else submit any DVB platform driver earlier
>  > than yours.
> 
> 
> What about DVB cores which can be used via different busses?
> E.g. ddbridge initially only used PCIe. Now we also use the same function blocks
> (I2C, DVB input, etc.) connected to a SoC via an EBI (extension bus interface) 
> and register it as a platform device. Because a lot of code can be
> shared I do not want to split it over several directories. 

What we're doing on such cases is to put the common stuff under drivers/media/common
and the bus-specific (or platform-specific) code under drivers/media/pci,
drivers/media/usb, drivers/media/mmc, etc. There are, currenlty, 3 drivers
like that: saa7146 (the common code were always stored at /common), b2c2 and siano.

Cheers,
Mauro
