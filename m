Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:60600 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965146Ab1GOI0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 04:26:31 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19999.63914.990114.26990@morden.metzler>
Date: Fri, 15 Jul 2011 10:26:18 +0200
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
In-Reply-To: <201107150717.08944@orion.escape-edv.de>
References: <201107032321.46092@orion.escape-edv.de>
	<4E1F8E1F.3000008@redhat.com>
	<4E1FBA6F.10509@redhat.com>
	<201107150717.08944@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss writes:
 > > Both ngene and ddbrige calls dvb_attach once for drxk_attach.
 > > The logic used there, and by tda18271c2dd driver is different
 > > from similar logic on other frontends.
 > > 
 > > The right fix is to change them to use the same logic, but,
 > > while we don't do that, we need to patch em28xx-dvb in order
 > > to do cope with ngene/ddbridge magic.
 > 
 > I disagree: The right fix is to extend the framework, and drop the
 > secondary frondend completely. The current way of supporting
 > multi-standard tuners is abusing the DVB API.
 > 

Yes, exactly what I wanted to say.

I am just working on yet another C/T combo. This time stv0367 and
TDA18212. For both there are existing drivers and our own version again.
I am trying to merge them so that there is not yet another
discussion regarding new driver versions (but the very first version
might still come out with separate drivers).
At the same time I want to add delivery system properties to 
support everything in one frontend device.
Adding a parameter to select C or T as default should help in most
cases where the application does not support switching yet.

Regards,
Ralph

