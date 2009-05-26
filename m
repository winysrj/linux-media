Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:35670 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755548AbZEZSkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 14:40:08 -0400
Date: Tue, 26 May 2009 20:42:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartmann <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kay Sievers <kay.sievers@vrfy.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] dvb/dvb-usb: prepare for FIRMWARE_NAME_MAX removal
Message-ID: <20090526184216.GA10560@sortiz.org>
References: <20090526174012.423883376@linux.intel.com> <20090526174213.806710164@linux.intel.com> <37219a840905261132q6b0a7289x3408fb904ddf90df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37219a840905261132q6b0a7289x3408fb904ddf90df@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 26, 2009 at 02:32:45PM -0400, Michael Krufky wrote:
> On Tue, May 26, 2009 at 1:40 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > From: Samuel Ortiz <sameo@linux.intel.com>
> > To: Mauro Carvalho Chehab <mchehab@infradead.org>
> >
> > We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
> > firmware name length restriction.
> > This patch changes the dvb_usb_device_properties firmware field accordingly.
> >
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> >
> > ---
> >  drivers/media/dvb/dvb-usb/dvb-usb.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h
> > ===================================================================
> > --- iwm-2.6.orig/drivers/media/dvb/dvb-usb/dvb-usb.h    2009-05-26 17:24:36.000000000 +0200
> > +++ iwm-2.6/drivers/media/dvb/dvb-usb/dvb-usb.h 2009-05-26 17:25:19.000000000 +0200
> > @@ -196,7 +196,7 @@ struct dvb_usb_device_properties {
> >  #define CYPRESS_FX2     3
> >        int        usb_ctrl;
> >        int        (*download_firmware) (struct usb_device *, const struct firmware *);
> > -       const char firmware[FIRMWARE_NAME_MAX];
> > +       const char *firmware;
> >        int        no_reconnect;
> >
> >        int size_of_priv;
> >
> > --
> > Intel Open Source Technology Centre
> > http://oss.intel.com/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> Samuel,
> 
> Your patch makes the following change:
> 
> -       const char firmware[FIRMWARE_NAME_MAX];
> +       const char *firmware;
> 
> Before your change, struct dvb_usb_device_properties actually contains
> memory allocated for the firmware filename.  After your change, this
> is nothing but a pointer.
> 
> This will cause an OOPS.
No, not if it's correctly initialized, as it seems to be for all the
dvb_usb_device_properties users right now.
Typically, you'd initialize your dvb_usb_device_properties like this:

static struct dvb_usb_device_properties a800_properties = {
        .caps = DVB_USB_IS_AN_I2C_ADAPTER,

        .usb_ctrl = CYPRESS_FX2,
        .firmware = "dvb-usb-avertv-a800-02.fw",
[...]

And that's fine.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
