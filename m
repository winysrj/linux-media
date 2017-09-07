Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932344AbdIGOwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 10:52:08 -0400
Date: Thu, 7 Sep 2017 17:52:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 2/3] leds: as3645a: Add LED flash class driver
Message-ID: <20170907145205.k3uzwwgvv3hxrb5t@valkosipuli.retiisi.org.uk>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-3-sakari.ailus@linux.intel.com>
 <20170828110451.GB492@amd>
 <20170907102657.stoqw5e7glbkbz2z@valkosipuli.retiisi.org.uk>
 <20170907125027.GA3108@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907125027.GA3108@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 07, 2017 at 02:50:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > On Mon, Aug 28, 2017 at 01:04:51PM +0200, Pavel Machek wrote:
> > > On Wed 2017-08-23 11:10:59, Sakari Ailus wrote:
> > > > Add a LED flash class driver for the as3654a flash controller. A V4L2 flash
> > > > driver for it already exists (drivers/media/i2c/as3645a.c), and this driver
> > > > is based on that.
> > > 
> > > We do not want to have two drivers for same hardware... how is that
> > > supposed to work?
> > 
> > No, we don't. The intent is to remove the other driver later on, as it's
> > implemented as a V4L2 sub-device driver. It also lacks DT support.
> 
> Could we perhaps remove the driver with the same patch that merges
> this?

This patch is already merged, but I can submit another patch removing the
other driver.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
