Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:27243 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbZKYWwB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 17:52:01 -0500
Subject: Re: IR raw input is not sutable for input system
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Sean Young <sean@mess.org>, Trent Piepho <xyzzy@speakeasy.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <m3d43644q6.fsf@intrepid.localdomain>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <20091123173726.GE17813@core.coreip.homeip.net>
	 <4B0B6321.3050001@wilsonet.com> <1259105571.28219.20.camel@maxim-laptop>
	 <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net>
	 <1259155734.4875.23.camel@maxim-laptop>
	 <20091125213246.GA44831@atlantis.8hz.com>
	 <m3d43644q6.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 00:52:02 +0200
Message-ID: <1259189522.15916.1.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-25 at 23:30 +0100, Krzysztof Halasa wrote: 
> Sean Young <sean@mess.org> writes:
> 
> > Absolutely. There are a number of use cases when you want access to the 
> > space-pulse (i.e. IR) information.
> 
> I think nobody proposes otherwise (except for devices which can't pass
> this info).

I think we were taking about such devices.

I have no objection that devices that *do* decode the protocol, they
should be handled inside kernel.

But devices that send raw pulse/space data should be handled in lirc
that will feed the data back to the kernel via uinput.

Best regards,
Maxim Levitsky

