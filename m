Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36630 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752746AbdDJL3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 07:29:36 -0400
Date: Mon, 10 Apr 2017 14:28:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/8] v4l: async: Provide interoperability between OF
 and fwnode matching
Message-ID: <20170410112857.GP4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-5-git-send-email-sakari.ailus@linux.intel.com>
 <4169138.83VydnvH0Q@avalon>
 <20170407221047.GL4192@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407221047.GL4192@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Apr 08, 2017 at 01:10:47AM +0300, Sakari Ailus wrote:
> Hi Laurent,
> 
> On Fri, Apr 07, 2017 at 01:07:48PM +0300, Laurent Pinchart wrote:
> > Hi Sakari,
> > 
> > Thank you for the patch.
> > 
> > On Thursday 06 Apr 2017 16:12:06 Sakari Ailus wrote:
> > > OF and fwnode support are separated in V4L2 and individual drivers may
> > > implement one of them. Sub-devices do not match with a notifier
> > > expecting sub-devices with fwnodes, nor the other way around.
> > 
> > Shouldn't we instead convert all drivers to fwnode matching ? What's missing 
> > after the mass conversion in patch 5/8 ?
> 
> A lot of drivers use the OF frame work and thus do not deal with fwnodes
> directly. I haven't entirely converted them to use the fwnode API since
> making additional, unnecessary changes increases the likelihood of errors.

Doing the rest of the conversion was less work than I originally had
anticipated. The changes are obvious and very similar from driver to driver,
perhaps unsurprisingly. Nevertheless, additional testing coverage certainly
wouldn't hurt.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
