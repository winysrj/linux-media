Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:46488 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1E0M4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:56:17 -0400
Subject: Re: PCTV nanoStick T2 290e support - Thank you!
From: Steve Kerrison <steve@stevekerrison.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <87ipsws4d1.fsf@nemi.mork.no>
References: <1306445141.14462.0.camel@porites> <4DDEDB0E.30108@iki.fi>
	 <8739k0tlx6.fsf@nemi.mork.no> <1306498221.4412.179.camel@ares>
	 <87ipsws4d1.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 13:56:13 +0100
Message-ID: <1306500973.4412.184.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bjørn,

> I thought downloading the Windows driver would tell, but
> a) I cannot seem to find the Windows driver for this device, and
> b) this info isn't easily found in the drivers I looked at

The bundled CD has the drivers on it, but I think it's also in the
driver bundle on their site for their other empia based cards:

ftp://ftp.pctvsystems.com/TV/driver/PCTV%2070e%2080e%20100e%20320e%
20330e%20800e/PCTV%2070e%2080e%20100e%20320e%20330e%20800e%20880e.zip

Found via
http://www.pctvsystems.com/tabid/62/default.aspx/Downloads/Driver/tabid/123/language/en-GB/Default.aspx

I'm not sure how you'd tell, other than perhaps firing up VLC on Windows
and seeing if you can open it as a DVB-C device?

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Fri, 2011-05-27 at 14:41 +0200, Bjørn Mork wrote:
> Steve Kerrison <steve@stevekerrison.com> writes:
> 
> > The demodulator chip supports T,T2 and C.
> >
> > Here in the UK you're not really allowed to attach cable receivers that
> > aren't supplied by the cable company (Virgin Media). That and the fact
> > that it has no access module for obvious reasons, I guess PCTV Systems
> > didn't see the benefit in marketing the C functionality.
> 
> Well, I found it a bit weird that they do announce DVB-T + DVB-C support
> for the "PCTV QuatroStick nano" (which has the exact same form factor
> and look, and therefore obviously no CA slot either):
> http://www.pctvsystems.com/Products/ProductsEuropeAsia/Hybridproducts/PCTVQuatroSticknano/tabid/254/language/en-GB/Default.aspx
> 
> While the "PCTV nanoStick T2" is announced as only DVB-T2 + DVB-T:
> http://www.pctvsystems.com/Products/ProductsEuropeAsia/Digitalproducts/PCTVnanoStickT2/tabid/248/language/en-GB/Default.aspx
> 
> That's why I asked, even though the driver clearly supports DVB-C.  But
> you may be right that this is because the "nanoStick T2" currently is
> targeted for the UK.
> 
> Around here, we've actually got some cable companies supporting TV sets
> with integrated receivers.  Of course requiring their CAM.  They
> probably still don't like the thought of PC based receivers, but there
> is some hope...
> 
> 
> > I don't actually know if the windows driver supports C mode, it would be
> > amusing if we deliver more functionality with the Linux driver :)
> 
> I thought downloading the Windows driver would tell, but
> a) I cannot seem to find the Windows driver for this device, and
> b) this info isn't easily found in the drivers I looked at
> 
> So who knows?  It would certainly be amusing.
> 
> 
> Bjørn
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

