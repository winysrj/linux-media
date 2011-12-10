Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:33965 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752129Ab1LJEAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 23:00:37 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCHv2] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
Date: Sat, 10 Dec 2011 05:00:12 +0100
Cc: linux-media@vger.kernel.org
References: <4EE252E5.2050204@iki.fi> <1323457212-13507-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1323457212-13507-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201112100500.13365@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 09 December 2011 20:00:12 Mauro Carvalho Chehab wrote:
> The DRX-K doesn't change the delivery system at set_properties,
> but do it at frontend init. This causes problems on programs like
> w_scan that, by default, opens both frontends.
> 
> Use adap->mfe_shared in order to prevent this, and be sure that Annex A
> or C are properly selected.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
> 
> v2: Use mfe_shared
> 
>  drivers/media/dvb/frontends/drxk_hard.c |   16 ++++++++++------
>  drivers/media/dvb/frontends/drxk_hard.h |    2 ++
>  drivers/media/video/em28xx/em28xx-dvb.c |    4 ++++
>  3 files changed, 16 insertions(+), 6 deletions(-)
...

Please commit Manu's patch to 'Query DVB frontend delivery capabilities'.
Then you will no longer have to struggle with multi-frontend problems.

We could finally get rid of having 2 mutual-exclusive frontends, which
is just an ugly workaround, barely covered by the API spec...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
Oliver Endriss                         ESCAPE GmbH
e-mail:  o.endriss@escape-edv.de       EDV-Loesungen
phone:   +49 (0)7722 21504             Birkenweg 9
fax:     +49 (0)7722 21510             D-78098 Triberg
----------------------------------------------------------------
