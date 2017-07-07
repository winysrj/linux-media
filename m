Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34656 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751859AbdGGNEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 09:04:37 -0400
Date: Fri, 7 Jul 2017 16:04:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 7/8] omap3isp: Check for valid port in endpoints
Message-ID: <20170707130432.g4di5a3he2bf5baw@valkosipuli.retiisi.org.uk>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-8-sakari.ailus@linux.intel.com>
 <20170706111149.ws6olipu7ph4tcyd@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170706111149.ws6olipu7ph4tcyd@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 06, 2017 at 01:11:49PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Thu, Jul 06, 2017 at 02:00:18AM +0300, Sakari Ailus wrote:
> > Check that we do have a valid port in an endpoint, return an error if not.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Thanks for the reviews, Sebastian and Pavel!

I'll send a pull request on these for 4.14 once we have -rc1 in the media
tree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
