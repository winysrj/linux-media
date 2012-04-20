Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36509 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461Ab2DTUmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 16:42:47 -0400
Date: Fri, 20 Apr 2012 23:42:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Lindell <Steve.Lindell@se.flextronics.com>
Cc: linux-media@vger.kernel.org, saaguirre@ti.com
Subject: Re: Mipi csi2 driver for Omap4
Message-ID: <20120420204242.GM5356@valkosipuli.localdomain>
References: <414D8776B339BF44ADF9839A98A591A0046B8C63@EUDUCEX3.europe.ad.flextronics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <414D8776B339BF44ADF9839A98A591A0046B8C63@EUDUCEX3.europe.ad.flextronics.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, Apr 20, 2012 at 12:11:38PM +0200, Steve Lindell wrote:
> Hi! I'm developing a mipi csi2 receiver for test purpose and need some
> help of how to capture the data stream from a camera module. I'm using a
> phytec board with a Omap4430 processor running Linux kernel 3.0.9.
> Connected to the MIPI lanes I have a camera module (soled on a flexfilm)
> The camera follows the Mipi csi2 specs and is controlled via an external
> I2C controller. I have activated the camera and its now transmitting a
> test pattern on the Mipi lines (4 line connection).
> 
> I need to capture the stream and store it as a Raw Bayer snapshot. Is this
> possible use Omap4430 and does Linux have the necessary drivers to capture
> the stream. If this driver exists are there any documentation of how to
> implement the driver?
> 
> Is it possible to get some help of how to get started?

Sergio Aguirre has posted the patches for the Omap 4 Iss to this list some
time ago. I believe you'll also be able to find them here:

<URL:https://gitorious.org/omap4-v4l2-camera/pages/Home>

I guess you'd be also better off using a newer kernel than that.

Hope this helps... Cc Sergio.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
