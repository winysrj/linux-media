Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:53955 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750837Ab1GOFWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 01:22:05 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Fri, 15 Jul 2011 07:17:06 +0200
Cc: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>
References: <201107032321.46092@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <4E1FBA6F.10509@redhat.com>
In-Reply-To: <4E1FBA6F.10509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107150717.08944@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 July 2011 05:56:31 Mauro Carvalho Chehab wrote:
> Em 14-07-2011 21:47, Mauro Carvalho Chehab escreveu:
> > Em 14-07-2011 20:45, Oliver Endriss escreveu:
> >> - DVB-T tuning does not work anymore.
> > I think that the better is to revert my patch and apply a solution similar
> > to cxd2820r_attach. It should work fine if called just once (like ngene/ddbridge)
> > or twice (like em28xx).
> 
> I ended by fixing it at the easiest way: Just add a hack at em28xx to work the same
> way as ngene/ddbridge.
> 
> The code is not beautiful, but in order to fix, I would also need to touch at
> tda18271c2dd. Let's do it on another time.
> 
> [media] Remove the double symbol increment hack from drxk_hard

Thanks, module unloading works again.

> Both ngene and ddbrige calls dvb_attach once for drxk_attach.
> The logic used there, and by tda18271c2dd driver is different
> from similar logic on other frontends.
> 
> The right fix is to change them to use the same logic, but,
> while we don't do that, we need to patch em28xx-dvb in order
> to do cope with ngene/ddbridge magic.

I disagree: The right fix is to extend the framework, and drop the
secondary frondend completely. The current way of supporting
multi-standard tuners is abusing the DVB API.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
