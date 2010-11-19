Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41462 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab0KSQhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 11:37:32 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Cohen <david.cohen@nokia.com>,
	ext Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 19 Nov 2010 10:37:24 -0600
Subject: RE: [omap3isp] Prefered patch base for latest code? (was: "RE:
 Translation faults with OMAP ISP")
Message-ID: <A24693684029E5489D1D202277BE8944850C08EA@dlee02.ent.ti.com>
References: <4CE16AA2.3000208@brooks.nu>
 <201011191716.23102.laurent.pinchart@ideasonboard.com>
 <A24693684029E5489D1D202277BE8944850C08AF@dlee02.ent.ti.com>
 <201011191732.20289.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011191732.20289.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Friday, November 19, 2010 10:32 AM
> To: Aguirre, Sergio
> Cc: David Cohen; ext Lane Brooks; linux-media@vger.kernel.org
> Subject: Re: [omap3isp] Prefered patch base for latest code? (was: "RE:
> Translation faults with OMAP ISP")
> 
> Hi Sergio,
> 
> On Friday 19 November 2010 17:23:45 Aguirre, Sergio wrote:
> > On Friday, November 19, 2010 10:16 AM Aguirre, Sergio wrote:
> > > On Friday 19 November 2010 17:07:09 Aguirre, Sergio wrote:
> 
> [snip]
> 
> > > > How close is this tree from the latest internal version you guys
> work
> > > > with?
> > > >
> > > > http://meego.gitorious.com/maemo-multimedia/omap3isp-
> rx51/commits/devel
> > >
> > > There's less differences between gitorious and our internal tree than
> > > between linuxtv and our internal tree.
> >
> > Ok, I guess I can treat above tree as an "omap3isp-next" tree then, to
> have
> > a sneak preview of what's coming ;)
> 
> I haven't expressed myself clearly enough. The gitorious tree is currently
> more in sync with our internal tree that the linuxtv is for a simple
> reason:
> both our internal tree and the gitorious tree are missing modifications
> made
> during the public review process.

Ok. Sorry, I think I didn't quite understood that.

> 
> Patches published from our internal tree are always pushed to linuxtv and
> gitorious at the same time (or mostly). Please don't use the gitorious
> tree
> for anything else than trying the driver on the N900.

I see. So I probably won't worry about this tree at all, since I don't have an N900.

I'm trying this in my Zoom board w/OMAP3630, and I have a Beagleboard xM handy aswell (OMAP3730), so In my tree I'll try to keep support for both of
These.

Also, I'm working on trying to bring this in a very different chip, but that's a secret ;) That's why I'm working in doing cleanups.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
