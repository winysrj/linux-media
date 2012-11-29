Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:50939 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2K2Wzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 17:55:38 -0500
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Thu, 29 Nov 2012 23:54:20 +0100
To: Antti Palosaari <crope@iki.fi>
Cc: Juergen Lock <nox@jelal.kn-bremen.de>, linux-media@vger.kernel.org,
	hselasky@c2i.net
Subject: Re: [PATCH] [media] rtl28xxu: add Terratec Cinergy T Stick RC rev 3
Message-ID: <20121129225420.GA11174@triton8.kn-bremen.de>
References: <20121129205259.GA7548@triton8.kn-bremen.de>
 <50B7D1E2.8000600@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B7D1E2.8000600@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 29, 2012 at 11:21:38PM +0200, Antti Palosaari wrote:
> On 11/29/2012 10:52 PM, Juergen Lock wrote:
> > This just adds the usbid to the rtl28xxu driver, that's all that's
> > needed to make the stick work for DVB.
> >
> > Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>
> >
> > --- a/drivers/media/dvb-core/dvb-usb-ids.h
> > +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> > @@ -162,6 +162,7 @@
> >   #define USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2		0x0069
> >   #define USB_PID_TERRATEC_CINERGY_T_STICK		0x0093
> >   #define USB_PID_TERRATEC_CINERGY_T_STICK_RC		0x0097
> > +#define USB_PID_TERRATEC_CINERGY_T_STICK_RC_REV3	0x00d3
> >   #define USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC	0x0099
> >   #define USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1	0x00a9
> >   #define USB_PID_TWINHAN_VP7041_COLD			0x3201
> > --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> > +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> > @@ -1340,6 +1340,8 @@ static const struct usb_device_id rtl28x
> >   		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
> >   	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
> >   		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle (rev 2)", NULL) },
> > +	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_RC_REV3,
> > +		&rtl2832u_props, "Terratec Cinergy T Stick RC (rev 3)", NULL) },
> >   	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
> >   		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
> >   	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
> > --
> 
> That patch is already applied!
> 
> Due to that, nack. It is non-relevant.
> 
Heh, whoops, even better! :)

 Thanx,
	Juergen
