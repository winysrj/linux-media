Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4744 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZH3Tfj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 15:35:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: bus configuration setup for sub-devices
Date: Sun, 30 Aug 2009 21:35:34 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
References: <200908291631.13696.hverkuil@xs4all.nl> <19F8576C6E063C45BE387C64729E73940436A4A771@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436A4A771@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908302135.34617.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 30 August 2009 17:46:36 Hiremath, Vaibhav wrote:
> > -----Original Message-----

<snip>

> > 
> > /*
> >  * Some sub-devices are connected to the host/bridge device through
> > a bus that
> >  * carries the clock, vsync, hsync and data. Some interfaces such as
> > BT.656
> >  * carries the sync embedded in the data whereas others have
> > separate lines
> >  * carrying the sync signals.
> >  */
> > struct v4l2_bus_config {
> >         /* embedded sync, set this when sync is embedded in the data
> > stream */
> >         unsigned embedded_sync:1;
> >         /* master or slave */
> >         unsigned is_master:1;
> > 
> >         /* bus width */
> >         unsigned width:8;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_vsync:1;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_hsync:1;
> >         /* 0 - low to high, 1 - high to low */
> >         unsigned pol_field:1;
> >         /* 0 - sample at falling edge, 1 - sample at rising edge */
> >         unsigned edge_pclock:1;
> >         /* 0 - active low, 1 - active high */
> >         unsigned pol_data:1;
> > };
> > 
> > It's all bitfields, so it is a very compact representation.
> > 
> [Hiremath, Vaibhav] If I understand correctly, all the above data will come to host/bridge driver from board file, right?

Yes, that's correct.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
