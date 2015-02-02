Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43264 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbbBBJkS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 04:40:18 -0500
Message-ID: <1422870013.6112.1.camel@pengutronix.de>
Subject: Re: [PATCH v4] [media] Add LVDS RGB media bus formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Cotton <steve@s.cotton.clara.co.uk>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	kernel@pengutronix.de
Date: Mon, 02 Feb 2015 10:40:13 +0100
In-Reply-To: <20150131195415.GA7308@s.cotton.clara.co.uk>
References: <1422464106-31826-1-git-send-email-p.zabel@pengutronix.de>
	 <20150131195415.GA7308@s.cotton.clara.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Am Samstag, den 31.01.2015, 20:54 +0100 schrieb Steve Cotton:
> On Wed, Jan 28, 2015 at 05:55:06PM +0100, Philipp Zabel wrote:
> > +      <para>On LVDS buses, usually each sample is transferred serialized in
> > +      seven time slots per pixel clock, on three (18-bit) or four (24-bit)
> > +      differential data pairs at the same time. The remaining bits are used for
> > +      control signals as defined by SPWG/PSWG/VESA or JEIDA standards.
> > +      The 24-bit RGB format serialized in seven time slots on four lanes using
> > +      JEIDA defined bit mapping will be named
> > +      <constant>MEDIA_BUS_FMT_RGB888_1X7X3_JEIDA</constant>, for example.
> > +      </para>
> 
> Hi Philipp,
> 
> Should that example be MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA instead of 1X7X3?

Yes, thank you. I'll fix this and resend.

regards
Philipp

