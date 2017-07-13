Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51626 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751153AbdGMV04 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 17:26:56 -0400
Date: Fri, 14 Jul 2017 00:26:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3ISP CCP2 support
Message-ID: <20170713212651.so5aqqp5k325pb4w@valkosipuli.retiisi.org.uk>
References: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
 <20170713211335.GA13502@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713211335.GA13502@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 11:13:35PM +0200, Pavel Machek wrote:
> Hi!
> 
> > I took the liberty of changing your patch a bit. I added another to extract
> > the number of lanes from the endpoint instead as it's not really a property
> > of the PHY. (Not tested yet, will check with N9.)
> 
> No problem.
> 
> Notice that the 1/2 does not apply on top of ccp2 branch; my merge
> resolution was this:

The two patches are for the ccp2-prepare branches, not for ccp2; it's
somewhat out of date right now and needs a rebase.

The patches work fine on N9.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
