Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57359 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3KLUjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Nov 2013 15:39:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Valentine <valentine.barshak@cogentembedded.com>
Cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/3] media: Add SH-Mobile RCAR-H2 Lager board support
Date: Tue, 12 Nov 2013 21:40:25 +0100
Message-ID: <2220887.L93iMW8boy@avalon>
In-Reply-To: <528290BC.8070207@cogentembedded.com>
References: <1380029916-10331-1-git-send-email-valentine.barshak@cogentembedded.com> <2610202.KZTyX0lZUJ@avalon> <528290BC.8070207@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Valentine,

On Wednesday 13 November 2013 00:34:04 Valentine wrote:
> On 11/12/2013 03:42 AM, Laurent Pinchart wrote:
> > On Tuesday 24 September 2013 17:38:33 Valentine Barshak wrote:
> >> The following patches add ADV7611/ADV7612 HDMI receiver I2C driver
> >> and add RCAR H2 SOC support along with ADV761x output format support
> >> to rcar_vin soc_camera driver.
> >> 
> >> These changes are needed for SH-Mobile R8A7790 Lager board
> >> video input support.
> > 
> > Do you plan to submit a v2 ? I need the ADV761x driver pretty soon and I'd
> > like to avoid submitting a competing patch :-)
> 
> Yes, I plan to submit v2 when it's ready.
> Currently it's a work in progress.
> 
> Do you already have anything to submit for the ADV761x support?

Not yet, but I will likely work on it in the next few days.

-- 
Regards,

Laurent Pinchart

