Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:9214 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935791AbeEYORy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 10:17:54 -0400
Date: Fri, 25 May 2018 17:17:43 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH v2.2 2/2] smiapp: Support the "rotation" property
Message-ID: <20180525141742.ztvk4kvqfx3vjfkf@kekkonen.localdomain>
References: <20180525134055.11121-1-sakari.ailus@linux.intel.com>
 <20180525135235.12386-1-sakari.ailus@linux.intel.com>
 <20180525140955.7exw6kqiffpsnzkl@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180525140955.7exw6kqiffpsnzkl@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 04:09:55PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, May 25, 2018 at 04:52:35PM +0300, Sakari Ailus wrote:
> > Use the "rotation" property to tell that the sensor is mounted upside
> > down. This reverses the behaviour of the VFLIP and HFLIP controls as well
> > as the pixel order.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> 
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Danke schön!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
