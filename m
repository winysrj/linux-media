Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57879 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0FKPXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 11:23:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: Alternative for defconfig
Date: Fri, 11 Jun 2010 17:26:25 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com> <201006111707.34463.laurent.pinchart@ideasonboard.com> <5A47E75E594F054BAF48C5E4FC4B92AB03233C036E@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB03233C036E@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111726.28384.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anand,

On Friday 11 June 2010 17:14:19 Gadiyar, Anand wrote:
> Laurent Pinchart wrote:
> > On Friday 11 June 2010 16:55:07 Aguirre, Sergio wrote:
> > > > On Fri, Jun 11, 2010 at 3:19 PM, Nagarajan, Rajkumar wrote:
> > > > > 1. What is the alternative way of submitting defconfig
> > > > > changes/files to
> > > > 
> > > > LO?
> > > 
> > > I don't think defconfig changes are prohibited now. If I understand
> > > correctly, Linus just hates the fact that there is a big percentage of
> > > patches for defconfigs. Maybe he wants us to hold these, and better
> > > provide higher percentage of actual code changes.
> > > 
> > > What about holding defconfig changes in a separate branch, and just
> > > send them for upstream once in a while, specially if there's a big
> > > quantity of them in the queue?
> > > 
> > > IMHO, defconfigs are just meant to make us life easier, but changes to
> > > them should _never_ be a fix/solution to any problem, and therefore I
> > > understand that those aren't a priority over regressions.
> > 
> > My understanding is that Linus will remove all ARM defconfigs in 2.6.36,
> > unless someone can convince him not to. Board-specific defconfigs won't
> > be allowed anymore, the number of defconfigs needs to be reduced
> > drastically (ideally to one or two only).
> 
> There is some good work going on on the linux-arm-kernel mailing list to
> cut down heavily the ARM defconfigs. Would be good to join that discussion.
> 
> For OMAP, I suppose maintaining omap1_defconfig and omap3_defconfig would
> suffice to cover all OMAPs?

I'm not sure what the exact roadmap will be. Linus is complaining about the 
defconfig changes taking up too much of the diffstat. I don't know if he will 
accept patches to solve the problem gradually, or if he will just remove all 
defconfig files in 2.6.36.

In any case, all changes that make it possible to built more machine types and 
platform types in the same kernel are a step in the right direction.

-- 
Regards,

Laurent Pinchart
