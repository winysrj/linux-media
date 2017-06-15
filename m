Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39760 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751623AbdFOMcQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 08:32:16 -0400
Date: Thu, 15 Jun 2017 15:32:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
Message-ID: <20170615123209.GD12407@valkosipuli.retiisi.org.uk>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
 <20170615092425.xcgeiu65yxawczr5@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170615092425.xcgeiu65yxawczr5@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 15, 2017 at 11:24:26AM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, Jun 14, 2017 at 12:47:16PM +0300, Sakari Ailus wrote:
> > None of the flash operations are not mandatory and therefore there should
> > be no need for the flash ops structure either. Accept NULL.
> 
> I think you negated one time too much :). Otherwise:
> 
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

Thanks!

The new one reads:

None of the flash operations are mandatory and therefore there should be no
need for the flash ops structure either. Accept NULL.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
