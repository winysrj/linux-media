Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:37291 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752791Ab1FRVio (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 17:38:44 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Helmut Auer <helmut@helmutauer.de>
Subject: Re: Bug: media_build always compiles with '-DDEBUG'
Date: Sat, 18 Jun 2011 23:38:25 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201106182246.03051@orion.escape-edv.de> <4DFD1479.1060501@helmutauer.de>
In-Reply-To: <4DFD1479.1060501@helmutauer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106182338.25983@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 18 June 2011 23:11:21 Helmut Auer wrote:
> Hi
> >
> > Replacing
> >      ifdef CONFIG_VIDEO_OMAP3_DEBUG
> > by
> >      ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
> > would do the trick.
> >
> I guess that would not ive the intended result.
> Setting CONFIG_VIDEO_OMAP3_DEBUG to yes should not lead to debug messages in all media modules,

True, but it will happen only if you manually enable
CONFIG_VIDEO_OMAP3_DEBUG in Kconfig.

You cannot avoid this without major changes of the
media_build system - imho not worth the effort.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
