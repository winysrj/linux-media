Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53865 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754108Ab3AFBD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 20:03:27 -0500
Date: Sun, 6 Jan 2013 03:03:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: How to configure resizer in ISP pipeline?
Message-ID: <20130106010321.GE13641@valkosipuli.retiisi.org.uk>
References: <50C747B7.20107@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C747B7.20107@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Tue, Dec 11, 2012 at 03:48:23PM +0100, Andreas Nagel wrote:
> Hello,
> 
> using Media Controller API, I can successfully configure a simple
> ISP pipeline on an OMAP3530 and capture video data. Now I want to
> include the resizer. So the pipeline would look like this (where MEM
> would be the devnode corresponding to "resizer output"):
> 
> Sensor --> CCDC --> Resizer --> MEM
> 
> My "sensor" (TVP5146) already provides YUV data, so I can skip the
> previewer. I tried setting the input and output pad of the resizer
> subdevice to incoming resolution (input pad) and desired resolution
> (output pad). For example: 720x576 --> 352x288. But it didn't work
> out quite well.

How did it not work quite well? :)

> Can someone explain how one properly configures the resizer in an
> ISP pipeline (with Media Controller API) ? I spend some hours
> researching, but this topic seems to be a well guarded secret...

There's nothing special about it. Really.

The resizing factor is chosen by setting the media bus format on the source
pad to the desired size.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
