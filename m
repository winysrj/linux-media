Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59837 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0KSQcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 11:32:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3isp] Prefered patch base for latest code? (was: "RE: Translation faults with OMAP ISP")
Date: Fri, 19 Nov 2010 17:32:19 +0100
Cc: David Cohen <david.cohen@nokia.com>,
	ext Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4CE16AA2.3000208@brooks.nu> <201011191716.23102.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE8944850C08AF@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944850C08AF@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191732.20289.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

On Friday 19 November 2010 17:23:45 Aguirre, Sergio wrote:
> On Friday, November 19, 2010 10:16 AM Aguirre, Sergio wrote:
> > On Friday 19 November 2010 17:07:09 Aguirre, Sergio wrote:

[snip]

> > > How close is this tree from the latest internal version you guys work
> > > with?
> > >
> > > http://meego.gitorious.com/maemo-multimedia/omap3isp-rx51/commits/devel
> > 
> > There's less differences between gitorious and our internal tree than
> > between linuxtv and our internal tree.
> 
> Ok, I guess I can treat above tree as an "omap3isp-next" tree then, to have
> a sneak preview of what's coming ;)

I haven't expressed myself clearly enough. The gitorious tree is currently 
more in sync with our internal tree that the linuxtv is for a simple reason: 
both our internal tree and the gitorious tree are missing modifications made 
during the public review process.

Patches published from our internal tree are always pushed to linuxtv and 
gitorious at the same time (or mostly). Please don't use the gitorious tree 
for anything else than trying the driver on the N900.

-- 
Regards,

Laurent Pinchart
