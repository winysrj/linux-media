Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42442 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758249Ab2AFBC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 20:02:59 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to one frontend
Date: Fri, 6 Jan 2012 02:02:36 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com> <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
In-Reply-To: <CAGoCfizKsxALXAMbCO=XGkODkXy2sBJ1NzbhBQ2TAkurnG-maQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201060202.37931@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 January 2012 17:40:54 Devin Heitmueller wrote:
> On Thu, Jan 5, 2012 at 10:37 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > With all these series applied, it is now possible to use frontend 0
> > for all delivery systems. As the current tools don't support changing
> > the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
> > be used to change between them:
> 
> Hi Mauro,
> 
> While from a functional standpoint I think this is a good change (and
> we probably should have done it this way all along), is there not
> concern that this could be interpreted by regular users as a
> regression?  Right now they get two frontends, and they can use all
> their existing tools.  We're moving to a model where if users upgraded
> their kernel they would now require some new userland tool to do
> something that the kernel was allowing them to do previously.
> 
> Sure, it's not "ABI breakage" in the classic sense but the net effect
> is the same - stuff that used to work stops working and now they need
> new tools or to recompile their existing tools to include new
> functionality (which as you mentioned, none of those tools have
> today).
> 
> Perhaps you would consider some sort of module option that would let
> users fall back to the old behavior?

Imho it is not worth the effort. ;-)

Usually there is a single type of signal on the cable (for example
DVB-T or DVB-C, but not both). So the delivery system will not
change during normal operation.

If an old application cannot setup the delivery system,
and the default delivery system is the wrong one:
Run a small tool to setup to the desired delivery system.

Afterwards the old application will work 'as is' with the combined
frontend.

I see no major problems with the new behaviour.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
