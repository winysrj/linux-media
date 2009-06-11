Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50239 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZFKMDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 08:03:18 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/4] V4L2: add a new V4L2_CID_BAND_STOP_FILTER integer control
Date: Thu, 11 Jun 2009 14:03:00 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange> <Pine.LNX.4.64.0906101558090.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906101558090.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111403.01021.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 11 June 2009 09:12:37 Guennadi Liakhovetski wrote:
> Add a new V4L2_CID_BAND_STOP_FILTER integer control, which either switches
> the band-stop filter off, or sets it to a certain strength.

I'm quoting your e-mail from 2009-05-27:

> COMJ[2] - Band filter enable. After adjust frame rate to match indoor
> light frequency, this bit enable a different exposure algorithm to cut
> light band induced by fluorescent light.

As Nate pointed out, that seems to some kind of anti-flicker control and not a 
band stop filter.

Best regards,

Laurent Pinchart

