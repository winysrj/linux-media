Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43389 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbcGPQrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 12:47:13 -0400
Date: Sat, 16 Jul 2016 13:47:07 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Benjamin Larsson <benjamin@southpole.se>,
	linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>,
	Christian Zippel <namerp@gmail.com>
Subject: Re: [PATCH] [media] dw2102: Add support for Terratec Cinergy S2 USB
 BOX
Message-ID: <20160716134707.6cf426ea@recife.lan>
In-Reply-To: <CAAZRmGz5vS8vMBEQeMo6BS0XijoCj655jha5vCsiy2P8TcgSoQ@mail.gmail.com>
References: <1451935971-31402-1-git-send-email-p.zabel@pengutronix.de>
	<CAAZRmGz5vS8vMBEQeMo6BS0XijoCj655jha5vCsiy2P8TcgSoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 16 Jul 2016 18:26:35 +0200
Olli Salonen <olli.salonen@iki.fi> escreveu:

> Hi guys,
> 
> It seems Philipp added the support for this device in dw2102 driver
> and Benjamin did that for the dvbsky driver a bit earlier.
> 
> # grep -i 0ccdp0105 /lib/modules/$(uname -r)/modules.alias
> alias usb:v0CCDp0105d*dc*dsc*dp*ic*isc*ip*in* dvb_usb_dvbsky
> alias usb:v0CCDp0105d*dc*dsc*dp*ic*isc*ip*in* dvb_usb_dw2102
> 
> Any suggestions on how to resolve this conflict?

Let me understand something: the same chipset is supported by both
modules? Or the device at dvbsky uses a different hardware than
the one at dw2102? In the latter case, sometimes it is possible
to distinguish the hardware based on the USB release info. We have
a few cases like that. One that comes on my mind is a pixelview
device, that uses the same ID for two different devices:

cx231xx:

{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000, 0x4001),
	 .driver_info = CX231XX_BOARD_PV_PLAYTV_USB_HYBRID},

dib0700:

    { USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x000, 0x3f00) },

Regards,
Mauro



> 
> Cheers,
> -olli
> 
> On 4 January 2016 at 20:32, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > The Terratec Cinergy S2 USB BOX uses a Montage M88TS2022 tuner
> > and a M88DS3103 demodulator, same as Technotrend TT-connect S2-4600.
> > This patch adds the missing USB Product ID to make it work.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/usb/dvb-usb/dw2102.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> > index 14ef25d..9d18801 100644
> > --- a/drivers/media/usb/dvb-usb/dw2102.c
> > +++ b/drivers/media/usb/dvb-usb/dw2102.c
> > @@ -1688,6 +1688,7 @@ enum dw2102_table_entry {
> >         TECHNOTREND_S2_4600,
> >         TEVII_S482_1,
> >         TEVII_S482_2,
> > +       TERRATEC_CINERGY_S2_BOX,
> >  };
> >
> >  static struct usb_device_id dw2102_table[] = {
> > @@ -1715,6 +1716,7 @@ static struct usb_device_id dw2102_table[] = {
> >                 USB_PID_TECHNOTREND_CONNECT_S2_4600)},
> >         [TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
> >         [TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
> > +       [TERRATEC_CINERGY_S2_BOX] = {USB_DEVICE(USB_VID_TERRATEC, 0x0105)},
> >         { }
> >  };
> >
> > @@ -2232,7 +2234,7 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
> >                 } },
> >                 }
> >         },
> > -       .num_device_descs = 3,
> > +       .num_device_descs = 4,
> >         .devices = {
> >                 { "TechnoTrend TT-connect S2-4600",
> >                         { &dw2102_table[TECHNOTREND_S2_4600], NULL },
> > @@ -2246,6 +2248,10 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
> >                         { &dw2102_table[TEVII_S482_2], NULL },
> >                         { NULL },
> >                 },
> > +               { "Terratec Cinergy S2 USB BOX",
> > +                       { &dw2102_table[TERRATEC_CINERGY_S2_BOX], NULL },
> > +                       { NULL },
> > +               },
> >         }
> >  };
> >
> > --
> > 2.6.2
> >  


-- 
Thanks,
Mauro
