Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46140 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab0FKOzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 10:55:12 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 11 Jun 2010 09:55:07 -0500
Subject: RE: Alternative for defconfig
Message-ID: <A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com>
	<FF55437E1F14DA4BAEB721A458B6701706BD9A3A73@dbde02.ent.ti.com>
 <AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
In-Reply-To: <AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Felipe Contreras
> Sent: Friday, June 11, 2010 8:43 AM
> To: Nagarajan, Rajkumar
> Cc: Laurent Pinchart; linux-media@vger.kernel.org; Hiremath, Vaibhav;
> linux-omap@vger.kernel.org
> Subject: Re: Alternative for defconfig
> 
> On Fri, Jun 11, 2010 at 3:19 PM, Nagarajan, Rajkumar <x0133774@ti.com>
> wrote:
> > 1. What is the alternative way of submitting defconfig changes/files to
> LO?

I don't think defconfig changes are prohibited now. If I understand
correctly, Linus just hates the fact that there is a big percentage of
patches for defconfigs. Maybe he wants us to hold these, and better
provide higher percentage of actual code changes.

What about holding defconfig changes in a separate branch, and just send
them for upstream once in a while, specially if there's a big quantity of
them in the queue?

IMHO, defconfigs are just meant to make us life easier, but changes to them
should _never_ be a fix/solution to any problem, and therefore I understand
that those aren't a priority over regressions.

Regards,
Sergio

> 
> I don't think we have any alternative yet.
> 
> --
> Felipe Contreras
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
