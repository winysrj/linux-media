Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41161 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751150AbaKQPZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 10:25:16 -0500
Date: Mon, 17 Nov 2014 17:24:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] [media] Add RGB444_1X12 and RGB565_1X16 media bus
 formats
Message-ID: <20141117152442.GR8907@valkosipuli.retiisi.org.uk>
References: <1416126278-17708-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416126278-17708-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Boris,

On Sun, Nov 16, 2014 at 09:24:38AM +0100, Boris Brezillon wrote:
> Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> Changes since v1:
> - keep BPP and bits per sample ordering
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 ++-
>  2 files changed, 43 insertions(+), 1 deletion(-)

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
