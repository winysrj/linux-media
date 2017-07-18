Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60698 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751485AbdGRThs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:37:48 -0400
Date: Tue, 18 Jul 2017 22:37:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pavel@ucw.cz,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/7] omap3isp: Ignore endpoints with invalid configuration
Message-ID: <20170718193744.6lfxgiwiwsvvpyo7@valkosipuli.retiisi.org.uk>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-2-sakari.ailus@linux.intel.com>
 <20170717230333.mauiskmeeq2khkt7@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170717230333.mauiskmeeq2khkt7@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 18, 2017 at 01:03:33AM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Tue, Jul 18, 2017 at 01:01:10AM +0300, Sakari Ailus wrote:
> > If endpoint has an invalid configuration, ignore it instead of happily
> > proceeding to use it nonetheless. Ignoring such an endpoint is better than
> > failing since there could be multiple endpoints, only some of which are
> > bad.
> 
> I would expect a dev_warn(dev, "Ignore endpoint (broken configuration)!");

Hmm. Perhaps I'll just drop this patch.

This will be (hopefully) soon replaced by a framework function.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
