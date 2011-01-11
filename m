Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:36511 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753407Ab1AKBXI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 20:23:08 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Debug code in HG repositories
Date: Tue, 11 Jan 2011 02:20:59 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
References: <201101072053.37211@orion.escape-edv.de> <4D2AF5E6.1070007@redhat.com> <4D2AFB1D.5080708@redhat.com>
In-Reply-To: <4D2AFB1D.5080708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101110221.01249@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 10 January 2011 13:27:09 Mauro Carvalho Chehab wrote:
> > ...
> > diff -upr /tmp/stripped/drivers/media/dvb/ngene/ngene-cards.c /tmp/not_stripped/drivers/media/dvb/ngene/ngene-cards.c
> > --- /tmp/stripped/drivers/media/dvb/ngene/ngene-cards.c	2011-01-10 10:01:49.000000000 -0200
> > +++ /tmp/not_stripped/drivers/media/dvb/ngene/ngene-cards.c	2011-01-10 10:02:05.000000000 -0200
> > @@ -272,6 +272,32 @@ static const struct pci_device_id ngene_
> >  	NGENE_ID(0x18c3, 0xdd10, ngene_info_duoFlexS2),
> >  	NGENE_ID(0x18c3, 0xdd20, ngene_info_duoFlexS2),
> >  	NGENE_ID(0x1461, 0x062e, ngene_info_m780),
> > +#if 0 /* not (yet?) supported */
> > +	NGENE_ID(0x18c3, 0x0000, ngene_info_appboard),
> > +	NGENE_ID(0x18c3, 0x0004, ngene_info_appboard),
> > +	NGENE_ID(0x18c3, 0x8011, ngene_info_appboard),
> > +	NGENE_ID(0x18c3, 0x8015, ngene_info_appboard_ntsc),
> > +	NGENE_ID(0x153b, 0x1167, ngene_info_terratec),
> > +	NGENE_ID(0x18c3, 0x0030, ngene_info_python),
> > +	NGENE_ID(0x18c3, 0x0052, ngene_info_sidewinder),
> > +	NGENE_ID(0x18c3, 0x8f00, ngene_info_racer),
> > +	NGENE_ID(0x18c3, 0x0041, ngene_info_viper_v1),
> > +	NGENE_ID(0x18c3, 0x0042, ngene_info_viper_v2),
> > +	NGENE_ID(0x14f3, 0x0041, ngene_info_vbox_v1),
> > +	NGENE_ID(0x14f3, 0x0043, ngene_info_vbox_v2),
> > +	NGENE_ID(0x18c3, 0xabcd, ngene_info_s2),
> > +	NGENE_ID(0x18c3, 0xabc2, ngene_info_s2_b),
> > +	NGENE_ID(0x18c3, 0xabc3, ngene_info_s2_b),
> > +	NGENE_ID(0x18c3, 0x0001, ngene_info_appboard),
> > +	NGENE_ID(0x18c3, 0x0005, ngene_info_appboard),
> > +	NGENE_ID(0x18c3, 0x0009, ngene_info_appboard_atsc),
> > +	NGENE_ID(0x18c3, 0x000b, ngene_info_appboard_atsc),
> > +	NGENE_ID(0x18c3, 0x0010, ngene_info_shrek_50_fp),
> > +	NGENE_ID(0x18c3, 0x0011, ngene_info_shrek_60_fp),
> > +	NGENE_ID(0x18c3, 0x0012, ngene_info_shrek_50),
> > +	NGENE_ID(0x18c3, 0x0013, ngene_info_shrek_60),
> > +	NGENE_ID(0x18c3, 0x0000, ngene_info_hognose),
> > +#endif
> >  	{0}
> >  };
> >  MODULE_DEVICE_TABLE(pci, ngene_id_tbl);
> 
> It is probably a good idea to backport this one. I would change it to #if 1, to allow
> people to test (or I would create a CONFIG_NGENE_EXPERIMENTAL to enable such support).

Nack, it would not work. If you have a look at a really unstripped ;-)
version of the file, you will notice that you have to invest a
considerable amount of effort to get these card types running.

This kind of stuff should be added one by one, whenever someone is
working on it.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
