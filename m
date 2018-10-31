Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19523 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbeJaSrV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 14:47:21 -0400
Date: Wed, 31 Oct 2018 11:49:55 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH 2/4] tw9910: No SoC camera dependency
Message-ID: <20181031094954.wmto5l7bdsjxfi6v@paasikivi.fi.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029230029.14630-3-sakari.ailus@linux.intel.com>
 <2f16f40b-e0cd-847e-8245-671bad4e6025@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f16f40b-e0cd-847e-8245-671bad4e6025@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 01:03:18PM +0100, Hans Verkuil wrote:
> On 10/30/2018 12:00 AM, Sakari Ailus wrote:
> > The tw9910 driver does not depend on SoC camera framework. Don't include
> > the header, but instead include media/v4l2-async.h which the driver really
> > needs.
> 
> You might want to make a note of the fact that soc_camera.h includes
> v4l2-async.h, so removing soc_camera.h requires adding v4l2-async.h.
> 
> I couldn't understand how it compiled before without the v4l2-async.h
> header until I saw that soc_camera.h includes it.

Yes. How about this:

Also include i2c/v4l2-async.h in drivers/media/i2c/tw9910.c as it depends
on the header which used to be included through media/soc_camera.h.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
