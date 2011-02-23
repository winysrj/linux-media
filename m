Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35735 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1BWLEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 06:04:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 12:04:41 +0100
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-media@vger.kernel.org, saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <Pine.LNX.4.64.1102221215350.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221215350.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231204.42898.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Tuesday 22 February 2011 12:40:32 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Stanimir Varbanov wrote:
> > This RFC patch adds a new subdev sensor operation named
> > g_interface_parms. It is planned as a not mandatory operation and it is
> > driver's developer decision to use it or not.
> > 
> > Please share your opinions and ideas.

[snip] (answering this in another e-mail)

> Shortly talking to Laurent earlier today privately, he mentioned, that one
> of the reasons for this move is to support dynamic bus reconfiguration,
> e.g., the number of used CSI lanes. The same is useful for parallel
> interfaces. E.g., I had to hack the omap3spi driver to capture only 8
> (parallel) data lanes from the sensor, connected with all its 10 lanes to
> get a format, easily supported by user-space applications. Ideally you
> don't want to change anything in the code for this. If the user is
> requesting the 10-bit format, all 10 lanes are used, if only 8 - the
> interface is reconfigured accordingly.

This should indeed be supported out-of-the-box. I'm waiting for Hans' opinion 
on this, but the idea is that the user should configure a 10-bit format at the 
sensor output and an 8-bit format at the CCDC input to capture 8-bit data.

-- 
Regards,

Laurent Pinchart
