Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46403 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753786Ab2EFPpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 11:45:50 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Thomas Mair <thomas.mair86@googlemail.com>
Subject: Re: [PATCH v3 1/3] Modified RTL28xxU driver to work with RTL2832
Date: Sun, 6 May 2012 17:45:46 +0200
Cc: linux-media@vger.kernel.org
References: <CAKZ=SG9U48d=eE3avccR-Auao5UMo0OANw8KKb=MP1XPtkHwmg@mail.gmail.com> <201205061737.18561.hfvogt@gmx.net>
In-Reply-To: <201205061737.18561.hfvogt@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205061745.46363.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, 6. Mai 2012 schrieb Hans-Frieder Vogt:
> Am Sonntag, 6. Mai 2012 schrieben Sie:
> > Hi everyone,
> > 
> > this is the first complete version of the rtl2832 demod driver. I
> > splitted the patches in three parts:
> > 1. changes in the dvb-usb part (dvb_usb_rtl28xxu)
> > 2. demod driver (rtl2832)
> > 3. tuner driver (fc0012)

[...]

> > + * Realtek RTL28xxU DVB USB driver
> > + *
> > + * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
> > + * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
> > + *
> > + *    This program is free software; you can redistribute it and/or
> > modify + *    it under the terms of the GNU General Public License as
> > published by + *    the Free Software Foundation; either version 2 of
> > the License, or + *    (at your option) any later version.
> > + *
> > + *    This program is distributed in the hope that it will be useful,
> > + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *    GNU General Public License for more details.
> > + *
> > + *    You should have received a copy of the GNU General Public License
> > along + *    with this program; if not, write to the Free Software
> > Foundation, Inc., + *    51 Franklin Street, Fifth Floor, Boston, MA
> > 02110-1301 USA. + */
> 
> something went wrong here.
> 
forget this comment. I fell into the same "line wrap" trap...

> > +
> > +#ifndef RTL28XXU_TUNERS_H
> > +#define RTL28XXU_TUNERS_H

[...]

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
