Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34453 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506AbbJDSt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2015 14:49:59 -0400
Date: Sun, 4 Oct 2015 21:49:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2 api: supported resolution negotiation
Message-ID: <20151004184923.GH26916@valkosipuli.retiisi.org.uk>
References: <muqr5s$f1j$2@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <muqr5s$f1j$2@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 04, 2015 at 12:23:08PM +0300, Matwey V. Kornilov wrote:
> Hello,
> 
> I learned from V2L2 API how to detect all supported formats using
> VIDIOC_ENUM_FMT.
> When I perform VIDIOC_S_FMT I don't know how to fill fmt.pix.width and
> fmt.pix.height, since I know only format.
> How should I negotiate device resolution? Could you point me?

VIDIOC_ENUM_FRAMESIZES may give you hints, but it's optional. You can use
values you prefer to try if drivers support them; I think the GStreamer
v4lsrc tries very small and very large values. The driver will clamp them to
a supported values which are passed to the application from the IOCTL.

<URL:http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-enum-framesizes>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
