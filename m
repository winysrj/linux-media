Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753467AbdGSWUP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 18:20:15 -0400
Date: Thu, 20 Jul 2017 01:20:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [RFC 18/19] v4l2-fwnode: Add abstracted sub-device notifiers
Message-ID: <20170719222010.m4s3b3vy4f3l4d5t@valkosipuli.retiisi.org.uk>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-19-sakari.ailus@linux.intel.com>
 <20170718211922.GI28538@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170718211922.GI28538@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for the review!

On Tue, Jul 18, 2017 at 11:19:22PM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your hard work!
> 
> On 2017-07-18 22:04:00 +0300, Sakari Ailus wrote:
> > Add notifiers for sub-devices. The notifiers themselves are not visible for
> > the sub-device drivers but instead are accessed through interface functions
> 
> I might be missing it, but I can't find a interface function to set the 
> bound()/unbind() callbacks on a sub-notifiers :-) Is this intentional or 
> only not present in this RFC?

It's not present since I didn't need it. :-)

I'll add that for v2.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
