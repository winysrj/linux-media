Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZANKHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 05:07:11 -0500
Date: Wed, 14 Jan 2009 08:06:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Curran, Dominic" <dcurran@ti.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"mikko.hurskainen@nokia.com" <mikko.hurskainen@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: Re: Color FX User control proposal
Message-ID: <20090114080627.3efd5880@pedra.chehab.org>
In-Reply-To: <200901140816.14318.hverkuil@xs4all.nl>
References: <A24693684029E5489D1D202277BE8944164DF963@dlee02.ent.ti.com>
	<200901140816.14318.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Jan 2009 08:16:14 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Tuesday 13 January 2009 23:36:53 Aguirre Rodriguez, Sergio Alberto 
> wrote:
> > Hi,
> >
> > Recently in TI and Nokia, we are working towards having for
> > acceptance an OMAP3 camera driver, which uses an on-chip Image Signal
> > Processor that has one feature of color effects. We were using a V4L2
> > private CID for that, but have been suggested that this could be
> > common enough to propose to the V4L2 spec aswell for other devices to
> > use.
> >
> > Below patch adds the control to include/linux/videodev2.h file,
> > should this be enough? (This patch is taking as a codebase the latest
> > linux-omap kernel, which I believe is v2.6.28 still)

Seems good for me.

> >
> > Thanks and Regards,
> > Sergio
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Mauro,
> 
> Can you merge this patch? Looks good to me.

For us to apply, We need also a patch updating V4L2 API docbook. 

Cheers,
Mauro
