Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39429 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754557Ab2EFU7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 16:59:35 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Ludovic BOUE <ludovic.boue@gmail.com>
Subject: Re: How to toggle Cine CT V6 to DVB-T mode?
Date: Sun, 6 May 2012 22:26:17 +0200
Cc: linux-media@vger.kernel.org, Brice Dubost <mumudvb@braice.net>
References: <CAO+XwZc5xHCaggg_LCmWNtnCuFWVNGFHY=Dm-eFLchcamrF-ZQ@mail.gmail.com>
In-Reply-To: <CAO+XwZc5xHCaggg_LCmWNtnCuFWVNGFHY=Dm-eFLchcamrF-ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205062226.18652@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Saturday 05 May 2012 16:39:42 Ludovic BOUE wrote:
> Hello Oliver,
> 
> I am facing an issue with my Cine CT V6 & DuoFlex CT cards. All tuners are
> recognized in DVB-C mode and I don't know how to switch to DVB-T mode.
> Could you tell me how to do that ?

If you use an application which is unable to switch the delivery system,
you may use 'dvb-fe-tool' (part of http://git.linuxtv.org/v4l-utils.git)
to do so.

Applications should be updated to support this new feature.
Recent vdr developer versions switch the delivery system
automatically.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
