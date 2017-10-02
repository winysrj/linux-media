Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50444 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBWM4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 18:12:56 -0400
Date: Mon, 2 Oct 2017 23:12:47 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/1] v4l: async: Fix notifier complete callback error
 handling
Message-ID: <20171002221247.GH20805@n2100.armlinux.org.uk>
References: <20171002105954.29474-1-sakari.ailus@linux.intel.com>
 <20171002112846.ymr4ubrg6nlos6hh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171002112846.ymr4ubrg6nlos6hh@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 02, 2017 at 02:28:46PM +0300, Sakari Ailus wrote:
> On Mon, Oct 02, 2017 at 01:59:54PM +0300, Sakari Ailus wrote:
> > The notifier complete callback may return an error. This error code was
> > simply returned to the caller but never handled properly.
> > 
> > Move calling the complete callback function to the caller from
> > v4l2_async_test_notify and undo the work that was done either in async
> > sub-device or async notifier registration.
> > 
> > Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Oh, I forgot to metion this patch depends on another patch here, part of
> the fwnode parsing patchset:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg122689.html>

Any chance of sending me that patch so I can test this patch?  I'd
rather not manually de-html-ise the above patch.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
