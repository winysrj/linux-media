Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:43545 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbbAaUV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2015 15:21:28 -0500
Date: Sat, 31 Jan 2015 20:54:15 +0100
To: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v4] [media] Add LVDS RGB media bus formats
Message-ID: <20150131195415.GA7308@s.cotton.clara.co.uk>
References: <1422464106-31826-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422464106-31826-1-git-send-email-p.zabel@pengutronix.de>
From: Steve Cotton <steve@s.cotton.clara.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 28, 2015 at 05:55:06PM +0100, Philipp Zabel wrote:
> +      <para>On LVDS buses, usually each sample is transferred serialized in
> +      seven time slots per pixel clock, on three (18-bit) or four (24-bit)
> +      differential data pairs at the same time. The remaining bits are used for
> +      control signals as defined by SPWG/PSWG/VESA or JEIDA standards.
> +      The 24-bit RGB format serialized in seven time slots on four lanes using
> +      JEIDA defined bit mapping will be named
> +      <constant>MEDIA_BUS_FMT_RGB888_1X7X3_JEIDA</constant>, for example.
> +      </para>

Hi Philipp,

Should that example be MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA instead of 1X7X3?

Regards,
Steve
