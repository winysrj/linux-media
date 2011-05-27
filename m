Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:58376 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1E0Ml3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:41:29 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QPwM4-0008MR-M6
	for linux-media@vger.kernel.org; Fri, 27 May 2011 14:41:28 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 27 May 2011 14:41:28 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 27 May 2011 14:41:28 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: PCTV nanoStick T2 290e support - Thank you!
Date: Fri, 27 May 2011 14:41:14 +0200
Message-ID: <87ipsws4d1.fsf@nemi.mork.no>
References: <1306445141.14462.0.camel@porites> <4DDEDB0E.30108@iki.fi>
	<8739k0tlx6.fsf@nemi.mork.no> <1306498221.4412.179.camel@ares>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Steve Kerrison <steve@stevekerrison.com> writes:

> The demodulator chip supports T,T2 and C.
>
> Here in the UK you're not really allowed to attach cable receivers that
> aren't supplied by the cable company (Virgin Media). That and the fact
> that it has no access module for obvious reasons, I guess PCTV Systems
> didn't see the benefit in marketing the C functionality.

Well, I found it a bit weird that they do announce DVB-T + DVB-C support
for the "PCTV QuatroStick nano" (which has the exact same form factor
and look, and therefore obviously no CA slot either):
http://www.pctvsystems.com/Products/ProductsEuropeAsia/Hybridproducts/PCTVQuatroSticknano/tabid/254/language/en-GB/Default.aspx

While the "PCTV nanoStick T2" is announced as only DVB-T2 + DVB-T:
http://www.pctvsystems.com/Products/ProductsEuropeAsia/Digitalproducts/PCTVnanoStickT2/tabid/248/language/en-GB/Default.aspx

That's why I asked, even though the driver clearly supports DVB-C.  But
you may be right that this is because the "nanoStick T2" currently is
targeted for the UK.

Around here, we've actually got some cable companies supporting TV sets
with integrated receivers.  Of course requiring their CAM.  They
probably still don't like the thought of PC based receivers, but there
is some hope...


> I don't actually know if the windows driver supports C mode, it would be
> amusing if we deliver more functionality with the Linux driver :)

I thought downloading the Windows driver would tell, but
a) I cannot seem to find the Windows driver for this device, and
b) this info isn't easily found in the drivers I looked at

So who knows?  It would certainly be amusing.


Bjørn

