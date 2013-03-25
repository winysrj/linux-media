Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4854 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3CYI5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 04:57:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEW PATCH 19/42] s2250-loader: use usbv2_cypress_load_firmware
Date: Mon, 25 Mar 2013 09:56:48 +0100
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl> <400666fef6bc62079f4ebd7122196c753039aaad.1363000605.git.hans.verkuil@cisco.com> <20130324123924.2451beb9@redhat.com>
In-Reply-To: <20130324123924.2451beb9@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250956.48549.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 16:39:24 Mauro Carvalho Chehab wrote:
> Em Mon, 11 Mar 2013 12:45:57 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The v2 of this function doesn't do DMA to objects on the stack like
> > its predecessor does.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/staging/media/go7007/Makefile       |    4 ++--
> >  drivers/staging/media/go7007/s2250-loader.c |    7 ++++---
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
> > index 5bed78b..f9c8e0f 100644
> > --- a/drivers/staging/media/go7007/Makefile
> > +++ b/drivers/staging/media/go7007/Makefile
> > @@ -11,8 +11,8 @@ s2250-y := s2250-board.o
> >  #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
> >  #ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
> >  
> > -# S2250 needs cypress ezusb loader from dvb-usb
> > -ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb
> > +# S2250 needs cypress ezusb loader from dvb-usb-v2
> > +ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb-v2
> 
> Please don't do it like that. Ok, for now it is in staging,
> but once you move it outside it, please move the cypress load firmware
> code to drivers/media/common, and do the proper changes for it to be
> shared between go7007 and dvb-usb-v2.

It's a good idea to move this to common. I'll do that.

Regards,

	Hans
