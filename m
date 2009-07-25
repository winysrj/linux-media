Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31047 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZGYPW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 11:22:26 -0400
Date: Sat, 25 Jul 2009 18:11:43 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv11 8/8] FM TX: si4713: Add document file
Message-ID: <20090725151143.GA21232@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1248533862-20860-1-git-send-email-eduardo.valentin@nokia.com>
 <1248533862-20860-8-git-send-email-eduardo.valentin@nokia.com>
 <1248533862-20860-9-git-send-email-eduardo.valentin@nokia.com>
 <200907251719.29801.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907251719.29801.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 25, 2009 at 05:19:29PM +0200, ext Hans Verkuil wrote:
> On Saturday 25 July 2009 16:57:42 Eduardo Valentin wrote:
> > This patch adds a document file for si4713 device driver.
> > It describes the driver interfaces and organization.
> > 
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  linux/Documentation/video4linux/si4713.txt |  176 ++++++++++++++++++++++++++++
> >  1 files changed, 176 insertions(+), 0 deletions(-)
> >  create mode 100644 linux/Documentation/video4linux/si4713.txt
> > 
> > diff --git a/linux/Documentation/video4linux/si4713.txt b/linux/Documentation/video4linux/si4713.txt
> > new file mode 100644
> > index 0000000..8b97fb6
> > --- /dev/null
> > +++ b/linux/Documentation/video4linux/si4713.txt
> > @@ -0,0 +1,176 @@
> > +Driver for I2C radios for the Silicon Labs Si4713 FM Radio Transmitters
> > +
> > +Copyright (c) 2009 Nokia Corporation
> > +Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > +
> > +
> > +Information about the Device
> > +============================
> > +This chip is a Silicon Labs product. It is a I2C device, currently on 0×63 address.
> 
> Something went wrong here with the i2c address, it should probably be '0x63'.
> I don't know whether this is in your original text or whether it got messed
> up in some mailer.

It got messed during the mailing processes somehow. I'll resend only this one.

> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
