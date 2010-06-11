Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41699 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0FKPEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 11:04:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: Alternative for defconfig
Date: Fri, 11 Jun 2010 17:07:32 +0200
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com> <AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com> <A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006111707.34463.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 11 June 2010 16:55:07 Aguirre, Sergio wrote:
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Felipe Contreras
> > Sent: Friday, June 11, 2010 8:43 AM
> > To: Nagarajan, Rajkumar
> > Cc: Laurent Pinchart; linux-media@vger.kernel.org; Hiremath, Vaibhav;
> > linux-omap@vger.kernel.org
> > Subject: Re: Alternative for defconfig
> > 
> > On Fri, Jun 11, 2010 at 3:19 PM, Nagarajan, Rajkumar wrote:
> > > 1. What is the alternative way of submitting defconfig changes/files to
> > 
> > LO?
> 
> I don't think defconfig changes are prohibited now. If I understand
> correctly, Linus just hates the fact that there is a big percentage of
> patches for defconfigs. Maybe he wants us to hold these, and better
> provide higher percentage of actual code changes.
> 
> What about holding defconfig changes in a separate branch, and just send
> them for upstream once in a while, specially if there's a big quantity of
> them in the queue?
> 
> IMHO, defconfigs are just meant to make us life easier, but changes to them
> should _never_ be a fix/solution to any problem, and therefore I understand
> that those aren't a priority over regressions.

My understanding is that Linus will remove all ARM defconfigs in 2.6.36, 
unless someone can convince him not to. Board-specific defconfigs won't be 
allowed anymore, the number of defconfigs needs to be reduced drastically 
(ideally to one or two only).

-- 
Regards,

Laurent Pinchart
