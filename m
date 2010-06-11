Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0FKPO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 11:14:26 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 11 Jun 2010 20:44:19 +0530
Subject: RE: Alternative for defconfig
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03233C036E@dbde02.ent.ti.com>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com>
 <AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
 <A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
 <201006111707.34463.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201006111707.34463.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Friday 11 June 2010 16:55:07 Aguirre, Sergio wrote:
> > > On Fri, Jun 11, 2010 at 3:19 PM, Nagarajan, Rajkumar wrote:
> > > > 1. What is the alternative way of submitting defconfig changes/files to
> > > 
> > > LO?
> > 
> > I don't think defconfig changes are prohibited now. If I understand
> > correctly, Linus just hates the fact that there is a big percentage of
> > patches for defconfigs. Maybe he wants us to hold these, and better
> > provide higher percentage of actual code changes.
> > 
> > What about holding defconfig changes in a separate branch, and just send
> > them for upstream once in a while, specially if there's a big quantity of
> > them in the queue?
> > 
> > IMHO, defconfigs are just meant to make us life easier, but changes to them
> > should _never_ be a fix/solution to any problem, and therefore I understand
> > that those aren't a priority over regressions.
> 
> My understanding is that Linus will remove all ARM defconfigs in 2.6.36, 
> unless someone can convince him not to. Board-specific defconfigs won't be 
> allowed anymore, the number of defconfigs needs to be reduced drastically 
> (ideally to one or two only).
> 

There is some good work going on on the linux-arm-kernel mailing list to
cut down heavily the ARM defconfigs. Would be good to join that discussion.

For OMAP, I suppose maintaining omap1_defconfig and omap3_defconfig would
suffice to cover all OMAPs?

- Anand
