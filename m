Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35864 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751619Ab2KHJ3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Nov 2012 04:29:11 -0500
Date: Thu, 8 Nov 2012 11:29:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andreas Nagel <andreasnagel@gmx.net>, linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Message-ID: <20121108092905.GF25623@valkosipuli.retiisi.org.uk>
References: <5097DF9F.6080603@gmx.net>
 <20121106215153.GE25623@valkosipuli.retiisi.org.uk>
 <509A4473.3080506@gmx.net>
 <4541060.0oGRVnU8K8@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4541060.0oGRVnU8K8@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2012 at 10:26:11AM +0100, Laurent Pinchart wrote:
> media-ctl doesn't show pad formats, that's a bit weird. Are you using a recent 
> version ?

This could as well be an issue with the kernel API --- I think that kernel
has a version which isn't in mainline. So the IOCTL used to access the media
bus formats are quite possibly different.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
