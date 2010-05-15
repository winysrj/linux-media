Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38591 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751307Ab0EOXHm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 May 2010 19:07:42 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Douglas Schilling Landgraf <dougsland@redhat.com>
Subject: Re: av7110 and budget_av are broken!
Date: Sun, 16 May 2010 01:06:52 +0200
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"e9hack" <e9hack@googlemail.com>, linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl> <201004211144.19591@orion.escape-edv.de>
In-Reply-To: <201004211144.19591@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005160106.56028@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 April 2010 11:44:16 Oliver Endriss wrote:
> On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
> > > Am 22.3.2010 20:34, schrieb e9hack:
> > >> Am 20.3.2010 22:37, schrieb Hans Verkuil:
> > >>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
> > >>> OK, I know that. But does the patch I mailed you last time fix this
> > >>> problem
> > >>> without causing new ones? If so, then I'll post that patch to the list.
> > >>
> > >> With your last patch, I've no problems. I'm using a a TT-C2300 and a
> > >> Budget card. If my
> > >> VDR does start, currently I've no chance to determine which module is
> > >> load first, but it
> > >> works. If I unload all modules and load it again, I've no problem. In
> > >> this case, the
> > >> modules for the budget card is load first and the modules for the FF
> > >> loads as second one.
> > >
> > > Ping!!!!!!
> >
> > It's merged in Mauro's fixes tree, but I don't think those pending patches
> > have been pushed upstream yet. Mauro, can you verify this? They should be
> > pushed to 2.6.34!
> 
> What about the HG driver?
> The v4l-dvb HG repository is broken for 7 weeks...

Hi guys,

we have May 16th, and the HG driver is broken for 10 weeks now!

History:
- The changeset which caused the mess was applied on March 2nd:
  http://linuxtv.org/hg/v4l-dvb/rev/2eda2bcc8d6f

- A fix is waiting at fixes.git since March 24th:
  http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73

Are there any plans to bring v4ldvb HG to an usable state?

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
