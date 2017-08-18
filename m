Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49788 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750967AbdHRIdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 04:33:09 -0400
Date: Fri, 18 Aug 2017 11:33:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] et8ek8: Decrease stack usage
Message-ID: <20170818083306.rsh3k2sv6zdilkxs@valkosipuli.retiisi.org.uk>
References: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
 <20170817213842.GA13909@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170817213842.GA13909@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 17, 2017 at 11:38:43PM +0200, Pavel Machek wrote:
> On Wed 2017-08-16 10:33:45, Sakari Ailus wrote:
> > The et8ek8 driver combines I²C register writes to a single array that it
> > passes to i2c_transfer(). The maximum number of writes is 48 at once,
> > decrease it to 8 and make more transfers if needed, thus avoiding a
> > warning on stack usage.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Pavel: this is just compile tested. Could you test it on N900, please?
> 
> (More than 1 et8ek8 device makes static bad idea).
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
