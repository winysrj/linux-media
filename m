Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753807Ab0DUJop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 05:44:45 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: av7110 and budget_av are broken!
Date: Wed, 21 Apr 2010 11:44:16 +0200
Cc: "e9hack" <e9hack@googlemail.com>, linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
In-Reply-To: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004211144.19591@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
> > Am 22.3.2010 20:34, schrieb e9hack:
> >> Am 20.3.2010 22:37, schrieb Hans Verkuil:
> >>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
> >>> OK, I know that. But does the patch I mailed you last time fix this
> >>> problem
> >>> without causing new ones? If so, then I'll post that patch to the list.
> >>
> >> With your last patch, I've no problems. I'm using a a TT-C2300 and a
> >> Budget card. If my
> >> VDR does start, currently I've no chance to determine which module is
> >> load first, but it
> >> works. If I unload all modules and load it again, I've no problem. In
> >> this case, the
> >> modules for the budget card is load first and the modules for the FF
> >> loads as second one.
> >
> > Ping!!!!!!
>
> It's merged in Mauro's fixes tree, but I don't think those pending patches
> have been pushed upstream yet. Mauro, can you verify this? They should be
> pushed to 2.6.34!

What about the HG driver?
The v4l-dvb HG repository is broken for 7 weeks...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
