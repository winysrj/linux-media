Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:44322 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754021AbeF2OMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 10:12:49 -0400
Date: Fri, 29 Jun 2018 17:12:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 05/22] [media] v4l2-rect.h: add position and equal helpers
Message-ID: <20180629141244.yp4qrk74z2etwmad@paasikivi.fi.intel.com>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-6-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628162054.25613-6-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 06:20:37PM +0200, Marco Felsch wrote:
> Add two helper functions to check if two rectangles have the same
> position (top/left) and if two rectangles equals (same size and
> same position).
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
