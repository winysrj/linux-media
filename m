Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4400 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZKIKGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 05:06:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
Date: Mon, 9 Nov 2009 11:06:38 +0100
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
References: <1257630681.15927.423.camel@localhost> <1257645238.15927.624.camel@localhost> <1257646136.7399.18.camel@palomino.walls.org>
In-Reply-To: <1257646136.7399.18.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911091106.38894.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 08 November 2009 03:08:56 Andy Walls wrote:
> On Sun, 2009-11-08 at 01:53 +0000, Ben Hutchings wrote:
> > On Sat, 2009-11-07 at 20:40 -0500, Andy Walls wrote:
> > > On Sat, 2009-11-07 at 21:51 +0000, Ben Hutchings wrote:
> 
> > > >  
> > > > +MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
> > > > +
> > > 
> > > Ben,
> > > 
> > > This particular firmware is only needed by one relatively rare TV card.
> > > Is there any way for MODULE_FIRMWARE advertisements to hint at
> > > "mandatory" vs. "particular case(s)"?
> > 
> > No, but perhaps there ought to be.  In this case the declaration could
> > be left out for now.  It is only critical to list all firmware in
> > drivers that may be needed for booting.
> 
> OK.  I don't know that a TV card driver is every *needed* for booting.
> Maybe one day when I can net-boot with cable-modem like
> functionality... ;)
> 
> 
> I'm OK with the MODULE_FIRMWARE announcements in cx18 so long as
> automatic behaviors like
> 
> 1. persistent, repeatitive, or truly alarming user warnings, or
> 2. refusing to load the module due to missing firmware files
> 
> don't happen.

I agree with Andy here.

In the case of ivtv and cx18 (unless that changed since the last time I worked
on it) the cx firmware is actually not loaded when the module is inited but on
the first open() call. So it is not even that clear to me whether we want to
have these fairly large fw files in an initramfs image at all.

Regards,

	Hans

> 
> Regards,
> Andy
> 
> > Ben.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
